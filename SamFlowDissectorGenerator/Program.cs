using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;

namespace SamFlowDissectorGenerator
{
    class Program
    {
        private static string DISSECTOR_VAR = "p_sam" + "sung_flow_priv";
        private static string FLOW_DISSECTOR_TEMPALTE_PATH = "flow_dissector_template.lua"; // TODO: Make CMD arg

        static void Main(string[] args)
        {
            Assembly flowAssm = GetFlowAssembly(args);
            if (flowAssm == null)
            {
                Console.WriteLine($"Usage: {Assembly.GetExecutingAssembly().GetName().Name}.exe <sam_flow_framework_net_dll_path>");
                return;
            }

            var typesExplorer = new TypesExplorer(flowAssm);
            var typesSorter = new TypesSorter();

            // Getting the .NET type representing the root of the Sam'sung Flow messages JSON.
            Type rootType = typesExplorer.GetRootType();

            // Get All types (recursively) used by the root type
            // Only Sam'sung Flow types are collected (so .NET types like 'int' or 'string' aren't)
            List<TypeAndDependencies> typesAndDeps = typesExplorer.GetFlowTypes();
            // Export dependencies graph (disabled...)
            //DependenciesGraphExporter exp = new DependenciesGraphExporter();
            //exp.Export(typesAndDeps);

            // Sort the types in topological order
            Queue<TypeAndDependencies> sortedTypes = typesSorter.TopologicalSort(typesAndDeps);

            // Parse Every type to a ProtocolEntity which contains all info needed
            // to compose it's dissection logic
            Queue<ProtocolEntity> protoEntities = GenerateProtocolEntities(sortedTypes);

            // Combine all protocol entities into several 'dissector components' (Consts, Field Defs, etc...)
            GeneratedDissectorComponents privDissectorComponents = ComposeLuaDissector(protoEntities, rootType);

            // Get version
            FlowVersionRetriever.FlowVersion version = FlowVersionRetriever.GetVersion(flowAssm);


            // Read template file and insert our 'dissector components' instead of the placeholders
            string template = File.ReadAllText(FLOW_DISSECTOR_TEMPALTE_PATH);
            string flowDissector = CompileDissectorTemplate(template, privDissectorComponents, version);

            // Write dissector to file
            var outputFilePath = PathAdv.WriteTempFile(flowDissector, "lua");
            Console.WriteLine("Done. Written to: " + outputFilePath);
            // Open dissector in default text editor to show the user
            Process.Start(outputFilePath);
        }

        private static Assembly GetFlowAssembly(string[] args)
        {
            if (!args.Any())
            {
                return null;
            }

            string dllPath = args.First();
            if (!File.Exists(dllPath))
            {
                return null;
            }
            var assm = Assembly.LoadFrom(dllPath);
            return assm;
        }

        private static string CompileDissectorTemplate(string template, GeneratedDissectorComponents dissectorComponentsInfo, FlowVersionRetriever.FlowVersion ver)
        {
            string constantsPlaceHolder = "%%FLOW_PROTO_CONSTANTS%%";
            string privDissNamePlaceHolder = "%%FLOW_PROTO_VAR%%";
            string fieldsDefsPlaceHolder = "%%FLOW_PROTO_FIELDS_DEFINITIONS%%";
            string fieldsVarsPlaceHolder = "%%FLOW_PROTO_FIELDS_VARS%%";
            string rootElementPlaceHolder = "%%PRIV_JSON_ROOT_ELEMENT_FINFOS%%";
            string finfosPlaceHolder = "%%FLOW_PROTO_FIELDS_FINFOS%%";

            Assembly dissectorGenAssembly = typeof(Program).Assembly;
            var allAssemblies = AppDomain.CurrentDomain.GetAssemblies();
            var flowFrameworkAssembly =
                allAssemblies.Single(assm => assm.FullName.Contains("Sam" + "sungFlowFramework.NET"));
            var flowFrameworkCreationTime = File.GetCreationTime(flowFrameworkAssembly.Location);

            StringBuilder dissectorCodeBuilder = new StringBuilder(template);
            dissectorCodeBuilder.Replace(constantsPlaceHolder, dissectorComponentsInfo.Constants);
            dissectorCodeBuilder.Replace(privDissNamePlaceHolder, dissectorComponentsInfo.DissectorVariable);
            dissectorCodeBuilder.Replace(fieldsDefsPlaceHolder, dissectorComponentsInfo.FieldDefinitons);
            dissectorCodeBuilder.Replace(fieldsVarsPlaceHolder, dissectorComponentsInfo.FieldVars);
            dissectorCodeBuilder.Replace(finfosPlaceHolder, dissectorComponentsInfo.Finfos);
            dissectorCodeBuilder.Replace(rootElementPlaceHolder, dissectorComponentsInfo.RootFinfo);

            // Write header
            StringBuilder headerCommentBuilder = new StringBuilder();
            headerCommentBuilder.AppendLine(""); // Placeholder empty line
            headerCommentBuilder.AppendLine("--");
            headerCommentBuilder.AppendLine($"-- This file was generated by SamFlowDissectorGenerator (Version {dissectorGenAssembly.GetName().Version})");
            headerCommentBuilder.AppendLine($"-- Sam" + "sungFlowFramework.NET.dll Creation Time: {flowFrameworkCreationTime}");
            headerCommentBuilder.AppendLine($"-- Sam" + $"sungFlowFramework.NET.dll Version: {ver?.ToString() ?? "*MISSING*"}");
            headerCommentBuilder.AppendLine($"-- Dissector generation time: {DateTime.Now}");
            headerCommentBuilder.AppendLine("--");
            // Add fancy long lines around the header (based on it's longest line)
            int maxLineLength = headerCommentBuilder.ToString().Split('\n').Max(line => line.Length);
            headerCommentBuilder.Insert(0, new string('-', maxLineLength));
            headerCommentBuilder.AppendLine(new string('-', maxLineLength));

            StringBuilder combined = new StringBuilder();
            combined.AppendLine(headerCommentBuilder.ToString());
            combined.AppendLine(dissectorCodeBuilder.ToString());

            return combined.ToString();
        }

        private static GeneratedDissectorComponents ComposeLuaDissector(Queue<ProtocolEntity> input, Type rootType)
        {
            Queue<ProtocolEntity> protoEntities = new Queue<ProtocolEntity>(input);
            // Construct dissector
            StringBuilder constants = new StringBuilder();
            StringBuilder fieldsDefinitions = new StringBuilder(); // Instances f "local xxx = ProtoField.new( ... )"
            StringBuilder fieldsVariables = new StringBuilder(); // For use in dissector.fields = { ... }
            StringBuilder finfosArrays = new StringBuilder(); // array for every entity

            foreach (ProtocolEntity pe in protoEntities)
            {
                constants.AppendLine($"-- {pe.TypeName} Constants");
                constants.AppendLine(pe.stringConstants);
                fieldsDefinitions.AppendLine($"-- {pe.TypeName} Field Definitions");
                fieldsDefinitions.AppendLine(pe.fieldDefinitions);
                fieldsVariables.AppendLine($"-- {pe.TypeName} Field Variables");
                fieldsVariables.AppendLine(pe.fieldsVariables);

                // Generate finfos array (comes deconstructed)
                finfosArrays.AppendLine($"-- {pe.TypeName} Field-Infos");
                finfosArrays.AppendLine($"{pe.finfos_array_name} = {{\r\n{pe.finfos}\r\n}}\r\n");
            }

            var rootFinfos = input.Single(pe => pe.OriginalType == rootType).finfos_array_name;

            GeneratedDissectorComponents output = new GeneratedDissectorComponents(DISSECTOR_VAR,
                constants.ToString(),
                fieldsDefinitions.ToString(),
                fieldsVariables.ToString(),
                finfosArrays.ToString(),
                rootFinfos);

            return output;
        }

        private static Queue<ProtocolEntity> GenerateProtocolEntities(Queue<TypeAndDependencies> sortedTypes)
        {
            var gen = new ProtocolEntitiesGenerator();
            Queue<ProtocolEntity> protoEntities = new Queue<ProtocolEntity>();
            DissectorGenerationContext generatorContext = new DissectorGenerationContext();
            foreach (TypeAndDependencies typeAndDependencies in sortedTypes)
            {
                Console.WriteLine(typeAndDependencies);
                ProtocolEntity protoEnt = gen.Generate(typeAndDependencies.SelfType, generatorContext);
                // Update context so further types will recognize it 
                generatorContext.ProcessedEntities[typeAndDependencies.SelfType] = protoEnt;
                // Keeping topological order
                protoEntities.Enqueue(protoEnt);
            }

            return protoEntities;
        }
    }
}

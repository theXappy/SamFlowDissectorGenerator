using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Runtime.Serialization;
using System.Text;
using Humanizer;

namespace SamFlowDissectorGenerator
{
    public class ProtocolEntitiesGenerator
    {
        public class JsonFieldType
        {
            public static string STRING = "J_FIELD_TYPE_STRING";
            public static string NUM = "J_FIELD_TYPE_NUM";
            public static string IP = "J_FIELD_TYPE_IP";
            public static string OBJ = "J_FIELD_TYPE_OBJ";
            public static string BOOL = "J_FIELD_TYPE_BOOL";
            public static string LIST = "J_FIELD_TYPE_LIST";
        }
        public ProtocolEntity Generate(Type t, DissectorGenerationContext context)
        {
            BindingFlags allFlags = (BindingFlags)0xffff;
            StringBuilder string_consts = new StringBuilder();
            StringBuilder field_names = new StringBuilder();
            StringBuilder field_defs = new StringBuilder();
            StringBuilder finfos = new StringBuilder();
            string finfo_array_name = "";

            string className = t.Name;
            string classNameSnake = className.Underscore();
            string classAbbrvBase = new string(className.Where(char.IsUpper).ToArray());
            string classAbbrv = classAbbrvBase;
            // We might encounter conflicting abbreviations with other classes
            // so we loop until we find a free one.
            int i = 2;
            while (context.IsAbbreviationTaken(classAbbrv))
            {
                classAbbrv = classAbbrvBase + i;
                i++;
            }

            string classAbbrvLower = classAbbrv.ToLower();


            foreach (var propertyInfo in t.GetProperties(allFlags))
            {
                var dataMemberAttr = propertyInfo.GetCustomAttributes<DataMemberAttribute>().FirstOrDefault();
                if (dataMemberAttr == null)
                    continue;

                var member = dataMemberAttr.Name;
                var camel_case = member.Underscore();
                var title_case = member.Titleize();
                var upper_name = camel_case.ToUpper();

                var string_const_name = $"F_{classAbbrv}_{upper_name}";
                var string_const = $"F_{classAbbrv}_{upper_name} = \"{member}\"";
                var field_name = $"f_body_{classAbbrvLower}_{camel_case.ToLower()}";
                var field_def = $"local {field_name} = ProtoField.string(\"flow.{classNameSnake}.{camel_case.ToLower()}\", \"{title_case}\")";

                Type propType = propertyInfo.PropertyType;
                string jType = "**MISSING**";
                string innerFinfosName = string.Empty;
                if (propType == typeof(int))
                {
                    jType = JsonFieldType.NUM;
                }
                else if (propType == typeof(long))
                {
                    jType = JsonFieldType.NUM;
                }
                else if (propType.IsEnum)
                {
                    jType = JsonFieldType.NUM;
                }
                else if (propType == typeof(bool))
                {
                    jType = JsonFieldType.BOOL;
                }
                else if (propType == typeof(string))
                {
                    jType = JsonFieldType.STRING;
                }
                else if (propType.IsGenericType && propType.GetGenericTypeDefinition()
                    == typeof(List<>))
                {
                    // A list of... Objects hopefully?
                    jType = JsonFieldType.LIST;
                    Type listItemType = propType.GetGenericArguments()[0];
                    if (context.ProcessedEntities.TryGetValue(listItemType, out ProtocolEntity entity))
                    {
                        // We have an object which we already processed and made json fields for (a protocol entity)
                        // We can further parse this property using the other type's finfos
                        innerFinfosName = entity.finfos_array_name;
                    }
                }
                else
                {
                    jType = JsonFieldType.OBJ;
                    if (context.ProcessedEntities.TryGetValue(propType, out ProtocolEntity entity))
                    {
                        // We have an object which we already processed and made json fields for (a protocol entity)
                        // We can further parse this property using the other type's finfos
                        innerFinfosName = entity.finfos_array_name;
                    }
                }

                StringBuilder finfo = new StringBuilder();
                finfo.Append($"  {{{string_const_name}, {field_name}, {jType}");
                if (!string.IsNullOrEmpty(innerFinfosName))
                {
                    // For object types that we "know" - innerFinfosName won't be null so we 
                    // tell the json disector where to find it's inner finfos
                    finfo.Append($", {innerFinfosName}");
                }
                finfo.Append("},");

                string_consts.AppendLine(string_const);
                field_names.AppendLine(field_name + ",");
                field_defs.AppendLine(field_def);
                finfos.AppendLine(finfo.ToString());
            }

            finfo_array_name = ($"{classAbbrvLower}_finfos");


            return new ProtocolEntity(t,
                string_consts.ToString(),
                field_names.ToString(),
                field_defs.ToString(),
                finfos.ToString(),
                finfo_array_name,
                classAbbrv);
        }
    }
}
using System;

namespace SamFlowDissectorGenerator
{
    public class ProtocolEntity
    {
        public Type OriginalType { get; private set; }
        public string TypeName => $"{OriginalType.Name}";

        public string stringConstants { get; set; }
        public string fieldsVariables { get; set; }
        public string fieldDefinitions { get; set; }
        public string finfos { get; set; }
        public string finfos_array_name { get; private set; }
        public string abbreviation { get; private set; }

        public ProtocolEntity(Type originalType,
            string stringConstants, string fieldsVariables, string fieldDefinitions, string finfos, string finfosArrayName, string abbreviation)
        {
            this.OriginalType = originalType;
            this.stringConstants = stringConstants;
            this.fieldsVariables = fieldsVariables;
            this.fieldDefinitions = fieldDefinitions;
            this.finfos = finfos;
            finfos_array_name = finfosArrayName;
            this.abbreviation = abbreviation;
        }
    }
}
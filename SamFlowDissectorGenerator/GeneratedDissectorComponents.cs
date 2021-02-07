namespace SamFlowDissectorGenerator
{
    public class GeneratedDissectorComponents
    {
        public string DissectorVariable { get; private set; }
        public string Constants { get; private set; }
        public string FieldDefinitons { get; private set; }
        public string FieldVars { get; private set; }
        public string Finfos { get; private set; }
        public string RootFinfo { get; private set; }

        public GeneratedDissectorComponents(string dissectorVariable, string constants, string fieldDefinitons, string fieldVars, string finfos, string rootFinfo)
        {
            DissectorVariable = dissectorVariable;
            Constants = constants;
            FieldDefinitons = fieldDefinitons;
            FieldVars = fieldVars;
            Finfos = finfos;
            RootFinfo = rootFinfo;
        }
    }
}
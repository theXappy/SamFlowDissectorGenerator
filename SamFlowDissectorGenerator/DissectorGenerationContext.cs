using System;
using System.Collections.Generic;
using System.Linq;

namespace SamFlowDissectorGenerator
{
    public class DissectorGenerationContext
    {
        public Dictionary<Type, ProtocolEntity> ProcessedEntities { get; private set; } = new Dictionary<Type, ProtocolEntity>();

        public bool IsAbbreviationTaken(string queryAbbrv)
        {   
            return ProcessedEntities.Values.Any(pe => pe.abbreviation.Equals(queryAbbrv, StringComparison.InvariantCultureIgnoreCase));
        }
    }
}
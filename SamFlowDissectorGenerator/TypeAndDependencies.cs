using System;
using System.Collections.Generic;
using System.Linq;

namespace SamFlowDissectorGenerator
{
    public class TypeAndDependencies
    {
        public Type SelfType { get; private set; }
        public List<Type> Dependencies { get; private set; }

        public TypeAndDependencies(Type selfType, List<Type> dependencies)
        {
            SelfType = selfType;
            Dependencies = dependencies;
        }

        public override string ToString()
        {
            return $"{nameof(SelfType)}: {SelfType.FullName}, " +
                   $"{nameof(Dependencies)}: {{{string.Join(", ",Dependencies.Select(type=>type.FullName))}}}";
        }
    }
}
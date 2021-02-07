using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace SamFlowDissectorGenerator
{
    public class TypesExplorer
    {
        private Assembly _flowAssem;

        public TypesExplorer(Assembly flowAssem)
        {
            _flowAssem = flowAssem;
        }

        public Type GetRootType()
        {
            Type rootType = _flowAssem.GetType("Sam"+"sung.Sam"+"sungFlow.Notification.DataContracts.FlowMessage");
            return rootType;
        }

        public List<TypeAndDependencies> GetFlowTypes()
        {
            BindingFlags allFlags = (BindingFlags)0xffff;
            Type rootType = GetRootType();

            var discoveredTypeDependencies = new Dictionary<Type, HashSet<Type>>();
            var typesToExploreStack = new Stack<Type>(new[] { rootType });
            while (typesToExploreStack.Any())
            {
                Type currType = typesToExploreStack.Pop();
                if (discoveredTypeDependencies.ContainsKey(currType))
                {
                    // Already visited this type
                    continue;
                }

                // New type discovered!
                discoveredTypeDependencies[currType] = new HashSet<Type>();

                PropertyInfo[] properties = currType.GetProperties(allFlags);
                foreach (PropertyInfo propInfo in properties)
                {
                    Type propType = propInfo.PropertyType;
                    if (propType.IsEnum)
                    {
                        // I don't care about enums. They're as good as numbers to me.
                        continue;
                    }

                    // In case of a generic List<T>, extract the inner type
                    if (propType.IsGenericType && propType.GetGenericTypeDefinition()
                        == typeof(List<>))
                    {
                        propType = propType.GetGenericArguments()[0];

                    }

                    if (propType.FullName != null && propType.FullName.Contains("Flow"))
                    {
                        typesToExploreStack.Push(propType);
                        discoveredTypeDependencies[currType].Add(propType);
                    }
                }
            }

            List<TypeAndDependencies> output = discoveredTypeDependencies
                .Select(kvp => 
                                new TypeAndDependencies(kvp.Key, kvp.Value.ToList()))
                .ToList();

            return output;
        } 
    }
}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace SamFlowDissectorGenerator
{
    public class TypesSorter
    {
        BindingFlags allFlags = (BindingFlags)0xffff;
        /// <summary>
        /// Creates a queue of the types where the order of processing is from least dependent to most dependent
        /// when reaching item X in the queue, it is guaranteed that all of X's dependencies have been dequeued from the queue
        /// </summary>
        /// <param name="types"></param>
        /// <returns></returns>
        public Queue<TypeAndDependencies> TopologicalSort(IEnumerable<TypeAndDependencies> types)
        {
            // Making a copy of the lists collection we got
            List<TypeAndDependencies> notProcessed = types.ToList();

            // It looks better when we sort from types with less dependencies to types with most
            notProcessed.Sort((tadOne, tadTwo) => tadOne.Dependencies.Count.CompareTo(tadTwo.Dependencies.Count));


            List<Type> processed = new List<Type>();

            Queue<TypeAndDependencies> output = new Queue<TypeAndDependencies>();
            while (notProcessed.Any())
            {
                // Find the next available type with some LINQ kung-fu
                TypeAndDependencies next = notProcessed.First(tAndD =>
                    tAndD.Dependencies.All(dependency => processed.Contains(dependency)));

                // Adding to output, removing from work list
                output.Enqueue(next);
                processed.Add(next.SelfType);
                notProcessed.Remove(next);
            }

            return output;
        } 
    }
}
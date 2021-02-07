using System.Collections.Generic;
using System.Diagnostics;
using System.Drawing;
using System.Linq;
using GiGraph.Dot.Entities.Attributes.Enums;
using GiGraph.Dot.Entities.Graphs;
using GiGraph.Dot.Entities.Types.Colors;
using GiGraph.Dot.Extensions;

namespace SamFlowDissectorGenerator
{
    public class DependenciesGraphExporter
    {
        public void Export(IEnumerable<TypeAndDependencies> typesAndDepsEnumerable)
        {
            var typeAndDependencieses = typesAndDepsEnumerable.ToList();
            var graph = new DotGraph();
            graph.Attributes.Font.Name = "Consola";


            // set global node attributes (for all nodes of the graph)
            graph.Nodes.Attributes.Shape = DotNodeShape.Circle;
            graph.Nodes.Attributes.SetFilled(new DotColor(Color.FromArgb(90, 170, 250)));
            graph.Nodes.Attributes.BorderWidth = 3.0;
            graph.Nodes.Attributes.Font.Name = graph.Attributes.Font.Name;
            graph.Edges.Attributes.Color = (new DotColor(Color.FromArgb(57, 80, 93)));
            graph.Edges.Attributes.Width = 4.0;

            graph.Nodes.AddRange(typeAndDependencieses.Select(tAndD => tAndD.SelfType.Name));

            // Make single-rank 'subgraph' of all nodes
            //graph.Subgraphs.AddWithNodes(DotRank.Same, (list.Select(tAndD => tAndD.SelfType.Name)));

            foreach (var tAndD in typeAndDependencieses)
            {
                graph.Edges.AddOneToMany(tAndD.SelfType.Name, tAndD.Dependencies.Select(type => type.Name));
            }

            string dotPath = PathAdv.WriteTempFile(graph.Build(), "dot");
            Process.Start(@"C:\Program Files (x86)\Graphviz2.38\bin\gvedit.exe", dotPath);
        } 
    }
}
/**
 * Data Structures
 * Practice 9 - Topological sort in digraphs (without cloning the graph)
 *
 * @author Salvi CF
 */

package topoSort;

import dataStructures.dictionary.Dictionary;
import dataStructures.dictionary.HashDictionary;
import dataStructures.graph.DiGraph;
import dataStructures.list.ArrayList;
import dataStructures.list.List;
import dataStructures.set.Set;
import dataStructures.set.HashSet;
import dataStructures.tuple.Tuple2;

public class TopologicalSortingDicPar<V> {

	private List<Set<V>> topSort;
	private boolean hasCycle;

	public TopologicalSortingDicPar(DiGraph<V> graph) {

		topSort = new ArrayList<>();
		// dictionary: vertex -> # of pending predecessors
		Dictionary<V, Integer> pendingPredecessors = new HashDictionary<>();
		Set<V> sources;

		// Dictionary initiation
		for(V v : graph.vertices()){
			pendingPredecessors.insert(v, graph.inDegree(v));
		}
		
		while (!pendingPredecessors.isEmpty() && !hasCycle()){
			// Sources selection, elimination from dictionary and insertion in topological order
			sources = new HashSet<>();
			V vertex = null;
			int n_predecessors = 0;
						
	    	for (Tuple2<V, Integer> par : pendingPredecessors.keysValues()){
	    		vertex = par._1();
	    		n_predecessors = par._2();
	    		
	    		if (n_predecessors == 0){
	    			sources.insert(vertex);; // selection set of source vertices
	    			pendingPredecessors.delete(vertex); // elimination
	    		}
	    	}
	    	
	    	topSort.append(sources);
	    	
	    	if (sources.isEmpty()){ hasCycle = true; }
	    	
	    	// Sources subtraction
	    	for (V source : sources){
		    	for (V v : graph.successors(source)){
		    		pendingPredecessors.insert(v, pendingPredecessors.valueOf(v)-1);
		    	}
	    	}
		}
	}

	public boolean hasCycle() {
		return hasCycle;
	}

	public List<Set<V>> order() {
		return hasCycle ? null : topSort;
	}

}

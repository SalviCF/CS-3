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
import dataStructures.queue.LinkedQueue;
import dataStructures.queue.Queue;
import dataStructures.tuple.Tuple2;

public class TopologicalSortingDic<V> {

	private List<V> topSort;
	private boolean hasCycle;

	public TopologicalSortingDic(DiGraph<V> graph) {

		topSort = new ArrayList<>();
		// dictionary: vertex -> # of pending predecessors
		Dictionary<V, Integer> pendingPredecessors = new HashDictionary<>();
		Queue<V> sources = new LinkedQueue<>();
		
		// Dictionary initiation
		for(V v : graph.vertices()){
			pendingPredecessors.insert(v, graph.inDegree(v));
		}
		
		while (!pendingPredecessors.isEmpty() && !hasCycle()){
			// Sources selection, elimination from dictionary and insertion in topological order
			V vertex = null;
			int n_predecessors = 0;
						
	    	for (Tuple2<V, Integer> par : pendingPredecessors.keysValues()){
	    		vertex = par._1();
	    		n_predecessors = par._2();
	    		
	    		if (n_predecessors == 0){
	    			sources.enqueue(vertex); // selection
	    			pendingPredecessors.delete(vertex); // elimination
	    			topSort.append(vertex); // insertion
	    		}
	    	}
	    	
	    	if (sources.isEmpty()){ hasCycle = true; }
	    	
	    	// Sources subtraction
	    	V source = null;
	    	while (!sources.isEmpty()){
	    		source = sources.first();
	    		for (V v : graph.successors(source)){
	    			pendingPredecessors.insert(v, pendingPredecessors.valueOf(v)-1);
	    		}
	    		sources.dequeue();
	    	}
		}
	}

	public boolean hasCycle() {
		return hasCycle;
	}

	public List<V> order() {
		return hasCycle ? null : topSort;
	}
}

/**
 * Data Structures
 * @author Salvi CF
 */

package dataStructures.graph;

import dataStructures.list.*;

public class EulerianCycle<V> {
    private List<V> eCycle;

    @SuppressWarnings("unchecked")
    public EulerianCycle(Graph<V> g) {
        Graph<V> graph = (Graph<V>) g.clone();
        eCycle = eulerianCycle(graph);
    }

    public boolean isEulerian() {
        return eCycle != null;
    }

    public List<V> eulerianCycle() {
        return eCycle;
    }

    // J.1	Change "private" for "public" to test the function in main program
    private static <V> boolean isEulerian(Graph<V> g) {
        // TO DO
    	for (V v : g.vertices()){
    		if (g.degree(v) % 2 != 0){
    			return false;
    		}
    	}
        return true;
    }

    // J.2
    private static <V> void remove(Graph<V> g, V v, V u) {
        // TO DO
    	// Delete the edge
    	g.deleteEdge(v, u);	// graph without edge (u, v)
    	
    	// Delete nodes with degree 0
    	for (V vert : g.vertices()){
    		if (g.degree(vert) == 0){
    			g.deleteVertex(vert);
    		}
    	}
    }

    // J.3
    private static <V> List<V> extractCycle(Graph<V> g, V v0) {
        // TO DO
    	List<V> ciclo = new ArrayList<>();
    	ciclo.append(v0);
    	
    	V current = v0;
    	V suc = null;
    	
    	while (suc != v0){
        	for (V v : g.successors(current)){
        		suc = v;
        		break;
        	}
        	ciclo.append(suc);
        	remove(g, current, suc);
        	current = suc;
    	}
    	
        return ciclo;
    }

    // J.4
    // https://www.arquitecturajava.com/java-value-vs-reference-y-sus-curiosidades/
    private static <V> void connectCycles(List<V> xs, List<V> ys) {
    	// TO DO
    	// List<V> aux = new ArrayList<>(); xs = aux; this does not modify xs...
    	
    	if (xs.isEmpty()){
    		for (V v : ys){
    			xs.append(v);
    		}
    	} else {
    		V y = ys.get(0);
    		int idx = 0;
    		for (V v : xs){
    			if (v == y){
    				xs.remove(idx);
    				for (V u : ys){
    					xs.insert(idx, u);
    					idx++;
    				}
    				break;
    			}
    			idx++;
    		}
    	}
    }

    // J.5
    public static <V> V vertexInCommon(Graph<V> g, List<V> cycle) {
    	// TO DO
    	V res = null;
    	for (V v : g.vertices()){
    		for (V u : cycle){
    			if (v == u){
    				res = v;
    				break;
    			}
    		} 
    		if (res != null){ break; }
    	} 
    	return res;
    }

    // J.6
    private static <V> List<V> eulerianCycle(Graph<V> g) {
    	// TO DO
    	if (isEulerian(g)){
        	
        	List<V> ciclo = new ArrayList<>();
        	List<V> parcial = new ArrayList<>();
        	V vc = null;	// vertex in common
        	while (!g.isEmpty()){
            	for (V v : g.vertices()){	// extract one vertex of the graph
            		vc = v;
            		break;
            	}
            	parcial = extractCycle(g, vc);
            	connectCycles(ciclo, parcial);
            	vc = vertexInCommon(g, parcial);
        	}
        	
            return ciclo;
    	}
    	return null;
    }
}
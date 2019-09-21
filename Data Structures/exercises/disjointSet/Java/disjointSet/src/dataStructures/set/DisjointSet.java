package dataStructures.set;

import dataStructures.list.List;

public interface DisjointSet<T>{

	boolean isEmpty();
	
	boolean isElem(T x);
	
	int numElements();
	
	void add(T x);
	
	boolean areConnected(T elem1, T elem2);
	
	List<T> kind(T elem);
	
	void union(T elem1, T elem2);
	
	void flatten();
	
	List<List<T>> kinds();
}

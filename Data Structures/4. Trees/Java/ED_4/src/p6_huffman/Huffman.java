package p6_huffman;

/**
 * Huffman trees and codes.
 *
 * Data Structures
 * 
 * @author Salvi CF
 */

import dataStructures.dictionary.AVLDictionary;
import dataStructures.dictionary.Dictionary;
import dataStructures.heap.BinaryHeap;
import dataStructures.list.LinkedList;
import dataStructures.list.List;
import dataStructures.priorityQueue.BinaryHeapPriorityQueue;
import dataStructures.priorityQueue.PriorityQueue;
import dataStructures.tuple.Tuple2;

public class Huffman {

    // Exercise 1
    public static Dictionary<Character, Integer> weights(String s) {
    	// Creates the dictionary
    	Dictionary<Character, Integer> dict = new AVLDictionary<>();
    	
    	// Traverses the string and insert or update
    	for (int i=0; i<s.length(); i++){
    		char c = s.charAt(i);
    		if (dict.isDefinedAt(c)){
    			dict.insert(c, dict.valueOf(c)+1);
    		} else {
    			dict.insert(c, 1);
    		}
    	}
        return dict;
    }

    // Exercise 2.a
    public static PriorityQueue<WLeafTree<Character>> huffmanLeaves(String s) {
    	// Creates the priority queue and the dictionary
    	PriorityQueue<WLeafTree<Character>> q = new BinaryHeapPriorityQueue<>();
    	Dictionary<Character, Integer> dict = weights(s);
    	
    	// Traverses the dictionary and enqueue each leaf tree
    	for (Tuple2<Character, Integer> par : dict.keysValues()){
    		WLeafTree<Character> hoja = new WLeafTree<>(par._1(),par._2());
    		q.enqueue(hoja);
    	}
    	
    	return q;
    }

    // Exercise 2.b
    public static WLeafTree<Character> huffmanTree(String s) {
    	// Creates the priority queue with the leafs
    	PriorityQueue<WLeafTree<Character>> q = huffmanLeaves(s);
    	boolean salir = false;
    	
    	WLeafTree<Character> single = q.first(); 
    	q.dequeue();
    	if (q.isEmpty()){ // Has queue only one tree?
    		throw new HuffmanException("the string must have at "
    				+ "least two different symbols");
    	} else {
    		q.enqueue(single);
    	}
    	
    	while ( !salir ){
        	// First tree with least weight
        	WLeafTree<Character> first = q.first();
        	
        	// Extract that tree from queue
        	q.dequeue();
        
        	
        	// Second tree with least weight
        	WLeafTree<Character> second = q.first();
        	
        	// Extract that tree from queue
        	q.dequeue();
        	
        	// "mezcla" is the merge of "first" and "second"
        	WLeafTree<Character> mezcla = new WLeafTree<>(first, second);
        	
        	if (q.isEmpty()){
        		q.enqueue(mezcla); // single element, returns the resulting tree
        		salir = true;
        	} else {
        		q.enqueue(mezcla); // keep going
        	}
    	}  	
    	
    	return q.first();
    }

    // Exercise 3.a
    public static Dictionary<Character, List<Integer>> joinDics(Dictionary<Character, List<Integer>> d1, Dictionary<Character, List<Integer>> d2) {
    	Dictionary<Character, List<Integer>> nDict = new AVLDictionary<>();
    	
    	// Traverses the elements of d1 and inserts them into nDict
    	for (Tuple2<Character, List<Integer>> par : d1.keysValues()){
    		nDict.insert(par._1(), par._2());
    	}
    	
    	// Traverses the elements of d2 and inserts them into nDict
    	for (Tuple2<Character, List<Integer>> par : d2.keysValues()){
    		nDict.insert(par._1(), par._2());
    	}
    	
    	return nDict;
    }

    // Exercise 3.b
    public static Dictionary<Character, List<Integer>> prefixWith(int i, Dictionary<Character, List<Integer>> d) {
    	Dictionary<Character, List<Integer>> nDict = new AVLDictionary<>();
    	
    	// Traverses the dictionary 
    	for (Tuple2<Character, List<Integer>> par : d.keysValues()){
    		List<Integer> lista = par._2();
    		lista.prepend(i);
    		nDict.insert(par._1(), lista);
    	}
    	
    	return nDict;
    }

    // Exercise 3.c
    public static Dictionary<Character, List<Integer>> huffmanCode(WLeafTree<Character> ht) {
    	
    	if (ht.isLeaf()){
    		Dictionary<Character, List<Integer>> d = new AVLDictionary<>();
    		d.insert(ht.elem(), new LinkedList<>());
    		return d;
    	}
    	
    	Dictionary<Character, List<Integer>> d1 = prefixWith(0, huffmanCode (ht.leftChild()));
    	Dictionary<Character, List<Integer>> d2 = prefixWith(1, huffmanCode (ht.rightChild()));
    	
    	return joinDics(d1, d2);
    }

    // Exercise 4
    public static List<Integer> encode(String s, Dictionary<Character, List<Integer>> hc) {
    	// Creates the list to return
    	List<Integer> lista = new LinkedList<>();
    	
    	// Traverses the string char by char 
    	for (int i=0; i<s.length(); i++){
    		char c = s.charAt(i);
    		
    		List<Integer> valores = hc.valueOf(c); // code of char c (list of 0's and 1's)
    		for (Integer x : valores){ // append each integer of the list
    			lista.append(x);
    		}
    	}
    	return lista;
    }

    // Exercise 5
    public static String decode(List<Integer> bits, WLeafTree<Character> ht) {
    	WLeafTree<Character> init = ht;
    	String res = "";
    	
    	while (bits.size()>0){
    		if (bits.get(0) == 0){
    			bits.remove(0);
    			ht = ht.leftChild();
    		} else {
    			bits.remove(0);
    			ht = ht.rightChild();
    		}
    		if (ht.isLeaf()){
    			res += ht.elem().toString();
    			ht = init;
    		}
    		
    	}

    	return res;
    }
}

package p4_TAD_bag;
import java.util.Iterator;

import dataStructures.bag.*;

public class PruebaIterator {

	public static void main(String[] args) {
		
		//SortedLinkedBag<Integer> s = new SortedLinkedBag<>();
		SortedArrayBag<Integer> s = new SortedArrayBag<>();
		s.insert(7);
		s.insert(3);
		s.insert(5);
		s.insert(5);
		s.insert(5);
		System.out.println(s.toString());
		
		Iterator<Integer> it = s.iterator();
		
		while (it.hasNext()){
			System.out.println(it.next());
		}
		
		for (Integer x : s){
			System.out.println(x);
		}
	}

}



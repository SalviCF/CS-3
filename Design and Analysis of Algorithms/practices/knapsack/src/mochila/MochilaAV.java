package mochila;

import java.util.*;

/**
 * 
 * @author ***** Salvador CF *******
 *
 */
public class MochilaAV extends Mochila {

	public SolucionMochila resolver(ProblemaMochila pm) {
		SolucionMochila sm = null;
		
		int tam = pm.size();
			
	// 1. Get the items
		
		ArrayList<Item> items = pm.getItems();
		
	/*
	* Sorts the specified list according to the order induced by the specified comparator
	* Sorting the items by ratio (value/weight) in decreasing order
	* Method compare: returns a negative integer, zero, or a positive integer as the first argument
	* 	is less than, equal to, or greater than the second.
	* 
	* For decreasing order, return negative if ratio of 1st item is greater than ratio of 2nd item
	* and positive if it is less than. Making the opposite to the natural order.
	*/	
		Collections.sort(items, new Comparator<Item>() {
	        @Override public int compare(Item i1, Item i2) {
	        	double ratio1 = (double) i1.valor / i1.peso;
	    		double ratio2 = (double) i2.valor / i2.peso;
	    		if (ratio1 > ratio2){return -1;}
	    		if (ratio1 < ratio2){return 1;}
	    		return 0;
	        }

	    });
		
		int[] sol = new int[tam];
		int pesoLibre = pm.getPesoMaximo();
		for (int i=0; i<tam; i++){
			if (items.get(i).peso <= pesoLibre){
				sol[items.get(i).index] = 1;
				pesoLibre -= items.get(i).peso;
			}
		}
		
		sm = new SolucionMochila(sol, pm.sumaPesos(sol), pm.sumaValores(sol));
		return sm;
	}
}


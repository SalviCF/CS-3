package mochila;

import java.util.*;

/**
 * 
 * @author ***** Salvador CF *******
 *
 */
public class AvidoArrayList extends Mochila {

	public SolucionMochila resolver(ProblemaMochila pm) {
		SolucionMochila sm = null;
		
		int tam = pm.size();
		int pesos[] = pm.getPesos();
		int valores[] = pm.getValores();
		
	// 1. Computing the ratios ////////////////////////////////////////////////////////////////////
		
		ArrayList<Double> ratios = new ArrayList<Double>(tam);
		
		for (int i=0; i<tam; i++){
			double r = (double) valores[i] / pesos[i]; // casting a double
			ratios.add(r);
		}
		
	// 2. It will store the indices of the max ratios in crescent order //////////////////////////
		
		int[] indices = new int[tam]; 
		
		for (int j=0; j<tam; j++){
			double max = Collections.max(ratios); // 1. max ratio of the ArrayList
			int index = ratios.indexOf(max);	  // 2. index of the max ratio
			indices[j] = ratios.indexOf(max);     // 3. save the index of the max ratio
			ratios.set(index, -1.0);			  // 4. store -1 in the position index 
											      //    for calculate next max ratio
		}
		
		/* Effect:
		* 
		*  indices[0] = index of the 1st max ratio
		*  indices[1] = index of the 2nd max ratio
		*  					.
		*					.
		*					.
		*/
		
		int pesoLibre = pm.getPesoMaximo();
		int[] solucion = new int[tam];
		
	// 3. Select an item, if it fits in the knapsack then store it, else, go to the next item
		
		for (int k=0; k<tam; k++){
			if ( pesos[indices[k]] <= pesoLibre ){ // weight of the 1st max ratio
				solucion[indices[k]] = 1;          // 1 in the position of the element with max ratio
												   // that fits in the knapsack
				pesoLibre = pesoLibre - pesos[indices[k]];
			}
		}
		
		sm = new SolucionMochila(solucion, pm.sumaPesos(solucion), pm.sumaValores(solucion));
		return sm;
	}
}


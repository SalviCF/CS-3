package paquete;

import java.util.Arrays;

public class Mochila01_Backtrack {

	public static void main(String[] args) {
		
		int[] pesos = {4,4,2,4,1};
		int[] valores = {1,2,1,4,2};
		int pesoMax = 3;
		int[]sol = new int[pesos.length];
		
		int peso = 0;
		int beneficio = 0;
		int beneficio_mejor = -1;
		int[] sol_mejor = new int[pesos.length];
		int k = 0;
		
		int[] sol_final = new int[pesos.length];
		int beneficio_final = -1;

		mochilaBT(pesos,valores,pesoMax,sol,k,peso,
					beneficio,sol_mejor,beneficio_mejor);
		
		System.out.println(Arrays.toString(sol_final));
		System.out.println(beneficio_final);
	}
	
	public static void mochilaBT (int[] pesos, int[] valores, int pesoMax, int[] sol, int k, 
									int peso, int beneficio, int[] sol_mejor, int beneficio_mejor){
	// Left child - take item, no estimation
		sol[k] = 1; // takes the item
		peso += pesos[k]; beneficio += valores[k]; // marking, actualize the knapsack
		if (peso <= pesoMax){
			if (k == pesos.length-1){ // all the objects has been analyzed  
				sol_mejor = sol; beneficio_mejor = beneficio; // solution found
			} else { 
				mochilaBT(pesos,valores,pesoMax,sol,k+1,peso,
							beneficio,sol_mejor,beneficio_mejor);
			} 
		}
		peso -= pesos[k]; beneficio -= valores[k]; // no mark, the object surpasses the capacity
		
	// Right child - don't take item, no mark but estimation is done
		sol[k] = 0;
		double beneficio_estimado = estimar(pesos,valores,pesoMax,k,peso,beneficio);
		if (beneficio_estimado>beneficio_mejor){
			if (k==pesos.length-1){
				sol_mejor = sol; beneficio_mejor = beneficio;
			} else {
				mochilaBT(pesos,valores,pesoMax,sol,k+1,peso,beneficio,
							sol_mejor,beneficio_mejor);
			}
		} 
	}
	
	// To find out if a extension will be better than the current sol_mejor
	public static double estimar (int[] pesos, int[] valores, int pesoMax,
									int k, int peso, int beneficio){
		int hueco = pesoMax-peso;
		double estimacion = beneficio;
		int j = k+1;
		while (j<pesos.length && pesos[j]<=hueco){ // it's possible to take the item
			hueco -= pesos[j];
			estimacion += valores[j];
			j++;
		}
		if (j<pesos.length){ // there are other items to check
			estimacion += (hueco/pesos[j])*valores[j];
		}
		return estimacion;
	}

}

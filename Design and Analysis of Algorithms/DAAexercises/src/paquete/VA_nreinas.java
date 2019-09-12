package paquete;

import java.util.*;

public class VA_nreinas {
	
	public static int n = 4;
	public static int[] sol = new int[n];
	public static boolean found = false;
	public static ArrayList<int[]> solAll = new ArrayList<int[]>(); //to store all solutions

	public static void main(String[] args) {

		int etapa = 0;
		//vueltaAtras(etapa); //1 st solution
		vaTodas(etapa); //all solutions
		
		for(int i=0; i<solAll.size(); i++){
			System.out.println(Arrays.toString(solAll.get(i)));
		}
	}

	//Calculates ONE solution
	public static void vueltaAtras(int etapa) {
		for (int col=0; col<n && !found; col++){//found controls the entry to the loop
			sol[etapa] = col;
			if (valido(etapa)){
				if (etapa == n-1){
					found=true;
					System.out.println(Arrays.toString(sol));
				} else {
					vueltaAtras(etapa+1);
				}
			}
		}
	}
	
	//Indicates if is correct to place a queen in a specific stage
	public static boolean valido(int etapa) { 
		for (int i=0; i<etapa; i++){
			if ((sol[i] == sol[etapa]) || (Math.abs(sol[i]-sol[etapa]) == Math.abs(i-etapa))){
				return false;
			}
		}
		return true;
	}

	/**
	 * Calculates ALL possible solutions
	 * @param etapa: stage
	 */
	public static void vaTodas(int etapa) {
		for (int col=0; col<n; col++){
			sol[etapa] = col;
			if (valido(etapa)){
				if (etapa == n-1){
					//System.out.println(Arrays.toString(sol));
					solAll.add(sol.clone()); 
				} else {
					vaTodas(etapa+1);
				}
			}
		}
	}
}



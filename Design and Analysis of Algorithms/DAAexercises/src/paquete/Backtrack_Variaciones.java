package paquete;

import java.util.Arrays;

public class Backtrack_Variaciones {

	public static void main(String[] args) {
	
	// Variations of n elements, taken from m in m
		String[] letras = {"a", "b", "c"}; // set of letters, n=3
		int m = 2; // to form all words with m letters
		
		int n = letras.length; // number of elements
		int[] sol = new int[m]; // taken in groups of m
		int k=0; // index
		
		System.out.println("Variaciones sin repetición de "+Arrays.toString(letras));
		variaciones(n,sol,k,letras); // include letters for print them
		
	}
	
	public static void variaciones(int n, int[] sol, int k, String[] letras){
		for (int j=0; j<n; j++){
			sol[k] = j;
			if (noRepetida(sol,k)){
				if(k==sol.length-1){
					System.out.print(Arrays.toString(sol));
					System.out.print(" -> ");
					printSol(sol,letras);
				} else {
					variaciones(n,sol,k+1,letras);
				}
			}
		}
	}
	
	public static boolean noRepetida(int[] sol, int k){
	// Checks if the letters in sol[k] appears in sol[1...k-1]
		int i=0;
		while(sol[i] != sol[k]){
			i++;
		} return (i==k);
	}
	
	public static void printSol(int[] sol, String[] letras){
	// Prints the letters pointed by the indices in sol
		for (int i=0; i<sol.length; i++){
			System.out.print(letras[sol[i]]);
		} System.out.println();
	}
}

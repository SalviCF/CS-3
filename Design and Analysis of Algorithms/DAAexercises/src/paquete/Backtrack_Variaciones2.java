package paquete;

import java.util.Arrays;

/*
 * Improving Backtrack_Variaciones avoiding the function "noRepetida" by using 
 * the marking/checking technique.
 * 
 * The marker will be an array usada[0...n-1] of booleans.
 * usada[] indicates if the letter has been included in the partial solution or not.
 */

public class Backtrack_Variaciones2 {

	public static void main(String[] args) {
	
	// Variations of n elements, taken from m in m
		String[] letras = {"a", "b", "c"}; // set of letters, n=3
		int m = 3; // to form all words with m letters
		
		int n = letras.length; // number of elements
		int[] sol = new int[m]; // taken in groups of m
		int k=0; // index
		boolean[] usada = new boolean[n];
		
		System.out.println("Variaciones sin repetición de "+Arrays.toString(letras));
		variaciones(n,sol,k,letras,usada); // include letters for print them
		
	}
	
	public static void variaciones(int n, int[] sol, int k, String[] letras,boolean[] usada){
		for (int j=0; j<n; j++){
			if (!usada[j]){
				sol[k] = j;
				usada[j] = true; // marcar
				if (k == sol.length-1){
					System.out.print(Arrays.toString(sol)+"->");
					printSol(sol,letras);
				} else {
					variaciones(n,sol,k+1,letras,usada);
				} usada[j] = false; // desmarcar
			}
		}
	}
	
	
	public static void printSol(int[] sol, String[] letras){
	// Prints the letters pointed by the indices in sol
		for (int i=0; i<sol.length; i++){
			System.out.print(letras[sol[i]]);
		} System.out.println();
	}
}


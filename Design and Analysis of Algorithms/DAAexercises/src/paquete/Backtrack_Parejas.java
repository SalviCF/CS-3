 package paquete;

import java.util.Arrays;

public class Backtrack_Parejas {

	public static void main(String[] args) {
		int n = 3; // number of couples
		int[][] h = {{6,4,8},
					 {7,2,3},
					 {10,6,6}}; // h[i][j] = preference of man i for woman j 
		int[][] m = {{3,2,4},
				 	 {2,0,0},
				 	 {7,7,4}}; // m[i][j] = preference of woman i for man j
		
		int[] sol = new int[n]; // sol[i] = man assigned to woman i
		int k=0; // index
		// marker. Indicates if a man has been assigned to a woman
		boolean[]asignado = new boolean[n]; 
		
		parejas(h,m,sol,k,asignado);
		
	}
	
	public static void parejas(int[][] h, int[][] m, int[] sol, int k, boolean[] asignado){
		
		for (int hombre=0; hombre<h.length; hombre++){
			if (!asignado[hombre]){
				sol[k] = hombre;
				asignado[hombre] = true; // marcado
				if (estable(h,m,sol,k)){
					if (k == h.length-1){
						System.out.println(Arrays.toString(sol));
					} else {
						parejas(h,m,sol,k+1,asignado);
					}
				} asignado[hombre] = false; // desmarcado
			}
		}
	}
	
	public static boolean estable (int[][] h, int[][] m, int[] sol, int k){
		boolean respuesta = true;
		int i=0;
		while (i<k && respuesta){
			respuesta = ((m[k][sol[i]] <= m[k][sol[k]]) || (h[sol[i]][k] <= h[sol[i]][i])) 
					    && ((m[i][sol[k]] <= m[i][sol[i]]) || (h[sol[k]][i] <= h[sol[k]][k]));
			i++;
		} return respuesta;
	}

}

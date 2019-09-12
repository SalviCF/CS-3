package paquete;

import java.util.Arrays;

public class VA_parejas {

	public static int n;
	public static int[] sol;
	public static int[] sol_mejor;
	public static int suma;
	public static int suma_mejor;
	public static int[][] h = {{6,4,8},
			 {7,2,3},
			 {10,6,6}}; // h[i][j] = preference of man i for woman j 
	public static int[][] m = {{3,2,4},
		 	 {2,0,0},
		 	 {7,7,4}}; // m[i][j] = preference of woman i for man j
	
	public static void main(String[] args) {
		n = 3; // number of couples
		sol = new int[n]; // sol[i] = man assigned to woman i
		int k=0; // index
		suma=0;
		suma_mejor=0;
		parejas(k);
		System.out.println(Arrays.toString(sol_mejor));
		System.out.println(suma_mejor);
	}
	
	public static void parejas(int mujer){
		for (int hombre=0; hombre<n; hombre++){
			sol[mujer] = hombre;
			suma += h[hombre][mujer] * m[mujer][hombre]; //make sum
			if (factible(mujer)){
				if (mujer == n-1){
					if(suma > suma_mejor){
						suma_mejor = suma;
						sol_mejor = sol.clone();
					}
				} else {
					parejas(mujer+1);
				}
			}
			suma -= h[hombre][mujer] * m[mujer][hombre]; //undo sum
		}
		
	}
	
	public static boolean factible (int mujer){
		int i=0;
		while (sol[i] != sol[mujer]){
			i++;
		} return (i==mujer);
	}
}


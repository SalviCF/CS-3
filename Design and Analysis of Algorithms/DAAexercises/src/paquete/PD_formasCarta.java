// Ejercicio 13.3 de programación dinámica. 
// Libro: Estructuras de datos y métodos algorítmicos

package paquete;

import java.util.Arrays;

public class PD_formasCarta {

	public static void main(String[] args) {
		
		int[] valorSello = {1,3,5};
		int tam = valorSello.length;
		int tarifa = 5;
		
	// 1. Definition of the table ////////////////////////////////////////////////////////
		
		int[][] formasCarta = new int[tam+1][tarifa+1];
		
	// 2.Construction of the table //////////////////////////////////////////////////////
		
		// If 1st column, the only possibility is 1: use no seal
		for (int i=1; i<=tam; i++){formasCarta[i][0] = 1;} 
		
		// If 1st row, there is no form possible
		for (int j=0; j<=tarifa; j++){formasCarta[0][j] = 0;}
		
		/* Prints the table
		 * 
		 * for (int i=0; i<=tam; i++){
		 *	for (int j=0; j<=tarifa; j++){
		 *		System.out.print(formasCarta[i][j]+" ");
		 *	} System.out.println();
		 * }
		 * 
		 */
		
	// Sin memo
		for (int i=1; i<=tam; i++){
			for (int j=1; j<=tarifa; j++){
				if (valorSello[i-1] > j){
					formasCarta[i][j] = formasCarta[i-1][j];
				} else {
					formasCarta[i][j] = formasCarta[i-1][j] + formasCarta[i][j-valorSello[i-1]];
				}
			}
		}
		
		System.out.println(formasCarta[tam][tarifa]);

	// Con memo
		
		int[] formas = new int[tarifa+1];
		formas[0] = 1;
		for (int i=1; i<=tam; i++){
			for (int j=valorSello[i-1]; j<=tarifa; j++){
				formas[j] = formas[j] + formas[j - valorSello[i-1]];
			}
		}
		
		System.out.println(Arrays.toString(formas));
	}

}

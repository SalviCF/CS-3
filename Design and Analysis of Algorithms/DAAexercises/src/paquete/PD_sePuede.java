// Ejercicio 13.4, Estructuras de Datos y métodos algorítmicos.

package paquete;

import java.util.stream.IntStream;

public class PD_sePuede {

	public static void main(String[] args) {
		
		int[] pesos = {2,3,4,5};
		int tam = pesos.length;
		int pesoTotal = IntStream.of(pesos).sum();
		
		boolean[][] tabla = new boolean[tam+1][(pesoTotal/2)+1];
		
		/*
		 * 
		 * for (int i=0; i<=tam; i++){
		 *	for (int j=0; j<=(pesoTotal/2); j++){
		 *		System.out.print(tabla[i][j]+" ");
		 *	}  System.out.println();
		 * }
		 * 
		 */
		
		for (int i=0; i<=tam; i++){tabla[i][0] = true;}
		for (int j=1; j<=(pesoTotal/2); j++){tabla[0][j] = false;}
	
		for (int i=1; i<=tam; i++){
			for (int j=1; j<=(pesoTotal/2); j++){
				if (pesos[i-1] > j){
					tabla[i][j] = tabla[i-1][j];
				} else {
					tabla[i][j] = tabla[i-1][j] || tabla[i-1][j-pesos[i-1]];
				}
			}
		}
		
		for (int i=0; i<=tam; i++){
			 	for (int j=0; j<=(pesoTotal/2); j++){
					System.out.print(tabla[i][j]+" ");
			 	}  System.out.println();
			  }
	
		// System.out.println(tabla[tam][pesoTotal/2]);
		
	// With memo
		
		boolean[] vector = new boolean[(pesoTotal/2)+1];
		vector[0] = true;
		
		for (int i=1; i<=(pesoTotal/2); i++){vector[i] = false;}
		
		for (int i=1; i<=tam; i++){
			for (int j=(pesoTotal/2); j>=pesos[i-1]; j--){
				vector[j] = vector[j] || vector[j-pesos[i-1]];
			}
		}
	}

}

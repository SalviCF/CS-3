package paquete;

import java.util.Arrays;

public class PD_monedas2 {

	public static void main(String[] args) {
		
		int[] valoresMonedas = {1,4,6};
		int tam = valoresMonedas.length;
		int cantidad = 8;

	// 1. Definition of the array
		
		int[]NumMinMonedas = new int[cantidad+1];
		NumMinMonedas[0] = 0;
		for (int i=1; i<=cantidad; i++){
			NumMinMonedas[i] = Integer.MAX_VALUE-1; // -1 because 1+Integer.MAX_VALUE = Integer.MIN_VALUE
		}
		System.out.println(Arrays.toString(NumMinMonedas));
	// 2. Construction of the table
		
		for (int i=1; i<=tam; i++){
			for (int j=valoresMonedas[i-1]; j<=cantidad; j++){
				NumMinMonedas[j] = Math.min(NumMinMonedas[j], NumMinMonedas[j-valoresMonedas[i-1]]+1);
				System.out.println(Arrays.toString(NumMinMonedas));
			} 
		}
		
	// 3. Finding the number of each coin
		
		int[] cuantas = new int[tam]; // how many of each type of coin
		int queda = cantidad; // remaining to pay
		int i = tam; 
		
		while (queda > 0){
			if (valoresMonedas[i-1] <= queda && 
					NumMinMonedas[queda] == NumMinMonedas[queda-valoresMonedas[i-1]]+1){
				cuantas[i-1] += 1;
				queda -= valoresMonedas[i-1];
			} else { i--; }
		}
		System.out.println();
		System.out.println(Arrays.toString(cuantas));
	}

}

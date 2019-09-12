package paquete;

import java.util.Arrays;

public class PD_monedas {
	
	public static void main(String[] args) {
		int[] valoresMonedas = {4,1,6};
		int tam = valoresMonedas.length;
		int cantidad = 8;

	// 1. Definition table ///////////////////////////////////////////////////////////////////////
		
		int[][] NumMinMonedas = new int[tam+1][cantidad+1];
		
	// 2. Construction of the table /////////////////////////////////////////////////////////////
		
		for (int i=0; i<=tam; i++){NumMinMonedas[i][0] = 0;} // if 1st column
		for (int j=1; j<=cantidad; j++){NumMinMonedas[0][j] = Integer.MAX_VALUE-1;} // if 1st row
		// -1 because in Math.min[..] 1 + MAX_VALUE = MIN_VALUE, making the reconstruction wrong
		
		for (int i=1; i<=tam; i++){
			for (int j=1; j<=cantidad; j++){
				if (valoresMonedas[i-1] > j){
					NumMinMonedas[i][j] = NumMinMonedas[i-1][j]; 
				} else {
					NumMinMonedas[i][j] = Math.min(NumMinMonedas[i-1][j],
												   1+NumMinMonedas[i][j-valoresMonedas[i-1]]);
				}
			}
		}
		
		
		for (int i=0; i<=tam; i++){
			for (int j=0; j<=cantidad; j++){
				System.out.print(NumMinMonedas[i][j]+" ");
			} System.out.println();
		}
		
		
	// 3. Find the number of each coin /////////////////////////////////////////////////////////
		
		int[] cuantas = new int[tam];
		int queda = cantidad;
		
		for (int i=tam; queda>0; i--){
			if (NumMinMonedas[i-1][queda] > NumMinMonedas[i][queda]){
				cuantas[i-1] += 1;
				queda -= valoresMonedas[i-1];
				i++;
			}
		}
		
		System.out.println(Arrays.toString(cuantas));
	}

}

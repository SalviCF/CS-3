package mochila;
import java.util.Arrays;


// http://www.micsymposium.org/mics_2005/papers/paper102.pdf

public class Ejemplo {

	public static void main(String[] args) {
		
// 1. Problem definition ///////////////////////////////////////////////////////////////////
		
		int[] pesos = {7,3,4,5};
		int[] valores = {42,12,40,25};
		int pesoMaximo = 10;
		ProblemaMochila pm = new ProblemaMochila(pesos, valores, pesoMaximo);
		
// 2. Solution definition //////////////////////////////////////////////////////////////////
		
		int tam = pm.size();
		int[] bits = new int[tam];
		SolucionMochila sm = new SolucionMochila(bits, 0, 0);
		bits[tam-1] = 1;
		
		
// 3. Looking for the 2^n combinations /////////////////////////////////////////////////////
	
		double comb = Math.pow(2, tam); 
		int mayorBeneficio = 0;
		int mejorPeso = 0; 

		for (int i=0; i<comb-1; i++){ 
			System.out.println("Entrada "+i);
			System.out.println(Arrays.toString(bits));
			
			int pesoComb = pm.sumaPesos(bits);
			int valorComb = pm.sumaValores(bits);
			
		// Info
			System.out.println("Peso:"+pesoComb);
			if (pesoComb>pesoMaximo){
				System.out.println("Beneficio: -");
			} else {
				System.out.println("Beneficio:"+valorComb);
			} System.out.println();
			
			
		// Better combination?
			if (pesoComb <= pesoMaximo && valorComb > mayorBeneficio){
				mayorBeneficio = valorComb;
				mejorPeso = pesoComb;
				sm = new SolucionMochila(bits, mejorPeso, mayorBeneficio);
			}
			
		// Next combination
			if (i!=comb-2){
				int j = tam-1;
				while (bits[j] != 0){
					bits[j] = 0;
					j--;
				}
				bits[j] = 1;
			}
		}
		System.out.println("Solución: " + sm);
	}

}

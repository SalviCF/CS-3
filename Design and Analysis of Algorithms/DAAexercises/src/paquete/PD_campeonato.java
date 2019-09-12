// Ejercicio 13.5. Estructuras de Datos y métodos algorítmicos.

package paquete;

import java.util.Arrays;

public class PD_campeonato {

	public static void main(String[] args) {
		double p, q;
		p = 0.6;
		q = 1 - p;
		int partidos = 5;
		
		double[][] tabla = new double[partidos+1][partidos+1];
		
		for (int i=1; i<=partidos; i++){tabla[i][0] = 0;}
		for (int j=1; j<=partidos; j++){tabla[0][j] = 1;}
		for (int i=1; i<=partidos; i++){
			for (int j=1; j<=partidos; j++){
				tabla[i][j] = p*tabla[i-1][j] + q*tabla[i][j-1];
			}
		}
		
		for (int i=0; i<=partidos; i++){
			for (int j=0; j<=partidos; j++){
				System.out.print(Math.round(tabla[i][j]*1000d)/1000d+" ");
			} System.out.println();
		}
		
		System.out.println();
		System.out.println("Probabilidad de que A gane: "+tabla[partidos][partidos]);
		System.out.println();
		
	// With memo
		
		double[] vector = new double[partidos+1];
		vector[0] = 0;
		for (int i=1; i<=partidos; i++){ vector[i] = 1; }
		for (int i=1; i<=partidos; i++){
			for (int j=1; j<=partidos; j++){
				vector[j] = p*vector[j] + q*vector[j-1];
				System.out.println(Arrays.toString(vector));
			}
		}
		
		System.out.println("Con memoización: "+ vector[partidos]);
		
	}
}

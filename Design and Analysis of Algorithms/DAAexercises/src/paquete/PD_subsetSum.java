// https://www.geeksforgeeks.org/dynamic-programming-set-7-coin-change/
// Ejercicio PD_formasCarta, cambio monedas con una moneda por cada tipo
// http://www.disfrutalasmatematicas.com/conjuntos/conjunto-potencia-creador.html
// https://www.youtube.com/watch?v=_fgjrs570YE
// https://cs.stackexchange.com/questions/24050/negative-numbers-in-subset-sum
// https://www.skorks.com/2011/02/algorithms-a-dropbox-challenge-and-dynamic-programming/

package paquete;

public class PD_subsetSum {

	public static void main(String[] args) {
		
	// This program does not take account of negative numbers
	// PD_subsetSum2 handles this problem with negatives numbers
		
		int[] set = {2,3,5};
		int tam = set.length;
		int sum = 5;


		
		int[][] tabla = new int[tam+1][sum+1];
		
		for (int i=0; i<=tam; i++){tabla[i][0]=1;}
		for (int j=1; j<=sum; j++){tabla[0][j]=0;}
		
		for (int i=1; i<=tam; i++){
			for (int j=1; j<=sum; j++){
				if (set[i-1] > j){
					tabla[i][j] = tabla[i-1][j];
				} else {
					tabla[i][j] = tabla[i-1][j] + tabla[i-1][j-set[i-1]];
				}
			}
		}
		
		for (int i=0; i<=tam; i++){
			for (int j=0; j<=sum; j++){
				System.out.print(tabla[i][j]);
			} System.out.println();
		}

	}

}

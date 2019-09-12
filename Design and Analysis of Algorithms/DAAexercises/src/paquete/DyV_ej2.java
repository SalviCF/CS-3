package paquete;

import java.util.Arrays;

public class DyV_ej2 {

	public static void main(String[] args) {
		int[] x = {2,3,4,5,6};
		int[] y = {3,7,4,5,66};
		//System.out.println(mediana(a,b));
		
		

	}
	public static int mediana(int[] x, int[] y){
		int mediana=0;
		int tam = x.length;
		
		// Junto los arrays
		int[] xy = new int [x.length+y.length];
		System.arraycopy(x, 0, xy, 0, x.length);
		System.arraycopy(y, 0, xy, x.length, y.length);
		
		// Ordeno el array que acabo de juntar
		Arrays.sort(xy);
		
		if (x.length == 1){
			if (x[0]<y[0]){mediana = x[0];}
			else {mediana = y[0];}
		}
		
		else{
			int medx = (x.length-1)/2; // índice de la mediana
			int medy = (y.length-1)/2;
			
			if (x[medx] < y[medy]){
				if (tam%2==0){
					mediana = 2222;
				}
			}
		}
		
		return mediana;
	}
}

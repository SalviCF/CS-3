package paquete;

import java.util.Arrays;

public class VA_variaciones {
	
	public static int tam;
	public static int m;
	public static int[] sol;

	public static void main(String[] args) {
		
		char[] letras = {'a','b','c'};
		m = 2;
		tam = letras.length;
		sol = new int[m];
		int k = 0;
		va_palabras(k);

	}
	
	public static void va_palabras (int etapa){
		
		for (int i=0; i<tam; i++){
			sol[etapa] = i;
			if (factible(etapa)){
				if (etapa==m-1){
					System.out.println(Arrays.toString(sol));
				} else {
					va_palabras(etapa+1);
				}
			}
		}
	}
	
	public static boolean factible (int etapa){
		
		int i=0;
		while (sol[i]!=sol[etapa]){
			i++;
		}
		return i==etapa;
	}

}

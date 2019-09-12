package paquete;

import java.util.Arrays;

public class VA_tarifas {

	public static int tam = 4;
	public static int[][] tarifas = {
			{1,2,0,3},
			{7,2,9,2},
			{8,6,3,1},
			{6,8,5,4}
	};
	public static int[] sol = new int[tam];
	public static int[] sol_mejor;
	public static int tarifa = 0;
	public static int tarifa_mejor = Integer.MAX_VALUE;
	
	public static void main(String[] args) {
		int persona = 0;
		va_tarifas(persona);
		System.out.println(Arrays.toString(sol_mejor));
		System.out.println(tarifa_mejor);
	}
	
	public static void va_tarifas (int persona){
		for (int trabajo=0; trabajo<tam; trabajo++){
			sol[persona] = trabajo;
			tarifa += tarifas[persona][trabajo];
			if (factible(persona)){
				if (persona == tam-1){
					if (tarifa < tarifa_mejor){
						tarifa_mejor = tarifa;
						sol_mejor = sol.clone();
					}
				} else {
					va_tarifas(persona+1);
				}
			} tarifa -= tarifas[persona][trabajo];
		}
	}
	
	public static boolean factible (int etapa){
		int i=0;
		while (sol[i] != sol[etapa]){
			i++;
		} return (i == etapa);
	}

}

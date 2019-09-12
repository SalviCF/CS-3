package paquete;

import java.util.Arrays;

public class VA_caballo {

	public static int tam;
	public static int[][] tablero;
	public static boolean exito;
	public static int u,v; // coordinates
// Eight possible moves 
	public static int[] movX = {2,1,-1,-2,-2,-1,1,2};
	public static int[] movY = {1,2,2,1,-1,-2,-2,-1};
	
	public static void main(String[] args) {
		tam = 5;
		tablero = new int[tam][tam];
		u = v = 2;
		//u=4; v=0;
		tablero[u][v] = 1;
		int etapa = 1;
		exito = false;
		tourCaballo(etapa);
		for (int i=0; i<tam; i++){
			System.out.println(Arrays.toString(tablero[i]));
		}
	}
	
	public static void tourCaballo (int etapa){
		int movimiento = 0;
		
		while (!exito && movimiento<8){
			u = u + movX[movimiento];
			v = v + movY[movimiento];
			if ((u>=0)&&(u<tam)&&(v>=0)&&(v<tam)&&(tablero[u][v]==0)){
				tablero[u][v] = etapa+1;
				if (etapa == tam*tam-1){
					exito = true;
				} else {
					tourCaballo(etapa+1);
					if (!exito){ tablero[u][v] = 0; }
				}
			}
			u = u - movX[movimiento];
			v = v - movY[movimiento];
			movimiento++;
		}
	}

}

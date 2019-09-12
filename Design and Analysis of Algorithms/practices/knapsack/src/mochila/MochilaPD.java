package mochila;

/**
 * 
 * @author ***** Salvador CF *******
 *
 */
public class MochilaPD extends Mochila {

	public SolucionMochila resolver(ProblemaMochila pm) {
		SolucionMochila sm;
		
	// 1. Definition of the table
		int n = pm.size();
		int pesoMax = pm.getPesoMaximo();
		int[][]Vmochila = new int[n+1][pesoMax+1];
		
		int[]pesos = pm.getPesos();
		int[]valores = pm.getValores();

	// 2.Table construction
		for (int i=0; i<=n; i++){ Vmochila[i][0] = 0; } // if first column
		for (int p=1; p<=pesoMax; p++){ Vmochila[0][p] = 0; } // if first row
		
		for (int i=1; i<=n; i++){
			for (int p=1; p<=pesoMax; p++){
				if (pesos[i-1] > p){ // i starts in 1 but i need the weight of position 0
					Vmochila[i][p] = Vmochila[i-1][p]; 
				} else {
					Vmochila[i][p] = Math.max(valores[i-1] + Vmochila[i-1][p-pesos[i-1]], Vmochila[i-1][p]);
				}
			}
		}
		//int value = t[n][pesoMax];
		
	// 3. Find the objects
		int resto = pesoMax; // indicates the column
		int[]objetos = new int[n]; 
		for (int i=n; i>0; i--){ // starts in last row
			if (Vmochila[i][resto] == Vmochila[i-1][resto]){ 
				objetos[i-1] = 0; // -1 because solution array starts in 0
			} else {
				objetos[i-1] = 1;
				resto = resto - pm.getPeso(i-1); // for go back in columns
			}
		}
		sm = new SolucionMochila(objetos, pm.sumaPesos(objetos), pm.sumaValores(objetos));
		return sm;
	}
}


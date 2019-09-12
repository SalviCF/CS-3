package mochila;

// http://www.geeksforgeeks.org/knapsack-problem/
// libro Narciso Martí
// https://www.youtube.com/watch?v=fVrPwSkSo0I
// https://stackoverflow.com/questions/3907545/how-to-understand-the-knapsack-problem-is-np-complete
// https://web.archive.org/web/20100627162045/http://websrv.cs.umt.edu/classes/cs531/index.php/Complexity_of_dynamic_programming_algorithm_for_the_0-1_knapsack_problem_3/27
// Pseudopolinomial indica que alguno de los números de la multiplicación es muy alto, pero no es exponencial.

public class Ejemplo2 {

	public static void main(String[] args) {
		// 1. Problem definition ///////////////////////////////////////////////////////////////////
		
			int[] pesos = {2,1,3,2,4};
			int[] valores = {3,1,3,2,3};
			int pesoMax = 4;
			ProblemaMochila pm = new ProblemaMochila(pesos, valores, pesoMax);
		
		// 2. Definition of the table
			
			int n = pm.size();
			int[][]t = new int[n+1][pesoMax+1];
			
		// 3. Table construction
			for (int i=0; i<=n; i++){ t[i][0] = 0; }
			for (int p=1; p<=pesoMax; p++){ t[0][p] = 0; }
			
			for (int i=1; i<=n; i++){
				for (int p=1; p<=pesoMax; p++){
					if (pesos[i-1] > p){ // i starts in 1 but i need the weight of position 0
						System.out.println("Pesos"+pesos[i-1]);
						System.out.println(p);
						t[i][p] = t[i-1][p]; 
					} else {
						t[i][p] = Math.max(valores[i-1]+t[i-1][p-pesos[i-1]], t[i-1][p]);
					}
				}
			}
			int value = t[n][pesoMax];
			System.out.println(value);
			
		// Finding the objects
			int resto = pesoMax;
			int[]objetos = new int[n];
			for (int i=n; i>0; i--){
				if (t[i][resto] == t[i-1][resto]){
					objetos[i-1] = 0;
				} else {
					objetos[i-1] = 1;
					resto = resto - pm.getPeso(i-1);
				}
			}
			SolucionMochila sm = new SolucionMochila(objetos, pm.sumaPesos(objetos), 
														pm.sumaValores(objetos));
			System.out.println(sm);
	}

}

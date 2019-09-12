package mochila;

/**
 * 
 * @author ***** Salvador CF *******
 *
 **/

public class MochilaFB extends Mochila {

	public SolucionMochila resolver(ProblemaMochila pm) {
		
// 1. Definition form of the solution ///////////////////////////////////////////////////////
		
		int pesoMaximo = pm.getPesoMaximo();
		int tam = pm.size();
		int[] bits = new int[tam];
		SolucionMochila sm = new SolucionMochila(bits, 0, 0); // returned if no better comb
		bits[tam-1] = 1; // To skip check all zeros combination
		
		
// 2. Looking for the 2^n combinations /////////////////////////////////////////////////////
		
		double comb = Math.pow(2, tam); 
		int mayorBeneficio = 0; 		
		int mejorPeso = 0; 		
		
		for (int i=0; i<comb-1; i++){ // Enters (2^n - 1) times. All zeros comb is skipped
			
			int pesoComb = pm.sumaPesos(bits);
			int valorComb = pm.sumaValores(bits);
			
		// Better combination?
			if (pesoComb <= pesoMaximo && valorComb > mayorBeneficio){
				mayorBeneficio = valorComb;
				mejorPeso = pesoComb;
				sm = new SolucionMochila(bits, mejorPeso, mayorBeneficio);
			}
			
		// Next combination (Explanation at the end of code)
			if (i!=comb-2){
				int j = tam-1;
				while (bits[j] != 0){
					bits[j] = 0;
					j--;
				}
				bits[j] = 1;
			}
		}
		return sm;
	}
}

/*		
* "Next combination" flow diagram:
* 
* <Last iteration?> : YES -> (END)											 
*   	            : NO -> [Select right extreme bit] 
*   							|_-> <Bit = 1?> : NO -> [Set bit to 1] -> (END)
*  									    ^		: YES -> [Set bit to 0] -> [Select next left bit]
*  										|___________________________________________________|
*  
*  
*  If condition avoids enter when all bits are ones (in last iteration).
*  It avoids j = -1 (outOfBOunds). 
*  2nd condition "j>0" is another option but it is worse because enters a few times in the while,
*  doing more elemental operations.
* 																				
*/

		


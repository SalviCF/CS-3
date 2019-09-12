package paquete;

public class PD_parentizacion{

	public static void main(String[] args) {

		int tam = 5; // Number of matrices to multiply
		int[] D = {2,2,1,3,4,2}; // dimensions: rows of each matrix and the column of last matrix
		
		int[][] matrices = new int[tam][tam]; // table to fill
		
		// Decision table: to know how are the parenthesis
		// P[i][j] = k -> considering matrices i to j, there a parenthesis between k and k+1
		// P[i][j] = 0 -> there is no parenthesis because i=j
		int[][] P = new int[tam][tam]; 
		
	// Set to zero the elements of the principal diagonal
		for (int i=1; i<tam; i++){
			matrices[i][i] = 0;
			P[i][i] = 0;
		}
		
	// Filling the matrix
		
		// Traverse the diagonals. d=0 is the principal diagonal. It starts in d=1
		// There is tam-1 diagonals to fill
		for (int d=1; d<=tam-1; d++){ 
			// Traverse elements in each diagonal
			// There is tam-d elements in diagonal d
			for (int i=0; i<tam-d; i++){ 
				int j = i + d; // row + diagonal = column
				matrices[i][j] = Integer.MAX_VALUE; // initial value 
				for (int k=i; k<j; k++){ // to compute the minimum for each k with i<=k<j
					int temp = matrices[i][k] + matrices[k+1][j] + D[i]*D[k+1]*D[j+1];
					if (temp < matrices[i][j]){
						matrices[i][j] = temp;
						P[i][j] = k;
					} 
				} for (int y=0; y<tam; y++){
					for (int z=0; z<tam; z++){
						System.out.print(matrices[y][z]+" ");
					} System.out.println();
				} System.out.println();
			} 
		} 
		
		System.out.println("Soluci�n: "+matrices[0][tam-1]);
		System.out.println();
		System.out.println("Decisiones:");
		for (int y=0; y<tam; y++){
			for (int z=0; z<tam; z++){
				System.out.print(P[y][z]+" ");
			} System.out.println();
		} System.out.println();
		
	// Printing the parenthesis
		System.out.print("Parentizaci�n: ");
		escribirParentesis(0,4,P);
	}
	
	public static void escribirParentesis (int i, int j, int[][] decisiones){
		
		if (i==j){
			System.out.print(" M"+i+" ");
		} else {
			int k = decisiones[i][j];
			if (k > i){
				System.out.print("("); 
				escribirParentesis(i,k,decisiones);
				System.out.print(")");
			} else {
				System.out.print(" M"+i+" ");
			}
			if (k+1 < j){
				System.out.print("(");
				escribirParentesis(k+1,j,decisiones);
				System.out.print(")");
			} else {
				System.out.print(" M"+j+" ");
			}
		}
	}
}

package paquete;

public class PD_ej3_relacion4 {

	public static void main(String[] args) {
		
		int rows = 3;
		int columns = 3;
		int[][] estimacion = new int[rows+1][columns+1];
		int[] c = {0,0,0,0,0,1,10,5,0,2,8,7,10,8,6,9}; // values for the estimation matrix
		
	// Filling the matrix of estimations
		int cont = 0;
		for (int i=0; i<estimacion.length; i++){
			for (int j=0; j<estimacion.length; j++){
				estimacion[i][j] = c[cont];
				cont++;
			}
		}
	
	// Prints the estimation matrix
		System.out.println("Matriz de estimaciones");
		for (int i=0; i<rows+1; i++){
			for (int j=0; j<columns+1; j++){
				System.out.print(estimacion[i][j]+" ");
			} System.out.println();
		} System.out.println();

	// Creating the table of maximum grades
		int[][] nota = new int[rows+1][columns+1];
		int[][] mejorK = new int[rows][columns]; // the best k in each position. Decision matrix
		
		// Base cases
		for (int j=0; j<columns+1; j++){nota[0][j] = 0;}
		for (int i=1; i<rows+1; i++){nota[i][0] += estimacion[i][0];}
		
		// Recursive case
		for (int i=1; i<rows+1; i++){
			for (int j=1; j<columns+1; j++){
				int max = 0;
				for (int k=0; k<=j; k++){
					if (estimacion[i][k] + nota[i-1][j-k] > max){
						max = estimacion[i][k] + nota[i-1][j-k];
						mejorK[i-1][j-1] = k; // filling decision matrix
					} 
				} 
				nota[i][j] = max;
			}
		}
		
	// Prints the maximum grade matrix
		System.out.println("Matriz de máxima puntuación");
		for (int i=0; i<rows+1; i++){
			for (int j=0; j<columns+1; j++){
				System.out.print(nota[i][j]+" ");
			} System.out.println();
		} System.out.println();
		
		System.out.println("La máxima calificación es: "+nota[rows][columns]);
		System.out.println();

	// Calculates the hours for each subject
		int i,j,k;
		i = rows;
		j = columns;
		k = mejorK[i-1][j-1];
		int[] horas = new int[rows];
		
		for (int x=horas.length-1; x>=0; x--){
			if (nota[i][j] != nota[i-1][j-k]){
				horas[x] = j-(j-k);
			} else {
				horas[x] = 0;
			}
			if (x>0){
				i=i-1;
				j=j-k;
				k=mejorK[i-1][j-1];
			}
		}
		
		System.out.println("Las horas dedicadas a cada asignatura fueron: ");
		for (int y=0; y<horas.length; y++){
			System.out.println("Asignatura "+(y+1)+": "+horas[y]+" horas");
		}
	}
}

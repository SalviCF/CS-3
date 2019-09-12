package paquete;

public class MatDiagonal {

	public static void main(String[] args) {
	// Rellena una matriz por diagonales de izquierda a derecha y de abajo a arriba
		int n = 3; // columnas
		int m = 3; // filas
		int cantDiagonales = n + m - 1; // propiedad de las matrices

		int a[][] = new int[m][n]; // Crea matriz de m x n

		for (int diagonal = 0, num = 0; diagonal < cantDiagonales; diagonal++) {
		// recorre todas las diagonales e inicializo el número
		// "y" empieza siendo Math.min(...) y se va decrementando
		// "x" se recalcula en cada iteración a partir de "y"
		    for (int x, y = Math.min(diagonal,m - 1); y >= 0 && (x = diagonal - y) < n; y--) {
		        a[y][x] = num++; // primero pongo el número y luego lo incremento
		    }

		}
		
	// Imprimo el resultado
		
		for (int i=0; i<m; i++){
			for (int j=0; j<n; j++){
				System.out.print(a[i][j]+" ");
			} System.out.println();
		}
		
	}

}

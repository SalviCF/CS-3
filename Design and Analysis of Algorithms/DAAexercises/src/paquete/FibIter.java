package paquete;

public class FibIter {

	public static void main(String[] args) {
		System.out.println(binomio(3,2));
	}

	public static int fib (int n){
		int fib_1, fib_2, suma;
		fib_1 = 1; fib_2 = 1; suma = 0;
		
		if (n == 1 || n == 2){ return 1;}
		else {
			for (int i=2; i<n; i++){
				suma = fib_1 + fib_2;
				fib_2 = fib_1;
				fib_1 = suma;
			}
		}
		
		return suma;
	}
	
	public static int binomio(int n, int k){
	if (n<0|| k<0 || n<k) throw new IllegalArgumentException("Entrada inválida");
	int [][] tabla = new int [n+1][];
	for(int i = 0;i<=n;i++){
		tabla[i] = new int [i+1];
		for(int j = 0; j<=i; j++){
			if(j == 0 || j == i)
				tabla[i][j]=1;
			else
				tabla[i][j] = tabla[i-1][j-1] + tabla[i-1][j];
		}
	}
	return tabla[n][k];
	}
}

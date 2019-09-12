package paquete;

public class Algoritmo2 {
//http://www.geeksforgeeks.org/write-a-c-program-that-given-a-set-a-of-n-numbers-and-another-number-x-determines-whether-or-not-there-exist-two-elements-in-s-whose-sum-is-exactly-x/
	public static void main(String[] args) {
		int x=111; 
		int [] a = {0,1,2,3,6,7};
		System.out.println(sumPair(a,x));

	}
	public static int sumPair (int [] a, int x){
		int min = 0;
		int max = a.length-1; int cont = 0;
		
		while (min<max){
			cont++;
			if (a[min]+a[max]==x) return 2; 
			else if (a[min]+a[max] < x) min++;
			else max--;
		} return cont;
	}

}

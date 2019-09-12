package paquete;

import java.util.Arrays;

public class VA_subsetSum {

	public static int tam = 5;
	public static int sum = 15; // exact sum to reach
	public static int[] set = {2,3,5,10,20};
	public static int[] sol; // 0 if element don't belongs to solution, 1 if it does
	
	public static void main(String[] args) {
		
		sol = new int[tam];
		int etapa = 0;
		int s = 0; // sum of elements considered so far
		int r = calcR(); // sum of the rest of elements not considered yet
		subset(s,etapa,r);
	}

	public static void subset(int s,int etapa,int r){
		if (etapa != tam-1){ // avoids out of bounds when call with "etapa+1"
			sol[etapa] = 1; // consider the element in the subset
			if (s + set[etapa] == sum){
				System.out.println(Arrays.toString(sol));
			} else if (s+set[etapa]+set[etapa+1] <= sum){
				subset(s+set[etapa],etapa+1,r-set[etapa]);
			}
			// al no considerar ese elemento debo poder seguir sumando hasta sum con el resto
			// más lo que llevaba. También chequeo que siga sin pasarme.
			if ((s+r-set[etapa]>=sum) && (s+set[etapa]<=sum)){
				sol[etapa] = 0; // don't consider the element in the subset
				subset(s,etapa+1,r-set[etapa]);
			}
		}
	}
	
	public static int calcR (){
		int res = 0;
		for (int i=0; i<tam; i++){
			res += set[i]; // sum of the rest of elements
		} return res;
	}
}

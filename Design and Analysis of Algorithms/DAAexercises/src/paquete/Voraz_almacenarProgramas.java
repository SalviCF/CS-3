package paquete;

import java.util.*;

public class Voraz_almacenarProgramas {

	public static void main(String[] args) {
		//ArrayList<Integer> espacios = new ArrayList<Integer>(Arrays.asList(espacio));
		
		int n = 5; // number of programs
		int disco = 80; // size of the disc
		Integer[] espacio = {20,40,12,33,18};
		List<Integer> espacios = Arrays.asList(espacio);
		
		Collections.sort(espacios); // Sorting in increasing order
		
		int[] sol = new int[n];
		int espacioLibre = disco;
		for (int i=0; i<n && espacioLibre>=espacios.get(i); i++){
				sol[i] = 1;
				espacioLibre -= espacios.get(i);
		}
		
		System.out.println(Arrays.toString(sol));
		

	}
}

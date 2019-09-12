package paquete;

import java.util.*;

public class Voraz_almacenarProgramas2 {

	public static void main(String[] args) {
		
		int n = 5; // number of programs
		int disco = 80; // size of the disc
		Integer[] espacio = {20,40,12,33,18};
		ArrayList<Programa> programas = new ArrayList<Programa>(espacio.length);
		
	// Creating the programs
		for (int i=0; i<n; i++){
			Programa p = new Programa(espacio[i], i); // 1st parameter: space
			programas.add(p);
		}
		
	// Sorting the programs by size in increasing order
		Collections.sort(programas, new Comparator<Programa>(){
			@Override public int compare(Programa p1, Programa p2){
				if(p1.tam>p2.tam){return 1;}
				if(p1.tam<p2.tam){return -1;}
				return 0;
			}
		});
		
		int[] sol = new int[n];
		int espacioLibre = disco;
		
		for (int i=0; i<n && espacioLibre>=programas.get(i).tam; i++){
			sol[programas.get(i).index] = 1;
			espacioLibre -= programas.get(i).tam;
		}
		
		System.out.println(Arrays.toString(sol));
	}
}


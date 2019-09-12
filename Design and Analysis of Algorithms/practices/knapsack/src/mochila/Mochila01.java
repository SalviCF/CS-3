package mochila;  // quitar paquete para compilar con javac
import java.util.*;

/**
*	@author ***** Salvador CF *******
*/

public class Mochila01 {
	
	public static class Item{ // needs to be static
		int index;
		int peso;
		int valor;
		public Item(int index, int peso, int valor) {
			this.index = index;
			this.peso = peso;
			this.valor = valor;
		}
	}

	public static void main(String[] args) {
		
		int[] pesos =   {1,4,4,1,4};
		int[] valores = {1,4,2,1,3};
		int capacidad = 4;
		int tam = pesos.length;
		
	// 1. Get the items
		ArrayList<Item> items = new ArrayList<Item>(tam);
		for (int i=0; i<tam; i++){
			Item x = new Item(i, pesos[i], valores[i]); 
			items.add(x);
		}
		
	// 2. Sort the items comparing their ratios (value / weight)
		Collections.sort(items, new Comparator<Item>() {
	        @Override public int compare(Item i1, Item i2) {
	        	double ratio1 = (double) i1.valor / i1.peso;
	    		double ratio2 = (double) i2.valor / i2.peso;
	    		if (ratio1 > ratio2){return -1;}
	    		if (ratio1 < ratio2){return 1;}
	    		return 0;
	        }
	    });
		
		System.out.println("Ejemplo:");
		System.out.println("Pesos: "+Arrays.toString(pesos));
		System.out.println("Valores: "+Arrays.toString(valores));
		System.out.println("Capacidad máxima de la mochila: "+capacidad);
		System.out.println();
		System.out.println("Elementos en orden:");
		
		for (int i=0; i<tam; i++){
			System.out.println("Orden: "+i+
					             " Peso:"+items.get(i).peso + 
								 " Valor:"+items.get(i).valor+ 
								 " Índice:" + items.get(i).index+
								 " Ratio: "+ (double) items.get(i).valor/items.get(i).peso);
		}
		
		int[] sol = new int[tam];
		int pesoLibre = capacidad;
		for (int i=0; i<tam; i++){
			if (items.get(i).peso <= pesoLibre){
				sol[items.get(i).index] = 1;
				pesoLibre -= items.get(i).peso;
			}
		}
		
		System.out.println();
		System.out.println("Solución: "+Arrays.toString(sol));
	}
}


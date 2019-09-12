package mochila;
import java.util.*;

/* https://docs.oracle.com/javase/7/docs/api/java/util/ArrayList.html
 * https://stackoverflow.com/questions/8304767/how-to-get-maximum-value-from-the-list-arraylist
 * https://stackoverflow.com/questions/14741248/how-to-divide-down-to-decimals-and-not-get-zero-in-java
 * 
 * Al probar con TreeMap me di cuenta de que si tomaba como clave el ratio, cuando hubiera
 * ratios repetidos, estos no se incluirían en el mapa, ya que no puede haber claves iguales.
 * 
 * Si tomaba como clave el índice, tras ordenar los valores (ratios) no hay manera de asociar
 * cada valor con su clave ya que si tengo dos valores iguales, ¿cuál es su clave?
 * 
 * Hice en la clase Item: implements Comparable<Item> y definí el método compareTo:
 * https://geekytheory.com/tip-java-como-ordenar-un-array-de-objetos-por-sus-atributos
 * https://stackoverflow.com/questions/14475556/how-to-sort-arraylist-of-objects
 */

public class Ejemplo3 {

	public static void main(String[] args) {
		
		int[] pesos =   {1,4,4,1,4};
		int[] valores = {1,4,2,1,3};
		ProblemaMochila pm = new ProblemaMochila(pesos, valores, 4);
		
		int tam = pm.size();
		
	// 1. Get the objects of type Item
		ArrayList<Item> items = pm.getItems();
		
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
		
		for (int i=0; i<tam; i++){
			System.out.println("Orden: "+i+
					             " Peso:"+items.get(i).peso + 
								 " Valor:"+items.get(i).valor+ 
								 " Indice:" + items.get(i).index+
								 " Ratio: "+ (double) items.get(i).valor/items.get(i).peso);
		}
		
		int[] sol = new int[tam];
		int pesoLibre = pm.getPesoMaximo();
		for (int i=0; i<tam; i++){
			if (items.get(i).peso <= pesoLibre){
				sol[items.get(i).index] = 1;
				pesoLibre -= items.get(i).peso;
			}
		}
		
		System.out.println(Arrays.toString(sol));
	}


}

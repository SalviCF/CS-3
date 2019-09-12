package org.ada.va.impl;

/**
 * Implementación del algoritmo de las n-reinas con la técnica de vuelta atrás.
 * Tiene dos métodos de entrada a la funcionalidad proporcionados por la clase que implementa:
 * - init: devuelve la primera solución para el problema
 * - initTodas: devuelve todas las soluciones para el problema
 * El modificador verbose nos permite controlar el nivel de salida de la clase
 * 
 * @author Salvador CF
 */
public class NReinasVueltaAtras extends NReinasAbstract {
	
	/**
	 * Constructor de la clase.
	 * @param dimension tamaño del tablero y número de reinas a colocar
	 */
	public NReinasVueltaAtras(Integer dimension) {
		super(dimension);
	}

	/**
	 * Calcula la solución para una etapa concreta.
	 * @param etapa etapa para la que queremos calcular la solución.
	 */
	public void vueltaAtras(int etapa) {
		// TODO: implementar el algoritmo que encuentra la primera solución para una etapa concreta
		for (int col=0; col<getDimension() && isExito()==false; col++){
			solucion[etapa] = col;
			if (valido(etapa)){
				if (etapa == getDimension()-1){
					setExito(true);//controls the entry to the loop
				} else {
					vueltaAtras(etapa+1);
				}
			}
		}
	}
	
	/**
	 * Indica si la posible solución es válida para una etapa concreta
	 * @param  etapa etapa para la que queremos validar la solución
	 * @return si la solución es correcta
	 */
	protected Boolean valido(int etapa) { 
		// TODO: implementar el algoritmo para validar si una posible solución es válida para una etapa concreta
		for (int i=0; i<etapa; i++){
			if ((solucion[i] == solucion[etapa]) || 
					(Math.abs(solucion[i]-solucion[etapa]) == Math.abs(i-etapa))){
				return Boolean.FALSE;
			}
		}
		return Boolean.TRUE;
	}

	/**
	 * Método que calcula todas las soluciones posibles para una etapa.
	 * 
	 * @param etapa etapa
	 */
	public void vaTodas(int etapa) {
		// TODO: implementar el algoritmo que calcula todas las posibles soluciones para una etapa concreta
		for (int col=0; col<getDimension(); col++){
			solucion[etapa] = col;
			if (valido(etapa)){
				if (etapa == getDimension()-1){
//If we add solucion instead of solucion.clone(), 
//when solucion is modified, also is modified in todas
//So, it is necessary to duplicate the object, not the reference
					todas.addElement(solucion.clone());
				} else {
					vaTodas(etapa+1);
				}
			}
		}
	}
}

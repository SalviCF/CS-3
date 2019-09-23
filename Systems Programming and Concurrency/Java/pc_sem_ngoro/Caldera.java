package pc_sem_ngoro;

/**
 * @author Salvi CF
 */

import java.util.concurrent.Semaphore;

public class Caldera {

	private final int capacidad;
	
	private int exploradores = 0; //permisos que dar antes de suspender la hebra
	private Semaphore explorador = new Semaphore(0, true); //para el sem general, se bloquea si no hay explorador
	private Semaphore mutex = new Semaphore(1, true); //para exclusión mutua de la variable exploradores
	private Semaphore cocina = new Semaphore(1, true); //no cocina 
	
	public Caldera(int capacidad){
		this.capacidad = capacidad;
	}
	
	public void dormirCocinar() throws InterruptedException{
		cocina.acquire(); //veo si puedo cocinar, si no, me paro (duermo en choza)
		//se bloquea hasta que adquiere el permiso
		// Mientras cocina, nadie puede comer, voy a modificar el número de exploradores
		mutex.acquire();
		System.out.println("El cocinero está preparando la comida...");
		Thread.sleep(1000); // lo que tarda en preparar la comida
		exploradores = capacidad; //modifico la variable compartida
		System.out.println("Caldera llena con " + exploradores + " exploradores..." 
				+ "El cocinero se va a su choza a dormir.");
		mutex.release(); 
		explorador.release(); //ya hay comida, puede comer un caníbal
	}
	
	public void comer(int canibal) throws InterruptedException{
		explorador.acquire(); //si no hay exploradores para comer, me bloqueo
		mutex.acquire(); //voy a modificar exploradores
		exploradores--; //modifico al variable compartida
		System.out.println("Caníbal " + canibal + " se come a un explorador..."
				+ "Exploradores que quedan: " + exploradores);
		if (exploradores == 0){//caldera vacía
			cocina.release(); //despertamos al cocinero
			System.out.println("No quedan exploradores...Despertamos al cocinero.");
		}
		else{
			explorador.release(); //siguen quedando exploradores para comer
		}
		mutex.release();
	}
}

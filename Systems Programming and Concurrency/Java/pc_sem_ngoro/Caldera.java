package pc_sem_ngoro;

/**
 * @author Salvi CF
 */

import java.util.concurrent.Semaphore;

public class Caldera {

	private final int capacidad;
	
	private int exploradores = 0; 
	private Semaphore explorador = new Semaphore(0, true); 
	private Semaphore mutex = new Semaphore(1, true); 
	private Semaphore cocina = new Semaphore(1, true); 
	
	public Caldera(int capacidad){
		this.capacidad = capacidad;
	}
	
	public void dormirCocinar() throws InterruptedException{
		cocina.acquire(); //veo si puedo cocinar, si no, me paro (duermo en choza)
		mutex.acquire();
		System.out.println("El cocinero está preparando la comida...");
		Thread.sleep(1000); 
		exploradores = capacidad; 
		System.out.println("Caldera llena con " + exploradores + " exploradores..." 
				+ "El cocinero se va a su choza a dormir.");
		mutex.release(); 
		explorador.release(); 
	}
	
	public void comer(int canibal) throws InterruptedException{
		explorador.acquire(); 
		mutex.acquire(); 
		exploradores--; 
		System.out.println("Caníbal " + canibal + " se come a un explorador..."
				+ "Exploradores que quedan: " + exploradores);
		if (exploradores == 0){
			cocina.release(); 
			System.out.println("No quedan exploradores...Despertamos al cocinero.");
		}
		else{
			explorador.release();
		}
		mutex.release();
	}
}

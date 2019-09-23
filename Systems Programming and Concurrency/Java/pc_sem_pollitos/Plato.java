package pc_sem_pollitos;

/**
 * @author Salvi CF
 */

import java.util.concurrent.Semaphore;

public class Plato {

	private final int capacidad;
	
	private int bichitos = 0; 
	
	private Semaphore hayBicho = new Semaphore(0, true); 
	private Semaphore mutex = new Semaphore(1, true); 
	private Semaphore hayEspacioEnPlato = new Semaphore(1, true); 
	
	public Plato(int capacidad){
		this.capacidad = capacidad;
	}
	
	public void poneBichito(int pajaro) throws InterruptedException{
	
		hayEspacioEnPlato.acquire(); 
		mutex.acquire(); 
		System.out.println("El pájaro " + pajaro + " pone un bichito en el plato.");
		bichitos++;
		System.out.println("Hay " + bichitos + " bichitos en el plato.");
		if(bichitos == 1){ 
			hayBicho.release();
		}
		if(bichitos < capacidad){ 
			hayEspacioEnPlato.release();
		}
		mutex.release();
	}
	
	public void comerBichito(int pollito) throws InterruptedException{

		hayBicho.acquire(); 
		mutex.acquire(); 
		System.out.println("El pollito " + pollito + " se ha comido un bichito.");
		bichitos--;
		if(bichitos == capacidad-1){ 
			hayEspacioEnPlato.release();
		}
		if(bichitos > 0){ 
			hayBicho.release();
		}
		System.out.println("Quedan " + bichitos + " bichitos.");
		mutex.release();
	}
}
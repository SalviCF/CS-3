package pc_sem_banco;

/**
 * @author Salvi CF
 */

import java.util.concurrent.Semaphore;

public class Cuenta {

	private int balance; 
	
	private int necesito; 
	private boolean rojo = false; 
	
	private Semaphore sacar = new Semaphore(1, true); 
	private Semaphore mutex = new Semaphore(1, true);
	private Semaphore meter = new Semaphore(1, true);
	private Semaphore esperandoLiquidez = new Semaphore(0,true);
	
	
	public void extraer(int cliente, int cantidad) throws InterruptedException{
		sacar.acquire();
		mutex.acquire();
		if(cantidad > balance){ 
			rojo = true;
			necesito = cantidad; 
			System.out.println("El cliente " + cliente + " espera para sacar " + cantidad
					+ " euros.\t\t\tBalance: " + balance);
			mutex.release(); 
			
			esperandoLiquidez.acquire(); 
			mutex.acquire(); 
		}
		balance -= cantidad;
		System.out.println("El cliente " + cliente + " ha sacado " + cantidad + " euros." 
				+ "\t\t\tBalance: " + balance);
		mutex.release();
		sacar.release();
	}
	
	public void depositar(int cliente, int cantidad) throws InterruptedException{
		meter.acquire();
		mutex.acquire();
		balance += cantidad;
		System.out.println("El cliente " + cliente + " ha depositado " + cantidad + " euros."
				+ "\t\t\tBalance: " + balance);
		if(rojo && balance>necesito){
			System.out.println("Ya hay suficiente para sacar " + necesito + " euros.");
			esperandoLiquidez.release();
			rojo = false;
		}
		mutex.release();
		meter.release();
	}
}

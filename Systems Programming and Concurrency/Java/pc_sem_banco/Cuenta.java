package pc_sem_banco;

/**
 * @author Salvi CF
 */

import java.util.concurrent.Semaphore;

public class Cuenta {

	private int balance; //nunca puede ser negativo. Permito extraer si hay suficiente
	
	private int necesito; //dinero que necesito sacar, pero no puedo porque no hay suficiente en la cuenta
	private boolean rojo = false; //flag que indica si quiero sacar más de lo que hay
	
	private Semaphore sacar = new Semaphore(1, true); 
	private Semaphore mutex = new Semaphore(1, true);
	private Semaphore meter = new Semaphore(1, true);
	private Semaphore esperandoLiquidez = new Semaphore(0,true);
	
	
	public void extraer(int cliente, int cantidad) throws InterruptedException{
		sacar.acquire();
		mutex.acquire();
		if(cantidad > balance){ //si quiero sacar más de lo que hay
			rojo = true;
			necesito = cantidad; //espero hasta que haya esta cantidad
			System.out.println("El cliente " + cliente + " espera para sacar " + cantidad
					+ " euros.\t\t\tBalance: " + balance);
			mutex.release(); //se hace un release del mutex, pero no de sacar
			//si hago sacar.release(), puede que me quede esperando para siempre
			esperandoLiquidez.acquire(); //ahora, la hebra espera en este semáforo hasta que haya suficiente balance
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

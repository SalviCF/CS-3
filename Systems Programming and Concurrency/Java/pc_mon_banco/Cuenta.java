package pc_mon_banco;

/**
 * @author Salvi CF
 */

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Cuenta {

	private int balance; 
	private Lock l = new ReentrantLock(true);
	private Condition suficienteDinero = l.newCondition();
	
	
	public void depositar(int cliente, int cantidad) throws InterruptedException{

		try{
			l.lock();
			balance += cantidad;
			System.out.println("El cliente " + cliente + " deposita " + cantidad + " euros."
					+ " Balance: " + balance + " euros.");
			suficienteDinero.signal(); //despierto a alguna hebra esperando en la condición
			
		        //si al despertarla, la cantidad sigue siendo mayor, vuelve a esperar, 

			
		}finally{
			l.unlock();
		}
	}
	
	public void extraer(int cliente, int cantidad) throws InterruptedException{

		try{
			l.lock();
			while(cantidad > balance){
				System.out.println("El cliente " + cliente + " espera para sacar "
						+ cantidad + " euros. Balance: " + balance);
				suficienteDinero.await();
			}
			balance -= cantidad;
			System.out.println("El cliente " + cliente + " ha sacado " + cantidad + " euros."
					+ " Balance: " + balance);
		}finally{
			l.unlock();
		}
	}
}

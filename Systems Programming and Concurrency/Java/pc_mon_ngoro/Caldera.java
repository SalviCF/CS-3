package pc_mon_ngoro;

/**
 * @author Salvi CF
 */

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Caldera {

	private final int capacidad;
	private int exploradores = 0; 
	
	private Lock l = new ReentrantLock(true);
	private Condition cocinero = l.newCondition();
	private Condition canibales = l.newCondition();
	
	public Caldera(int capacidad){
		this.capacidad = capacidad;
	}
	
	public void dormirCocinar() throws InterruptedException{
		try {
			l.lock();
			while (exploradores != 0) {
				System.out.println("Cocinero duerme en la choza.");
				cocinero.await(); 
			}
			System.out.println("Cocinero empieza a cocinar");
			Thread.sleep(1000);
			exploradores = capacidad;
			System.out.println("Cocinero llena la caldera con " + exploradores + " exploradores");
			canibales.signal(); 
		} finally {
			l.unlock();
		}
}
	
	public void comer(int canibal) throws InterruptedException{
		try {
			l.lock();
			while (exploradores == 0) { 
				System.out.println("El caníbal " + canibal + " espera comida");
				canibales.await(); 
			}
			exploradores--;
			System.out.println("El caníbal " + canibal + " se come a un explorador. Exploradores que quedan: " + exploradores);
			if (exploradores == 0)
				cocinero.signal(); 
			else
				canibales.signal(); 
		} finally {
			l.unlock();
		}
	}
}

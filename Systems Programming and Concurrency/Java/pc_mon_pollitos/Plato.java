package pc_mon_pollitos;

/**
 * @author Salvi CF
 */

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Plato {

	private final int capacidad;
	private int bichitos = 0; 
	
	private Lock l = new ReentrantLock(true);
	private Condition pajaros = l.newCondition(); 
	private Condition pollitos = l.newCondition(); 
	
	public Plato(int capacidad){
		this.capacidad = capacidad;
	}
	
	public void poneBichito(int pajaro) throws InterruptedException{
		l.lock();
		try{
			while(bichitos == capacidad){ 
				pajaros.await();
			}
			bichitos++;
			System.out.println("El pájaro " + pajaro + " pone un bichito en el plato\n"
					+ "Hay " + bichitos + " bichitos en el plato.");
			pollitos.signal();
		}finally{
			l.unlock();
		}
	}
	
	public void comerBichito(int pollito) throws InterruptedException{
		l.lock();
		try{
			while(bichitos == 0){ 
				pollitos.await();
			}
			bichitos--;
			System.out.println("El pollito " + pollito + " se ha comido un bichito.\n"
					+ "Quedan " + bichitos + " bichitos en el plato.");
			if(bichitos < capacidad){
				pajaros.signal();
			}
		}finally{
			l.unlock();
		}
	}
}

package pc_mon_pollitos;

/**
 * @author Salvi CF
 */

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class Plato {

	private final int capacidad;
	private int bichitos = 0; //bichitos que hya en el plato
	
	private Lock l = new ReentrantLock(true);
	private Condition pajaros = l.newCondition(); //espacio en el plato para poner bichitos
	private Condition pollitos = l.newCondition(); //bichitos en el plato
	
	public Plato(int capacidad){
		this.capacidad = capacidad;
	}
	
	public void poneBichito(int pajaro) throws InterruptedException{
		l.lock();
		try{
			while(bichitos == capacidad){ //plato lleno
				pajaros.await();
			}
			bichitos++;
			System.out.println("El p�jaro " + pajaro + " pone un bichito en el plato\n"
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

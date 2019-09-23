package pc_mon_procesos;

/**
 * @author Salvi CF
 */

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

public class UnidadControl {
	private int totalRecursos;
	private int recursosEnEspera;
	
	private boolean esperarEnCola = false;
	
	private Lock l = new ReentrantLock(true);
	private Condition hayRecursos = l.newCondition();
	private Condition cola = l.newCondition();

	public UnidadControl(int recursos){
		totalRecursos = recursos;
	}
	
	public void qrecursos(int proceso, int recursos) throws InterruptedException{
		try{
			l.lock();
			
			System.out.println("El proceso [p" + proceso + "] llega a la cola ... "
					+ "Demanda <" + recursos + "> recursos ... " + "Hay <" + totalRecursos 
					+ "> recursos disponibles.\n");
			//el primero que llega no espera
			while(esperarEnCola){ //todos esperan en la cola
				cola.await();
			}
			esperarEnCola = true; 
			
			recursosEnEspera = recursos; //los recursos que pide el thread actual
			while(totalRecursos <= recursosEnEspera){ 
				hayRecursos.await(); 
			}
			
			//avanzo si hay recursos
			totalRecursos -= recursos;
			System.out.println("La unidad de control asigna <" + recursos 
						+ "> recursos al proceso [p" + proceso + "] ... Hay <" + totalRecursos 
						+ "> recursos disponibles ... "
						+ "[p" + proceso + "] sale de la cola.\n");
			
			//tras obtener los recursos, llamo al siguiente de la cola
			cola.signal();
			esperarEnCola = false; 
			
		}finally{
			l.unlock();
		}
	}
	
	public void librecursos(int proceso, int recursos) throws InterruptedException{
		try{
			l.lock();
			totalRecursos += recursos;
			System.out.println("La unidad de control libera <" + recursos 
					+ "> recursos del proceso [p" + proceso + "] ... Hay <" + totalRecursos 
					+ "> recursos disponibles.\n");
			if(totalRecursos >= recursosEnEspera){ //despierto al que espera por recursos
				hayRecursos.signal();
			}
		}finally{
			l.unlock();
		}
	}
}

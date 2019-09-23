package pc_sem_procesos;

/**
 * @author Salvi CF
 */

import java.util.concurrent.Semaphore;

public class UnidadControl {
	private int totalRecursos;
	private int recursosEnEspera;	
	private boolean esperarEnCola;
	
	private Semaphore demandaRecursos = new Semaphore(1, true);
	private Semaphore mutex = new Semaphore(1, true);
	private Semaphore hayRecursos = new Semaphore(0, true);

	public UnidadControl(int recursos){
		totalRecursos = recursos;
	}
	
	public void qrecursos(int proceso, int recursos) throws InterruptedException{
		System.out.println("El proceso [p" + proceso + "] llega a la cola ... "
				+ "Demanda <" + recursos + "> recursos ... " + "Hay <" + totalRecursos 
				+ "> recursos disponibles.\n");
		demandaRecursos.acquire();
		mutex.acquire();
		if (totalRecursos < recursos) {
			recursosEnEspera = recursos;
			esperarEnCola = true;
			mutex.release();
			hayRecursos.acquire();
			mutex.acquire();
			esperarEnCola = false;
		}
		totalRecursos -= recursos;
		System.out.println("La unidad de control asigna <" + recursos 
				+ "> recursos al proceso [p" + proceso + "] ... Hay <" + totalRecursos 
				+ "> recursos disponibles ... "
				+ "[p" + proceso + "] sale de la cola.\n");
		mutex.release();
		demandaRecursos.release();
	}
	
	public void librecursos(int proceso, int recursos) throws InterruptedException{
		mutex.acquire();
		totalRecursos += recursos;
		System.out.println("La unidad de control libera <" + recursos 
				+ "> recursos del proceso [p" + proceso + "] ... Hay <" + totalRecursos 
				+ "> recursos disponibles.\n");
		if (esperarEnCola && recursosEnEspera <= totalRecursos)
			hayRecursos.release();
		mutex.release();
	}
}

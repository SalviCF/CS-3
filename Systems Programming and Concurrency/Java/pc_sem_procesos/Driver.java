package pc_sem_procesos;

/**
 * Producer-consumer. Semaphores
 * @author Salvi CF
 */

public class Driver {

	public static void main(String[] args) {

		UnidadControl control = new UnidadControl(20); //20 recursos
		for(int i=0; i<30; i++){ //30 procesos
			new Proceso(control, i).start();
		}
	}
}

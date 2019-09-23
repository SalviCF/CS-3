package pc_mon_procesos;

/**
 * Producer-consumer. Monitors.
 * @author Salvi CF
 */

public class Driver {

	public static void main(String[] args) {

		UnidadControl control = new UnidadControl(20); 
		for(int i=0; i<30; i++){ 
			new Proceso(control, i).start();
		}
	}
}

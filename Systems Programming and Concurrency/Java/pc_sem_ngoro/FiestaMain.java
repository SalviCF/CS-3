package pc_sem_ngoro;

/**
 * Producer-consumer. Semaphores
 * @author Salvi CF
 */

public class FiestaMain {

	private static final int CAPACIDAD_CALDERA = 8;
	private static final int CANIBALES = 50;
	
	public static void main(String[] args) {

		Caldera caldera = new Caldera(CAPACIDAD_CALDERA);
		Cocinero cocinero = new Cocinero(caldera);
		cocinero.start();
		
		for(int i=0; i<CANIBALES; i++){
			new Canibal(i, caldera).start();
		}

	}

}

package pc_sem_pollitos;

/**
 * Producer-consumer. Semaphores
 * @author Salvi CF
 */

public class NidoMain {

	private static final int CAPACIDAD = 8;
	private static final int PAJAROS = 2;
	private static final int POLLITOS = 10; 
	
	public static void main(String[] args) {
		
		Plato plato = new Plato(CAPACIDAD);
		Pajaro[] pajaros = new Pajaro[PAJAROS];
		Pollito[] pollitos = new Pollito[POLLITOS];
		for(int i=0; i<PAJAROS; i++){
			pajaros[i] = new Pajaro(i, plato);
			pajaros[i].start();
		}
		for(int i=0; i<POLLITOS; i++){
			pollitos[i] = new Pollito(i, plato);
			pollitos[i].start();
		}

	}

}
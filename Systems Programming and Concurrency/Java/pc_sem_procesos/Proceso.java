package pc_sem_procesos;

/**
 * @author Salvi CF
 */

import java.util.Random;

public class Proceso extends Thread{

	private UnidadControl control;
	private int id;
	private static Random r = new Random();
	
	public Proceso(UnidadControl control, int id){
		this.control = control;
		this.id = id;
	}
	
	@Override
	public void run(){
		int recursos;
		try{
			while(true){
				sleep(r.nextInt(10000));
				recursos = r.nextInt(10); 
				control.qrecursos(id, recursos);
				sleep(r.nextInt(3000));
				control.librecursos(id, recursos);
			}
		}catch (InterruptedException e){
			e.printStackTrace();
		}
	}
}

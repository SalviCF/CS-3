package pc_mon_pollitos;

/**
 * @author Salvi CF
 */

import java.util.Random;

public class Pollito extends Thread{

	private Plato plato;
	private int id;
	private static Random piando = new Random();
	
	public Pollito(int id, Plato plato){
		this.id = id;
		this.plato = plato;
	}
	
	@Override
	public void run(){
		while(true){
			try{
				piar();
				plato.comerBichito(id);
			}catch(InterruptedException e){
				e.printStackTrace();
			}
		}
	}
	
	public void piar() throws InterruptedException {
		System.out.println("El pollito " + id + " está piando.");
		sleep(piando.nextInt(10000));
	}
}

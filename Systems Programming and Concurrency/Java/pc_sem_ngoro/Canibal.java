package pc_sem_ngoro;

/**
 * @author Salvi CF
 */

import java.util.Random;

public class Canibal extends Thread{

	private Caldera caldera;
	private static Random bailando = new Random(); 
	private int id;
	
	public Canibal(int id, Caldera caldera){
		this.id = id;
		this.caldera = caldera;
	}
	
	@Override
	public void run(){
		while(true){
			try{
				bailar();
				caldera.comer(id);
			}catch(InterruptedException e){
				e.printStackTrace();
			}
		}
	}
	
	private void bailar() throws InterruptedException {
		System.out.println("El caníbal " + id + " está bailando.");
		sleep(bailando.nextInt(10000));
	}
}

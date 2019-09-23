package pc_sem_pollitos;

/**
 * @author Salvi CF
 */

import java.util.Random;

public class Pajaro extends Thread{

	private Plato plato;
	private static Random volando = new Random();
	private int id;
	
	public Pajaro(int id, Plato plato){
		this.id = id;
		this.plato = plato;
	}
	
	@Override
	public void run(){
		while(true){
			try{
				volar();
				plato.poneBichito(id); 
			}catch(InterruptedException e){
				e.printStackTrace();
			}
		}
	}
	
	public void volar() throws InterruptedException {
		System.out.println("El pájaro " + id + " ha salido a buscar bichitos.");
		sleep(volando.nextInt(1500));
	}
}
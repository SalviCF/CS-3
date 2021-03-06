package pc_sem_banco;

/**
 * @author Salvi CF
 */

import java.util.Random;

public class Cliente extends Thread{

	private Cuenta cuenta;
	private int id;
	private static Random r = new Random();
	
	public Cliente(Cuenta cuenta, int id){
		this.cuenta = cuenta;
		this.id = id;
	}
	
	@Override
	public void run(){
		int dinero;
		int sacarOmeter;
		
		while(true){
			try{
				dinero = r.nextInt(100);
				sleep(r.nextInt(3000)); 
				
				sacarOmeter = r.nextInt(2); 
				if(sacarOmeter == 0){
					cuenta.extraer(id, dinero);
				}else {
					cuenta.depositar(id, dinero);
				}
			}catch (InterruptedException e){
				e.printStackTrace();
			}
		}
	}
}

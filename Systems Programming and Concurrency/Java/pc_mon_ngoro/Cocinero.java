package pc_mon_ngoro;

/**
 * @author Salvi CF
 */

public class Cocinero extends Thread{

	private Caldera caldera;
	
	public Cocinero(Caldera caldera){
		this.caldera = caldera;
	}
	
	@Override
	public void run(){
		try{
			while(true){
				caldera.dormirCocinar(); //
			}
		}catch(InterruptedException e){
			e.printStackTrace();
		}
	}
}

package pc_mon_banco;

/**
 * Producer-consumer. Monitors.
 * 
 * @author Salvi CF
 */

public class BancoMain {

	public static void main(String[] args) {

		Cuenta cuenta = new Cuenta(); //creo la cuenta
		
		//Creo a los clientes
		for(int i=0; i<10; i++){
			new Cliente(cuenta, i).start();
		}		
	}

}

package paquete;
// http://mycyberacademy.com/resolver-problemas-aplicando-la-estrategia-divide-y-venceras/
public class algoritmos {

	public static void main(String[] args) {
		// Exponentiation by squaring
		int base=2, exponente=21;
		System.out.println(potencia(base,exponente));
		
	}
	
	public static int potencia(int base, int exponente){
		int res=0;
		
		if (exponente == 0){ res = 1; }
		else if (exponente == 1){ res = base; }
		else {
			res = potencia((base*base), (exponente/2));
			if (exponente % 2 == 1) { // impar
				res = base*res;
			}
		}
		return res;
	}
}

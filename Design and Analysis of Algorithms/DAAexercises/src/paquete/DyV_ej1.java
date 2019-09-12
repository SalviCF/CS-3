package paquete;

public class DyV_ej1 {

	public static void main(String[] args) {
		int v[] = {-1,0,2,5,7};
		System.out.println(coincide(v, 0, v.length-1));

	}
	
	// devuelve -1 si no existe índice i tal que i = v[i]
	public static int coincide(int a[], int inic, int fin){
		int res = -1;
		if (inic > fin){return -1;}
		
		else if (inic == fin){
			if (a[inic] == inic){return inic;}
			else {return res;}
		}
		
		else if (inic < fin){
			int m = (inic + fin)/2;
			if (m < a[m]){res = coincide(a, inic, m-1);}
			else if (m == a[m]){res = m;}
			else if (m > a[m]){res = coincide(a, m+1, fin);}
		}
		return res;
	}
}



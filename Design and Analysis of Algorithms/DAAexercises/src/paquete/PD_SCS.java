package paquete;

public class PD_SCS {

	public static void main(String[] args) {
		String w1 = "geeeeek";
		String w2 = "eeekeee";
		
		int[][] scs = new int[w1.length()+1][w2.length()+1];
		
		for (int i=0; i<=w1.length(); i++){ scs[i][0] = i; }
		for (int j=0; j<=w2.length(); j++){ scs[0][j] = j; }
		
		for (int i=1; i<=w1.length(); i++){
			for (int j=1; j<=w2.length(); j++){
				if (w1.charAt(i-1) == w2.charAt(j-1)){
					scs[i][j] = scs[i-1][j-1]+1;
				} else {
					scs[i][j] = Math.min(scs[i-1][j], scs[i][j-1])+1;
				}
			} 
		}

		for (int i=0; i<=w1.length(); i++){
			for (int j=0; j<=w2.length(); j++){
				System.out.print(scs[i][j]+" ");
			} System.out.println();
		}
	}

}

package postFix;

public class Data extends Item{

	private int value;
	
	public Data(int v){
		value = v;
	}
	
	public boolean isData(){
		return true;
	}
	
	public int getValue(){
		return value;
	}
}

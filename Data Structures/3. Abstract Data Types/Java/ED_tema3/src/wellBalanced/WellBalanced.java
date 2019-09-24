/*
 * @author Salvi CF
 */

/*
 * Escribe un programa Java que tome como argumento una cadena de caracteres y 
 * que escriba por pantalla si ésta está equilibrada
 */

package wellBalanced;
import dataStructures.stack.*;

public class WellBalanced {
	private final static String OPEN_PARENTHESES = "{[(";
	private final static String CLOSED_PARENTHESES = "}])";
	

	public static void main(String[] args) {
		
		String s = "ff({h([sds]ss)hags})";
		Stack<Character> st = new LinkedStack<>();
		System.out.println(wellBalanced(s, st));
	}
	
	public static boolean wellBalanced(String exp, Stack<Character> stack){
		
		for (int i = 0; i < exp.length(); i++){
		    char c = exp.charAt(i);        

		    if (isOpenParentheses(c)){
		    	stack.push(c);
		    }
		    else if (isCloseParentheses(c)){
		    	if (!stack.isEmpty() && match(stack.top(), c)){ // (open, closed)
		    		stack.pop();
		    	} else {
		    		return false;
		    	}
		    }
		}
		
		return stack.isEmpty();
	}
	
	public static boolean isOpenParentheses(char c){
		return OPEN_PARENTHESES.indexOf(new Character(c).toString()) >= 0;
	}
	
	public static boolean isCloseParentheses(char c){
		return CLOSED_PARENTHESES.indexOf(new Character(c).toString()) >= 0;
	}
	
	public static boolean match(char x, char y){
		return OPEN_PARENTHESES.indexOf(new Character(x).toString()) == 
				CLOSED_PARENTHESES.indexOf(new Character(y).toString());
	}

}

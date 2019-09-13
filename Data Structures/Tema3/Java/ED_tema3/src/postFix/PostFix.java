/*
 * @author Salvi CF
 */

// Postfix expressions evaluation using Stack

package postFix;

import dataStructures.stack.*;

public class PostFix {

	public static void main(String[] args) {
		
		Item[] sample = {
				new Data(5),
				new Data(6),
				new Data(2),
				new Dif(),
				new Data(3),
				new Mul(),
				new Add()};
		
		System.out.println(evaluate(sample));
	}
	
	/** 
	 * @param Items representing a post fix expression
	 * @return Result of evaluating the expression
	 */
	public static int evaluate(Item[] exprList){

		Stack<Item> st = new LinkedStack<>();
		
		for (int i=0; i<exprList.length; i++){
			Item it = exprList[i];
			
			if (it.isData()){
				st.push(it);
			} else if (it.isOperation()){
				int op2 = st.top().getValue();
				st.pop();
				
				int op1 = st.top().getValue();
				st.pop();
				
				int rParcial = it.evaluate(op1, op2);
				st.push(new Data(rParcial));
			}
		}
		
		return st.top().getValue();
	}

}

/******************************************************************************
 * Data Structures
 * @author Salvi CF
******************************************************************************/

package dataStructures.vector;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class SparseVector<T> implements Iterable<T> {

    protected interface Tree<T> {

        T get(int sz, int i);

        Tree<T> set(int sz, int i, T x);
    }

    // Unif Implementation

    protected static class Unif<T> implements Tree<T> {

        private T elem;

        public Unif(T e) {
            elem = e;
        }

        @Override
        public T get(int sz, int i) {
            // TODO
            return elem;
        }

        @Override
        public Tree<T> set(int sz, int i, T x) {
            // TODO
        	//Tree<T> tree = null; does not modify the tree
        	
        	
        	if (sz == 1){
        		return new Unif<T>(x);
        	} 
        	
        	int mitad = sz/2;
        	Node<T> n;
        	
        	if (i < mitad){
        		n = new Node<T>(set(mitad, i, x), this);
        	} else {
        		n = new Node<T>(this, set(mitad, i-mitad, x));
        	}
        	
        	return n;
        }

        @Override
        public String toString() {
            return "Unif(" + elem + ")";
        }
    }

    // Node Implementation

    protected static class Node<T> implements Tree<T> {

        private Tree<T> left, right;

        public Node(Tree<T> l, Tree<T> r) {
            left = l;
            right = r;
        }

        @Override
        public T get(int sz, int i) {
            // TODO
        	int hsz = sz / 2;

			if (i < hsz){
				return left.get(hsz, i);
			} else {
				return right.get(hsz, i - hsz);
			}
        }

        @Override
        public Tree<T> set(int sz, int i, T x) {
            // TODO
			int hsz = sz / 2;

			if (i < hsz){
				left = left.set(hsz, i, x);
			} else {
				right = right.set(hsz, i - hsz, x);
			}
			return this;
        }

        protected Tree<T> simplify() {
            // TODO
        	
        	if (left instanceof Unif<?> && right instanceof Unif<?>){
				Unif<T> leftU = (Unif<T>) left;
				Unif<T> rightU = (Unif<T>) right;
				if (leftU.elem.equals(rightU.elem)){
					return leftU;
				}
        	} 
        	
            return this;
        }

        @Override
        public String toString() {
            return "Node(" + left + ", " + right + ")";
        }
    }

    // SparseVector Implementation

    private int size;
    private Tree<T> root;

    public SparseVector(int n, T elem) {
        // TODO
    	if (n < 0){
    		throw new VectorException("exponente negativo");
    	}
    	size = (int) Math.pow(2, n);
    	root = new Unif<>(elem);
    }

    public int size() {
        // TODO
        return size;
    }

    public T get(int i) {
        // TODO
    	T res = null;
    	if (i<0 || i>size-1){
    		throw new VectorException("índice fuera de rango");
    	}
    	res = root.get(size, i);
        return res;
    }

    public void set(int i, T x) {
        // TODO
    	if (i<0 || i>size-1){
    		throw new VectorException("índice fuera de rango");
    	}
    	root = root.set(size, i, x);
    }

    @Override
    public Iterator<T> iterator() {
        // TODO
		List<T> lista = new ArrayList<>();

		for (int i = 0; i < size; i++) {
			lista.add(get(i));
		}

		return lista.iterator();
    }

    @Override
    public String toString() {
        return "SparseVector(" + size + "," + root + ")";
    }
}

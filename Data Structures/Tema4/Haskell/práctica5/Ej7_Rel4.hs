---------------------------------------------------------------------------------
-- Estructuras de Datos
--
-- Práctica 5 - Ejercicio extra
--      Ejercicio 4.7: exploración en anchura de una  árbol general
--
-- Salvi CF
---------------------------------------------------------------------------------

module P5Levels where

import DataStructures.Queue.LinearQueue

data Tree a = Empty | Node a [Tree a] deriving Show

-- Determina cuando un arbol general esta vacio
isEmptyTree Empty = True
isEmptyTree _     = False

-- Devuelve una lista que representa el recorrido del arbol general por niveles
levels :: Tree a -> [a]

levels Empty = []
levels t = levelsAux (enqueue t empty)

-- Visita el nodo del primero de la cola y encola sus hijos no vacios
-- generando la lista de nodos visitados
levelsAux q
  | isEmpty q = []
  | otherwise = x : levelsAux (enqueueAll (dequeue q) ts)
 where
      Node x ts   = first q

-- Encola los elementos de la lista xs (de cabeza a cola) en la cola queue
-- siempre que no sean arboles vacios
enqueueAll queue [] = queue
enqueueAll queue (x:xs) = enqueueAll (enqueue x queue) xs   -- cada x es un subárbol hijo


t1 = Node 4 [   Node 5 [Node 6 [], Node 7 [], Node 2 []]
              , Node 8 []
              , Node 1 [Node 9 [], Node 3 []]
            ]
{-
*Ejer_4_7_levels> levels t1
[4,5,8,1,6,7,2,9,3]
-}

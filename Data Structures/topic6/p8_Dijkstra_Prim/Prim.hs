-- Data Structures
-- Practice 8. Prim's algorithm
--
-- Author: Salvi CF
-------------------------------------------------------------------------------

module Prim where

import DataStructures.Graph.WeightedGraph
import Data.List(delete, minimumBy) -- consulta delete y minimumBy en Hoogle

-- prim g v : aplica el algoritmo  de Prim al grafo g para calcular el
-- árbol de expansión mínima con raíz en el nodo v

prim :: (Eq a, Ord w) => WeightedGraph a w -> a -> [WeightedEdge a w]
prim g v
   | v `elem` vs = primAux g [v] (delete v vs) []
   | otherwise = error "el vértice v no está en el grafo g"
   where
     vs = vertices g

-- primAux g vs rs st : vs  son los nodos visitados  que forman parte
-- del árbol, rs el resto de nodos  por visitar y st almacena el árbol
-- de expansión (lista de aristas con peso) computado hasta el momento

primAux :: (Eq a, Ord w) => WeightedGraph a w -> [a] ->  [a] -> [WeightedEdge a w] -> [WeightedEdge a w]
primAux g _  [] st = st
primAux g vs rs st = primAux g (y : vs) (delete y rs) (arcMin : st)
   where
      -- encontrar la arista de menor peso de un vértice de vs a otro de rs
      arcMin@(WE x p y) = minimumBy comparaArcos cruces
      -- comparar arcos por pesos (para minimumBy)
      comparaArcos (WE _ p1 _) (WE _ p2 _) = compare p1 p2
      -- aristas entre los vértices de vs y rs
      cruces = [ (WE v w r) | (WE v w r) <- edges g, v `elem` vs, r `elem` rs ]

-- ejemplos de grafos

g1 :: WeightedGraph Char Int
g1 = mkWeightedGraphEdges ['a','b','c','d','e']
                          [ WE 'a' 3 'b', WE 'a' 7 'd'
                          , WE 'b' 4 'c', WE 'b' 2 'd'
                          , WE 'c' 5 'd', WE 'c' 6 'e'
                          , WE 'd' 5 'e'
                          ]
{-
*Prim> prim g1 'a'
[WE 'd' 5 'e',WE 'b' 4 'c',WE 'b' 2 'd',WE 'a' 3 'b']
-}

gEjer3 :: WeightedGraph Char Int
gEjer3 = mkWeightedGraphEdges ['a','b','c','d','e','f','g']
                              [ WE 'a' 7 'b', WE 'a' 5 'd'
                              , WE 'b' 9 'd', WE 'b' 8 'c', WE 'b' 7 'e'
                              , WE 'c' 5 'e'
                              , WE 'd' 15 'e', WE 'd' 6 'f'
                              , WE 'e' 8 'f', WE 'e' 9 'g'
                              , WE 'f' 11 'g'
                              ]
{-
*Prim> prim gEjer3 'a'
[WE 'e' 9 'g',WE 'e' 5 'c',WE 'b' 7 'e',WE 'a' 7 'b',WE 'd' 6 'f',WE 'a' 5 'd']
-}

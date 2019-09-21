-------------------------------------------------------------------------------
-- Data Structures
-- Author: Salvi CF
-------------------------------------------------------------------------------

--module DataStructures.Graph.EulerianCycle(isEulerian, eulerianCycle) where
module DataStructures.Graph.EulerianCycle where

import DataStructures.Graph.Graph
import Data.List

--H.1)
{-
isEulerian :: Eq a => Graph a -> Bool
isEulerian g = foldr f z (vertices g)
  where
    f v acc = if (even $ degree g v) then (True && acc) else (False && acc)
    z = True
-}

-- Otra solución
isEulerian :: Eq a => Graph a -> Bool
isEulerian g = all (even) $ map (degree g) (vertices g)

-- H.2)
remove :: (Eq a) => Graph a -> (a,a) -> Graph a
remove g (v,u) = delete0 (vertices g') g'
  where
    g' = deleteEdge g (v,u)   -- grafo tras eliminar la arista
    delete0 [] graph = graph
    delete0 (v:vs) graph  | (degree graph v == 0) = delete0 vs (deleteVertex graph v)
                          | otherwise = delete0 vs graph

-- H.3)
extractCycle :: (Eq a) => Graph a -> a -> (Graph a, Path a)
extractCycle g v0 = ec g [v0]
  where
    ec graph p@(v:vs) | (s == v0) = (remove graph (v,s), s:p)
                      | otherwise = ec (remove graph (v,s)) (s : p)
      where
        (s:_) = successors graph v

-- Otra solución
{-
extractCycle :: (Eq a) => Graph a -> a -> (Graph a, Path a)
extractCycle g v0 = ec g [v0] v0
  where
    ec graph p v | (s == v0) = (remove graph (v,s), p++[s])
                 | otherwise = ec (remove graph (v,s)) (p++[s]) s
     where
       (s:_) = successors graph v
-}

-- H.4)
connectCycles :: (Eq a) => Path a -> Path a -> Path a
connectCycles [] ys = ys
connectCycles (x:xs) c@(y:ys) | (x == y) = c ++ xs
                              | otherwise = x : connectCycles xs c

-- H.5)
vertexInCommon :: Eq a => Graph a -> Path a -> a
vertexInCommon g ciclo = head [ v | v <- vertices g, c <- ciclo, (v == c) ]

-- H.6)
eulerianCycle :: Eq a => Graph a -> Path a
eulerianCycle g   | isEulerian g = ec g (head $ vertices g) []    -- grafo, vértice inicial, ciclo inicial
                  | otherwise = error "eulerianCycle: El grafo no es euleriano"
  where
    ec graph v c  | isEmpty graph = c
                  | otherwise = ec gsc vc (connectCycles c ciclo)
      where
        (gsc, ciclo) = extractCycle graph v   -- grafo sin el ciclo
        vc = vertexInCommon gsc ciclo         -- vértice común entre el grafo sin ciclo y el ciclo parcial

-- Estructuras de Datos
-- Autor: Salvi CF
-- Relación de ejercicios 4. Ejercicios resueltos: 7, 10, 14, 15, 16, 17, 19, 20, 22, 24

import Data.List
--------------------------------------------------------------------------------
-- Ejercicio 7
--------------------------------------------------------------------------------
-- hecho como ejercicio complementario en la práctica 5

--------------------------------------------------------------------------------
-- Ejercicio 10
--------------------------------------------------------------------------------
-- hecho en el código que nos dan

--------------------------------------------------------------------------------
-- Ejercicio 14
--------------------------------------------------------------------------------
data Expr = Value Integer
          | Add Expr Expr
          | Diff Expr Expr
          | Mult Expr Expr
          deriving Show

-- árbol binario
e1 :: Expr
e1 = Mult (Add (Value 1) (Value 2)) (Value 3)

-- a)
evaluate :: Expr -> Integer
evaluate (Value x)  = x
evaluate (Add l r)  = evaluate l + evaluate r
evaluate (Diff l r) = evaluate l - evaluate r
evaluate (Mult l r) = evaluate l * evaluate r

-- b)
toRPN :: Expr -> String
toRPN = postOrderB

postOrderB :: Expr -> String
postOrderB (Value x)  = show x
postOrderB (Add l r)  = postOrderB l ++ " " ++ postOrderB r ++ " +"
postOrderB (Diff l r) = postOrderB l ++ " " ++ postOrderB r ++ " -"
postOrderB (Mult l r) = postOrderB l ++ " " ++ postOrderB r ++ " *"

-- c)
-- pliego cada subárbol con el operador correspondiente
foldExpr :: (Integer -> a) ->
            (a -> a -> a) ->
            (a -> a -> a) ->
            (a -> a -> a) ->
            Expr -> a
foldExpr ifValue ifAdd ifDiff ifMult e = fun e
  where
    fun (Value x)     = ifValue x
    fun (Add e1 e2)   = ifAdd (fun e1) (fun e2)
    fun (Diff e1 e2)  = ifDiff (fun e1) (fun e2)
    fun (Mult e1 e2)  = ifMult (fun e1) (fun e2)

ifValue x = x
ifAdd (e1) (e2) = (+) (e1) (e2)
ifDiff (e1) (e2) = (-) (e1) (e2)
ifMult (e1) (e2) = (*) (e1) (e2)

evaluate' :: Expr -> Integer
evaluate' e = foldExpr ifValue ifAdd ifDiff ifMult e

--------------------------------------------------------------------------------
-- Ejercicio 15
--------------------------------------------------------------------------------
data TreeB a = EmptyB | NodeB a (TreeB a) (TreeB a) deriving (Show, Eq)

-- a)
mirrorB :: TreeB a -> TreeB a
mirrorB EmptyB = EmptyB
mirrorB (NodeB x lt rt) = NodeB x (mirrorB rt) (mirrorB lt)

-- b)
{-
mirrorB . mirrorB = id

Caso base: (mirrorB . mirrorB) EmptyB = EmptyB
Paso inductivo: Si (mirrorB . mirrorB) lt = lt y además,
                   (mirrorB . mirrorB) rt = rt
                entonces (mirrorB . mirrorB) (NodeB x lt rt) = NodeB x lt rt

1º Demostramos el caso base:
(mirrorB . mirrorB) EmptyB
=> { por definición de composición }
mirrorB (mirrorB EmptyB)
=> { por definición de mirrorB }
mirrorB (EmptyB)
=> { por definición de mirrorB }
EmptyB

Por lo que queda demostrado el caso base.

2º Demostramos el caso inductivo:
Desarrollamos el miembro izquierdo de la igualdad:

(mirrorB . mirrorB) (NodeB x lt rt)
=> { por definición de composición }
mirrorB (mirrorB (NodeB x lt rt))
=> { por definición de mirrorB (interno) }
mirrorB (NodeB x (mirrorB rt) (mirrorB lt))
=> { por definición de mirrorB (externo) }
NodeB x (mirrorB (mirrorB lt)) (mirrorB (mirrorB rt))
=> { por definición de composición }
NodeB x ((mirrorB . mirrorB) lt) ((mirrorB . mirrorB) rt)
=> { por hipótesis de inducción }
NodeB x (lt) (rt)

Con lo que queda demostrado el caso inductivo y, por tanto, mirrorB . mirrorB = id
-}

--------------------------------------------------------------------------------
-- Ejercicio 16
--------------------------------------------------------------------------------
isSymmetricB :: Eq a => TreeB a -> Bool
isSymmetricB (NodeB x lt rt) = (rt == mirrorB lt)

--------------------------------------------------------------------------------
-- Ejercicio 17
--------------------------------------------------------------------------------
-- a)
leafsB :: TreeB a -> [a]
leafsB EmptyB = []
leafsB (NodeB x EmptyB EmptyB) = [x]
leafsB (NodeB x lt rt) = leafsB lt ++ leafsB rt

-- b)
internalsB :: TreeB a -> [a]
internalsB EmptyB = []
internalsB (NodeB x EmptyB EmptyB) = []
internalsB (NodeB x lt rt) = [x] ++ internalsB lt ++ internalsB rt

-- c)
data Tree a = Empty | Node a [Tree a] deriving Show

leafs :: Tree a -> [a]
leafs Empty = []
leafs (Node x []) = [x]
leafs (Node x ts) = concat $ map leafs ts


internals :: Tree a -> [a]
internals Empty = []
internals (Node x []) = []
internals (Node x ts) = [x] ++ (concat $ map internals ts)

--------------------------------------------------------------------------------
-- Ejercicio 19
--------------------------------------------------------------------------------
internalPL :: Tree a -> Int
internalPL t = internalPL' t 1
  where
    internalPL' (Node x ts) nivel = (nivel * length ts) + sum [ internalPL' t (nivel+1) | t <- ts ]

--------------------------------------------------------------------------------
-- Ejercicio 20
--------------------------------------------------------------------------------
t1 :: Tree Integer
t1 = Node 1 [Node 2 [Node 5 []],Node 3 [Node 7 [],Node 8 []],Node 4 []]

allMaxPaths :: Tree a -> [[a]]
allMaxPaths (Node x []) = [[x]]
allMaxPaths (Node x ts) = map (x :) $ concat [ allMaxPaths t | t <- ts ]

--------------------------------------------------------------------------------
-- Ejercicio 22
--------------------------------------------------------------------------------
findTreeB :: Eq a => [a] -> [a] -> TreeB a
findTreeB [] [] = EmptyB
findTreeB (r:pre) ino = (NodeB r lt rt)
  where
    (ltino, _:rtino)  = span (/= r) ino
    (ltpre, rtpre)    = splitAt (length ltino) pre
    lt = findTreeB ltpre ltino
    rt = findTreeB rtpre rtino

--------------------------------------------------------------------------------
-- Ejercicio 24
--------------------------------------------------------------------------------
{-
Para implementar una cola mediante una cola con prioridad, habría que otorgar
la prioridad de forma que cuando insertemos unn nuevo elemento,le asignemos
la mínima prioridad. Así, al llamar a first (queue) se obtendrá el primer
elemento que se insertó. Podría hacerse dándole al n-ésimo elemento la prioridad
n, siendo n más prioritario que (n+1).

Para implementar una pila mediante una cola con prioridad, se procede de forma
similar a como hemos hecho para implementar la cola. La diferencia está en que
ahora lo que queremos no es FIFO sino LIFO. Es decir, cuando insertemos un
nuevo elemento le tenemos que dar la máximo prioridad. Podría hacerse dándole
al n-ésimo elemento la prioridad n, pero en este caso, tomaremos que (n+1) es
más prioritario que n.
-}

--

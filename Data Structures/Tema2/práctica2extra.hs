-- Práctica 2 - Ejercicios extra
--
-- Alumno: Carrillo Fuentes, Salvador
-------------------------------------------------------------------------------

module Practica2Extra where

import Test.QuickCheck
import Text.Show.Functions
import Data.Char

----------------------------------------------------------------------
-- Ejercicio - empareja
----------------------------------------------------------------------

empareja :: [a] -> [b] -> [(a, b)]
empareja (x:xs) (y:ys) = (x, y) : empareja xs ys
empareja _ _ = []

prop_empareja_OK :: (Eq b, Eq a) => [a] -> [b] -> Bool
prop_empareja_OK xs ys = zip xs ys == empareja xs ys

{-
*Practica2Extra> quickCheck prop_empareja_OK
+++ OK, passed 100 tests.
-}

----------------------------------------------------------------------
-- Ejercicio - emparejaCon
----------------------------------------------------------------------

emparejaCon ::  (a -> b -> c) -> [a] -> [b] -> [c]
emparejaCon f (x:xs) (y:ys) = f x y : emparejaCon f xs ys
emparejaCon _ _ _ = []

prop_emparejaCon_OK :: Eq c => (a -> b -> c) -> [a] -> [b] -> Bool
prop_emparejaCon_OK f xs ys = zipWith f xs ys == emparejaCon f xs ys

{-
*Practica2Extra> chr 97
'a'
*Practica2Extra> ord 'a'
97
*Practica2Extra> quickCheck prop_emparejaCon_OK
+++ OK, passed 100 tests.
-}

----------------------------------------------------------------------
-- Ejercicio - separa
----------------------------------------------------------------------
separaRec :: (a -> Bool) -> [a] -> ([a], [a])
separaRec p xs = separaRec' p xs ([], [])
  where separaRec' p (x:xs) (l1, l2)  | p x = separaRec' p xs (l1 ++ [x], l2)
                                      | otherwise = separaRec' p xs (l1, l2 ++ [x])
        separaRec' _ _ (l1, l2) = (l1, l2)

separaC :: (a -> Bool) -> [a] -> ([a], [a])
separaC p xs = (l1, l2)
  where l1 = [ x | x <- xs, p x ]
        l2 = [ x | x <- xs, not (p x)]

{-
foldr (:) [1, 2, 3] [4, 5, 6]
...
4 : (5 : (6 : [1, 2, 3]))
-}

separaP :: (a -> Bool) -> [a] -> ([a], [a])
separaP p xs = foldr (\x (l1, l2) -> if p x then (x:l1, l2) else (l1, x:l2)) ([], []) xs

{-
separaP even [1, 2, 3, 4]
foldr (\x (l1, l2) -> if even x then (x:l1, l2) else (l1, x:l2)) ([], []) [1, 2, 3, 4]
foldr (\x (l1, l2) -> if even 4 then (4:[], []) else ([], 4:[])) ([], []) [1, 2, 3, 4]
1 f (2 f (3 f (4 f ([], []))))
1 f (2 f (3 f ([4], [])))
1 f (2 f ([4], [3]))
1 f ([2, 4], [3])
([2, 4], [1, 3])
-}

prop_separa_OK :: Eq a => (a -> Bool) -> [a] -> Bool
prop_separa_OK p xs = (separaRec p xs == separaC p xs) && (separaC p xs == separaP p xs)

{-
*Practica2Extra> quickCheck prop_separa_OK
+++ OK, passed 100 tests.
-}

----------------------------------------------------------------------
-- Ejercicio - lista de pares
----------------------------------------------------------------------

cotizacion :: [(String, Double)]
cotizacion = [("apple", 116), ("intel", 35), ("google", 824), ("nvidia", 67)]

buscarRec :: Eq a => a -> [(a,b)] -> [b]
buscarRec _ [] = []
buscarRec k ((k', v):xs)  | (k == k') = [v]
                          | otherwise = buscarRec k xs

buscarC :: Eq a => a -> [(a, b)] -> [b]
buscarC k ys = take 1 [ snd par | par <- ys, k == fst par ]

buscarP :: Eq a => a -> [(a, b)] -> [b]
buscarP k ys = foldr (\(k', v) acc -> if k==k' then [v] else acc) [] ys

{-
buscarP "google" [("apple", 116), ("intel", 35), ("google", 824), ("nvidia", 67)]
foldr (\(k', v) acc -> if "google"==k' then [v] else acc) [] [("apple", 116), ("intel", 35), ("google", 824), ("nvidia", 67)]
("apple", 116) f (("intel", 35) f (("google", 824) f (("nvidia", 67) f [])))
("apple", 116) f (("intel", 35) f (("google", 824) f []))
("apple", 116) f (("intel", 35) f [824])
("apple", 116) f [824]
[824]
-}

prop_buscar_OK :: (Eq a, Eq b) => a -> [(a, b)] -> Bool
prop_buscar_OK x ys = (buscarRec x ys == buscarC x ys) && (buscarC x ys == buscarP x ys)

{-
*Practica2Extra> quickCheck prop_buscar_OK
+++ OK, passed 100 tests.
-}

{-
Responde las siguientes preguntas si falla la propiedad anterior.

¿Por qué falla la propiedad prop_buscar_OK?
*Practica2Extra> buscarRec "()" [("()",()),("()",())]
[()]
*Practica2Extra> buscarP "()" [("()",()),("()",())]
[()]
*Practica2Extra> buscarC "()" [("()",()),("()",())]
[(),()]

Realiza las modificaciones necesarias para que se verifique la propiedad.
Añado take 1 a la función buscarC para que sean equivalentes
-}

valorCartera :: [(String, Double)] -> [(String, Double)] -> Double
valorCartera cartera mercado = sum . concat . map (\c -> map (\m -> snd m * snd c) . filter (\x -> fst x == fst c) $ mercado) $ cartera

{-
Otra posible notación:
valorCartera :: [(String, Double)] -> [(String, Double)] -> Double
valorCartera cartera@((k, v):xs) mercado@((k', v'):ys) = sum . map ((*v) . snd) . filter (\(k', v) -> k==k') $ mercado

Equivalencia entre listas por comprensión y map/filter
página 145 Razonando con Haskell
http://www2.math.ou.edu/~dmccullough/teaching/f06-6833/haskell/map_filter.pdf

Filtra aquellos elementos de "mercado" tales que su clave coincide con la clave los elementos de "cartera".
A los elementos de la lista resultado del filtrado le aplico map. Selecciono su valor y lo multiplico por la cantidad.
Por cada elemento de "cartera" (map externo) se prueba con todos los elementos de "mercado" (map interno). map (\c -> map (\m -> ...
A todos los elementos de "cartera" le aplico una función mediante map.
Esta función hace el filtrado y aplica una función a todos los elementos de ese filtrado mediante map.
Recibo un elemento de "cartera" y devuelvo map (...) . filter (...) $ mercado. Eso con todos los elementos de "cartera".
Finalmente, concateno para fundir los elementos de la lista principal en una sola lista y sumo los elementos de ésta.
-}

valorCartera2 :: [(String, Double)] -> [(String, Double)] -> Double
valorCartera2 cartera mercado = sum [ snd y | x <- cartera, y <- mercado, fst x == fst y  ]

----------------------------------------------------------------------
-- Ejercicio - mezcla
----------------------------------------------------------------------

mezcla :: Ord a => [a] -> [a] -> [a]
mezcla [] ys = ys
mezcla xs [] = xs
mezcla (x:xs) (y:ys)  | (x <= y)   = x : mezcla xs (y:ys)
                      | otherwise = y : mezcla (x:xs) ys

----------------------------------------------------------------------
-- Ejercicio - takeUntil
----------------------------------------------------------------------

takeUntil :: (a -> Bool) -> [a] -> [a]
takeUntil _ [] = []
takeUntil p (x:xs)  | p x = []
                    | otherwise = x : takeUntil p xs

prop_takeUntilOK :: Eq a => (a -> Bool) -> [a] -> Bool
prop_takeUntilOK p xs = takeUntil p xs == takeWhile (not . p) xs

{-
*Practica2Extra> quickCheck prop_takeUntilOK
+++ OK, passed 100 tests.
-}

----------------------------------------------------------------------
-- Ejercicio - número feliz
----------------------------------------------------------------------

digitosDe :: Integer -> [Integer]
digitosDe x = digitosDeAc x []
  where digitosDeAc x ac  | (x < 10) = x : ac
                          | otherwise = digitosDeAc (div x 10) (mod x 10 : ac)


sumaCuadradosDigitos :: Integer -> Integer
sumaCuadradosDigitos x = sum . map (^2) $ digitosDe x

esFeliz :: Integer -> Bool
esFeliz x = esFelizAc x []
  where esFelizAc x ac  | (sumaCuadradosDigitos x == 1) = True
                        | (x `elem` ac) = False
                        | otherwise = esFelizAc (sumaCuadradosDigitos x) (x : ac)

felicesHasta :: Integer -> [Integer]
felicesHasta x = [ n | n <- [1..x], esFeliz n ]

{-

Responde a la siguiente pregunta.

¿Cuántos números felices hay menores o iguales que 1000?
*Practica2Extra> length $ felicesHasta 1000
143

-}

----------------------------------------------------------------------
-- Ejercicio - borrar
----------------------------------------------------------------------

borrarRec :: Eq a => a -> [a] -> [a]
borrarRec _ [] = []
borrarRec x (y:ys)  | (x == y) = borrarRec x ys
                    | otherwise = y : borrarRec x ys

borrarC :: Eq a => a -> [a] -> [a]
borrarC x ys = [ e | e <- ys, e /= x ]

borrarP :: Eq a => a -> [a] -> [a]
borrarP x ys = foldr (\y ac -> if y==x then ac else y:ac) [] ys

{-
borrarP 2 [1,2,2,3,2,2,1]
foldr (\y ac -> if y==2 then ac else y:ac) [] [1,2,2,3,2,2,1]
1 f (2 f (2 f (3 f (2 f (2 f (1 f [])))))) ... 1 f [] == f 1 [] donde y = 1, ac = []
-}

prop_borrar_OK :: Eq a => a -> [a] -> Bool
prop_borrar_OK x ys = (borrarRec x ys == borrarC x ys) && (borrarC x ys == borrarP x ys)

{-
*Practica2Extra> quickCheck prop_borrar_OK
+++ OK, passed 100 tests.
-}

----------------------------------------------------------------------
-- Ejercicio - agrupar
----------------------------------------------------------------------

agrupar :: Eq a => [a] -> [[a]]
agrupar xs = foldr f [] xs
  where f x [] = [ [x] ]
        f x ((y:ys):zss)  | (x == y)  = (x : (y:ys)) : zss
                          | otherwise = [x] : (y:ys) : zss

-- zss es una lista de listas. (y:ys) es la primera lista de zss.

{-
agrupar [1,2,2,3,3,3]
foldr f [] [1,2,2,3,3,3]
3 f ([])
[ [3] ]
3 f ([ [3] ]) == 3 f ((3 : []) : [])
(3 : (3 : []) : [] == [ [3, 3] ]
3 f [ [3, 3] ]
[ [3, 3, 3] ]
2 f [ [3, 3, 3] ]
[2] : [3, 3, 3] : [] == [ [2],[3,3,3] ]
2 f [ [2],[3,3,3] ]
[ [2,2], [3,3,3] ]
1 f [ [2,2], [3,3,3] ] ... { x=1, (y:ys)=2:[2], zss=[ [3,3,3] ] }
[ [1], [2,2], [3,3,3] ]
-}

----------------------------------------------------------------------
-- Ejercicio - aplica
----------------------------------------------------------------------

aplicaRec :: a -> [ a -> b] -> [b]
aplicaRec _ []      = []
aplicaRec x (f:fs)  = f x : aplicaRec x fs

aplicaC :: a -> [ a -> b] -> [b]
aplicaC x fs = [ f x | f <- fs ]

aplicaP :: a -> [ a -> b] -> [b]
aplicaP x fs = foldr (\f ac -> f x : ac) [] fs

{-
aplicaP 5 [(*2), (+3)]
foldr (\f ac -> f 5 : ac) [] [(*2), (+3)]
(+3) f []
(+3) 5 : []
[8]
(*2) f [8]
(*2) 5 : [8]
[10, 8]
-}

aplicaM :: a -> [ a -> b] -> [b]
aplicaM x fs = map (\f -> f x) fs

prop_aplica_OK :: Eq b => a -> [a -> b] -> Bool
prop_aplica_OK x fs = all (== aplicaRec x fs) [aplicaC x fs, aplicaP x fs, aplicaM x fs]

{-
*Practica2Extra> quickCheck prop_aplica_OK
+++ OK, passed 100 tests.
-}

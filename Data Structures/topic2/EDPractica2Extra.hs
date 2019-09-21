-- Práctica 2 - Ejercicios extra
--
-- Alumno: Salvador CF
-------------------------------------------------------------------------------

module Practica2Extra where

import Test.QuickCheck
import Text.Show.Functions
import Data.Char

----------------------------------------------------------------------
-- Ejercicio - empareja
----------------------------------------------------------------------

empareja :: [a] -> [b] -> [(a, b)]
empareja xs ys = undefined

prop_empareja_OK :: (Eq b, Eq a) => [a] -> [b] -> Bool
prop_empareja_OK xs ys = undefined

----------------------------------------------------------------------
-- Ejercicio - emparejaCon
----------------------------------------------------------------------

emparejaCon ::  (a -> b -> c) -> [a] -> [b] -> [c]
emparejaCon f xs ys = undefined

prop_emparejaCon_OK :: Eq c => (a -> b -> c) -> [a] -> [b] -> Bool
prop_emparejaCon_OK f xs ys = undefined

----------------------------------------------------------------------
-- Ejercicio - separa
----------------------------------------------------------------------

separaRec :: (a -> Bool) -> [a] -> ([a], [a])
separaRec p xs = undefined

separaC :: (a -> Bool) -> [a] -> ([a], [a])
separaC p xs = undefined

separaP :: (a -> Bool) -> [a] -> ([a], [a])
separaP p xs = undefined

prop_separa_OK :: Eq a => (a -> Bool) -> [a] -> Bool
prop_separa_OK p xs = undefined

----------------------------------------------------------------------
-- Ejercicio - lista de pares
----------------------------------------------------------------------

cotizacion :: [(String, Double)]
cotizacion = [("apple", 116), ("intel", 35), ("google", 824), ("nvidia", 67)]

buscarRec :: (Eq a) => a -> [(a,b)] -> [b]
buscarRec k [] = []
buscarRec k ((k',v):xs)
                        | k==k' = [v]
                        | otherwise = buscarRec k xs


buscarC :: (Eq a) => a -> [(a, b)] -> [b]
buscarC k ((k',v):xs) = take 1 [snd v | v <- ((k',v):xs), k==fst v] -- take 1 para que la tres funciones sean equivalentes

buscarP :: Eq a => a -> [(a, b)] -> [b]
buscarP k = foldr (\(k',v) acc -> if k==k' then [v] else acc) []
{-
Recibe un par (clave,valor) y un acumulador
[] es el primer elemento
Se devuelve el valor de la última coincidencia con la clave
acc es la lista acumuladora, en el momento que una clave coincide con la dada, mete su valor asociado,
pero si la clave aparece dos veces, sustituye el valor anterior.
El problema que le veo a esto, es que pliega hasta el final, no como en recursión, que solo llega al final si la clave no coincidió.
-}

prop_buscar_OK :: (Eq a, Eq b) => a -> [(a, b)] -> Bool
prop_buscar_OK x ys = buscarRec x ys == buscarC x ys

{-

Responde las siguientes preguntas si falla la propiedad anterior.

¿Por qué falla la propiedad prop_buscar_OK?
Porque estábamos suponiendo que no había claves repetidas en la lista.
Cuando las hay, buscarRec da el valor de la primera coincidencia y buscarC daba los valores de todas las coincidencias.

Realiza las modificaciones necesarias para que se verifique la propiedad.
La modificación que se ha hecho ha sido añadir a la buscarC un "take 1", para que sólo devuelva el valor para la primera coincidencia de la clave.
-}
-- valorCartera :: [(String, Double)] -> [(String, Double)] -> Double
valorCartera :: [(String, Double)] -> [(String, Double)] -> Double
valorCartera [] [] = 0
valorCartera [] _ = 0
valorCartera _ [] = 0
-- valorCartera cartera cotizacion
valorCartera ((k,v):xs) cotizacion = (snd(head ((k,v):xs))) * saca(buscarRec (fst (head ((k,v):xs))) cotizacion) + valorCartera xs cotizacion
    where saca (y:ys) = y
          saca [] = 0

valorCartera' :: [(String, Double)] -> [(String, Double)] -> Double
valorCartera' cartera cotizacion = undefined

----------------------------------------------------------------------
-- Ejercicio - mezcla
----------------------------------------------------------------------

mezcla :: Ord a => [a] -> [a] -> [a]
mezcla xs [] = xs
mezcla xs (y:ys) | (y:ys) == [] = zs
                 | otherwise = mezcla zs ys
            where zs = takeWhile (<y) xs ++ [y] ++ dropWhile (<y) xs

----------------------------------------------------------------------
-- Ejercicio - takeUntil
----------------------------------------------------------------------

takeUntil :: (a -> Bool) -> [a] -> [a]
takeUntil p (x:xs)  | p x = []
                    | otherwise = x : takeUntil p xs

prop_takeUntilOK :: Eq a => (a -> Bool) -> [a] -> Bool
prop_takeUntilOK p xs = undefined

----------------------------------------------------------------------
-- Ejercicio - número feliz
----------------------------------------------------------------------

digitosDe :: Integer -> [Integer]
digitosDe x = reverse (digitosDe' x)
  where digitosDe' n | n < 10 = [n]
                     | otherwise =  (n `mod` 10) : digitosDe' (n `div` 10)

-- Otra forma de hacerlo: función auxiliar y usando lista vacía
digitos :: Integer -> [Integer]
digitos n = reverse (digitos' n [])
    where digitos' n xs | n < 10 = [n]
                        | otherwise = (mod n 10) : digitos' (div n 10) xs

sumaCuadradosDigitos :: Integer -> Integer
sumaCuadradosDigitos x = sum [x^2 | x <- digitosDe x]

sumaCuadradosDigitos' :: Integer -> Integer
sumaCuadradosDigitos' x = (.) sum digitosDe x

esFeliz :: Integer -> Bool
esFeliz x | x<0 = error "Número negativo."
          | otherwise = esFelizAc x []
  where esFelizAc x xs | sumaCuadradosDigitos x == 1 = True
                       | elem (sumaCuadradosDigitos x) xs = False
                       | otherwise = esFelizAc (sumaCuadradosDigitos x) ((sumaCuadradosDigitos x):xs)

felicesHasta :: Integer -> [Integer]
felicesHasta x = [x | x <- [1..x], esFeliz x]

felicesHasta' x = length [x | x <- [1..x], esFeliz x]

{-

Responde a la siguiente pregunta.

¿Cuántos números felices hay menores o iguales que 1000?
143
-}

----------------------------------------------------------------------
-- Ejercicio - borrar
----------------------------------------------------------------------

borrarRec :: Eq a => a -> [a] -> [a]
borrarRec x ys = undefined

borrarC :: Eq a => a -> [a] -> [a]
borrarC x ys = undefined

borrarP :: Eq a => a -> [a] -> [a]
borrarP x ys = undefined

prop_borrar_OK :: Eq a => a -> [a] -> Bool
prop_borrar_OK x ys = undefined

----------------------------------------------------------------------
-- Ejercicio - agrupar
----------------------------------------------------------------------
-- A cada par de elementos le aplico la función y el primer elemento es []
agrupar :: Eq a => [a] -> [[a]]
agrupar = foldr func [] -- función y primer elemento (lista vacía) (la 2ª lista argumento puede no ponerse, mirar función multiplicar)
-- OJO: Esto también es correcto --> agrupar xs = foldr func [] xs
    where func x []     = [[x]] -- func recibe un char y una lista (caso base) --> Prelude> ('a':[]):[] == ["a"]
          func x (y:xs) = -- y es la primera lista  de caracteres, xs es el resto de listas de caracteres. () indica que están a su vez dentro de una lista
              if x == (head y) then ((x:y):xs) else ([x]:y:xs)  -- pregunto si el nuevo char es igual a la cabeza del String: head "i" == 'i'
-- head y == head (head (y:xs))

multiplicar :: [Integer] -> Integer
multiplicar = foldr (*) 1

{- Recordar también esto: la función toma 2 enteros y devuelve su suma entre 2
Prelude> foldr (\x y -> (x+y)/2) 54 [12, 4, 10, 6]
12.0
https://stackoverflow.com/questions/1757740/how-does-foldr-work
-}

{-
Prelude> map (map (^2)) [[1,2],[3,4,5,6],[7,8]]
[[1,4],[9,16,25,36],[49,64]]
Prelude> map(map (map (^2))) [[[3],[34]],[[3,4,5,6]],[[7,8]]]
[[[9],[1156]],[[9,16,25,36]],[[49,64]]]
-}
----------------------------------------------------------------------
-- Ejercicio - aplica
----------------------------------------------------------------------

aplicaRec :: a -> [ a -> b] -> [b]
aplicaRec x fs = undefined

aplicaC :: a -> [ a -> b] -> [b]
aplicaC x fs = undefined

aplicaP :: a -> [ a -> b] -> [b]
aplicaP x fs = undefined

aplicaM :: a -> [ a -> b] -> [b]
aplicaM x fs = undefined

prop_aplica_OK :: Eq b => a -> [a -> b] -> Bool
prop_aplica_OK x fs = undefined

-- Author: Salvador CF
-- Relación de ejercicios 2.

import Test.QuickCheck
import Data.List
import Numeric -- showFFloat

--------------------------------------------------------------------------------
-- Ejercicio 1
--------------------------------------------------------------------------------
data Direction = North | South | East | West deriving (Eq, Enum, Show)

-- a)
(<<) :: Direction -> Direction -> Bool
(<<) dir1 dir2 = (fromEnum dir1) < (fromEnum dir2)

p_menor x y = (x < y) == (x << y)
instance Arbitrary Direction where
  arbitrary = do
    n <- choose (0, 3)
    return $ toEnum n

-- b)
instance Ord Direction where
    North <= _      = (North << South) && (North << East) && (North << West)
    South <= North  = South << North
    South <= _      = True            -- para cualquier otro valor será True (importante el orden)
    East  <= North  = East  << North
    East  <= South  = East  << South
    East  <= _      = True
    West  <= North  = West  << North
    West  <= South  = West  << South
    West  <= East   = West  << East
    West  <= _      = True            -- uso el subrayado porque ya he probado lo demás

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 2
--------------------------------------------------------------------------------

-- Máximo
-- Primera aproximación

máximo1 :: Ord a => [a] -> a
máximo1 []       = error "máximo1: la lista está vacía."
máximo1 [x]      = x
máximo1 (x:y:xs)  | (x > y)   = máximo1 (x:xs)
                  | otherwise = máximo1 (y:xs)

p_máximo1 xs = not (null xs) ==> maximum xs == máximo6 xs  -- (not . null) xs

-- Segunda aproximación

máximo2 :: Ord a => [a] -> a
máximo2 []       = error "máximo2: la lista está vacía."
máximo2 [x]      = x
máximo2 (x:y:xs) = máximo2 ((max x y):xs)

-- Tercera aporximación

máximo3 :: Ord a => [a] -> a
máximo3 []       = error "máximo3: la lista está vacía."
máximo3 [x]      = x
máximo3 (x:y:xs) = max x (máximo3 (y:xs))

-- Cuarta aproximación

máximo4 :: Ord a => [a] -> a
máximo4 []      = error "máximo4: la lista está vacía."
máximo4 [x]     = x
máximo4 (x:xs)  = max x (máximo4 xs)

-- Quinta aproximación
-- Funciones predefinidas Prelude: https://www.haskell.org/onlinereport/standard-prelude.html

máximo5 :: Ord a => [a] -> a
máximo5 []      = error "máximo6: la lista está vacía."
máximo5 (x:xs)  = foldr max x xs

-- Sexta aproximación
{-
foldr1 :: (a -> a -> a) -> [a] -> a
foldr1 _ [x] = x
foldr1 f (x:xs) = f x (foldr1 f xs)
-}

máximo6 :: Ord a => [a] -> a
máximo6 = foldr1 max          -- máximo6 xs = foldr1 max xs (parcialización, n-reducción, página 53)

-- Resto
-- Primera aporximación: devuelve la lista xs tras extraer el elemento e
resto :: Ord a => a -> [a] -> [a]
resto e xs = filter (/= e) xs

-- a)
máximoYresto :: Ord a => [a] -> (a,[a])
máximoYresto xs = aux xs []
                        where
                          aux [x] r = (x, r)
                          aux (x:y:xs) r  | (y > x)   = aux (y:xs) (x:r)
                                          | otherwise = aux (x:xs) (y:r)

-- b)
máximoYresto' :: Ord a => [a] -> (a, [a])
máximoYresto' xs = (mayor, resto mayor xs)
                      where mayor = máximo6 xs

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 3
--------------------------------------------------------------------------------
-- Primera aproximación
reparte1 :: [a] -> ([a],[a])
reparte1 xs = ( [ xs !! i | i <- [0,2..n] ], [ xs !! i | i <- [1,3..n] ] )
    where n = length xs - 1

-- Segunda aproximación
reparte2 :: [a] -> ([a],[a])
reparte2 [] = ([], [])
reparte2 [x] = ([x],[])
reparte2 (x:y:zs) = ( x:s1, y:s2 )
  where (s1, s2) = reparte2 zs

-- Tercera aproximación
reparte3 :: [a] -> ([a],[a])
reparte3 [] = ([],[])
reparte3 (x : xs) = (x : y1, y2)
  where
    (y2, y1) = reparte3 xs

-- Cuarta aproximación
reparte4 :: [a] -> ([a],[a])
reparte4 = foldr (\x ~(y2,y1) -> (x:y1, y2)) ([],[]) -- n reducción: reparte4 xs = foldr (\x ~(y2,y1) -> (x:y1, y2)) ([],[]) xs
{-
El ~ hace que la unificación del patrón sea perezosa, reparte4 produce resultados a demanda, no tiene que mirar toda la lista primero.
Al usar ~, se asume que el patrón siempre unifica: https://en.wikibooks.org/wiki/Haskell/Laziness#Lazy_pattern_matching
La unificación se hace a posteriori, si el valor de la variable unificada finalmente se usa. También funciona sin el ~.

En la siguiente función, si ponemos prueba [], nos devuelve el 23, aunque el patrón realmente no unifique.

    prueba :: [Integer] -> Integer
    prueba ~(x:xs) = 23
-}

-- Quinta aproximación
-- El operador predefinido $puede ser usado para evitar el uso de paréntesis debido a su baja prioridad (página 66)
reparte5 :: [a] -> ([a],[a])
reparte5 xs = (reparte5 xs, reparte5 . drop 1 $ xs) -- reparte5 xs = (reparte5 xs, (reparte5 . drop 1) xs)
  where
    reparte5 [] = []
    reparte5 [x] = [x]
    reparte5 (x:_:xs') = x : reparte5 xs'

{-
Se ejecutan las internas (si no fuera así, el programa se colgaría)
    prueba :: Integer -> Integer
    prueba x = prueba x
      where prueba x = prueba x
              where prueba x = 234

Lo menos lioso sería hacer esto:
    reparte5 :: [a] -> ([a],[a])
    reparte5 xs = (reparte5' xs, reparte5' . drop 1 $ xs) -- reparte5 xs = (reparte5 xs, (reparte5 . drop 1) xs)
      where
        reparte5' [] = []
        reparte5' [x] = [x]
        reparte5' (x:_:xs') = x : reparte5' xs'
-}

-- Sexta aproximación
reparte6 :: [a] -> ([a],[a])
reparte6 xs = let (a,b) = partition (odd . snd) (zip xs [1..])
              in ( (map fst a), (map fst b) )

-- Séptima aproximación
reparte7 :: [a] -> ([a],[a])
reparte7 xs = ( (map fst a), (map fst b) )
      where (a,b) = partition (odd . snd) (zip xs [1..])

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 4
--------------------------------------------------------------------------------
-- Primera aproximación
distintos1 :: Eq a => [a] -> Bool
distintos1 xs | (xs == nub xs)  = True
              | otherwise       = False

-- Segunda aproximación
distintos2 :: (Eq a) => [a] -> Bool
distintos2 []     = True
distintos2 (x:xs) = x `notElem` xs && distintos2 xs

-- Tercera aproximación
distintos3 :: (Eq a) => [a] -> Bool
distintos3 [] = True
distintos3 (x:xs) = and [ x /= y | y <- xs ] && distintos3 xs

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 5
--------------------------------------------------------------------------------
-- a)
-- Solución 1
replicate' :: Int -> a -> [a]
replicate' n x = [ x | y <- [1..n] ]

-- Solución 2
replicate'2 :: Int -> a -> [a]
replicate'2 n x = unfoldr (\b -> if b < 1 then Nothing else Just (x, b-1)) n

-- b)
p_replicate' n x = n >= 0 && n <= 1000 ==>  length (filter (==x) xs) == n
                                            && length (filter (/=x) xs) == 0
                                              where xs = replicate' n x
{-
  Para todo (0 <= n <= 1000), se cumple que:  el tamaño de la lista que surge de filtrar los elementos de xs iguales a x es n
                                              el tamaño de la lista que surge de filtrar los elementos de xs iguales a x es 0
                                                donde la lista xs es aquella en la que aparece x n veces.
-}

-- c)
{-
*Main Data.List> quickCheck p_replicate'
+++ OK, passed 100 tests.
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 6
--------------------------------------------------------------------------------
divideA :: Integer -> Integer -> Bool
divideA x y = (y `mod` x == 0)

divisores :: Integer -> [Integer]
divisores n = [ x | x <- [1..n], x `divideA` n ]

divisores' :: Integer -> [Integer]
divisores' n = [ x | x <- [-n..n] \\ [0], x `divideA` n ]

-- Otra solución
divisores'2 :: Integer -> [Integer]
divisores'2 n = negativos ++ divisores n
  where negativos = [ (-x) | x <- divisores n ]

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 7
--------------------------------------------------------------------------------
-- a)
-- Solución 1
mcd :: Integer -> Integer -> Integer
mcd x y = maximum [ z | z <- intersect (divisores (abs x)) (divisores (abs y)) ]

-- Solución 2
mcd2 :: Integer -> Integer -> Integer
mcd2 x y = maximum [ z | z <- divisores (abs x), (z `divideA` y) ]

-- Solución 3
mcd3 :: Integer -> Integer -> Integer
mcd3 x y = maximum [ z | z <- divisores (abs x), z `elem` divisores (abs y) ]

-- Solución 4: Algoritmo de Euclides
mcd_euclides :: Integer -> Integer -> Integer
mcd_euclides x 0 = abs x
mcd_euclides x y = mcd_euclides y (x `mod` y)

p_mcd :: Integer -> Integer -> Property
p_mcd x y = (x /= 0 && y /= 0) ==> mcd x y == mcd2 x y && mcd2 x y == mcd3 x y && mcd3 x y == mcd_euclides x y

{-
*Main Data.List> quickCheck p_mcd
+++ OK, passed 100 tests.
-}

-- b)
p_mcd2 :: Integer -> Integer -> Integer -> Property
p_mcd2 x y z = (x /= 0) && (y /= 0) && (z /= 0) ==> mcd (z*x) (z*y) == abs z * mcd x y

{-
*Main Data.List> quickCheck p_mcd2
+++ OK, passed 100 tests.
-}

-- c)
mcm :: Integer -> Integer -> Integer
mcm x y = div (x * y) (mcd x y)

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 8
--------------------------------------------------------------------------------
-- Solución 1
esPrimo1 :: Integer -> Bool
esPrimo1 n = length (divisores n) == 2

-- Solución 2
esPrimo2 :: Integer -> Bool
esPrimo2 x  | x < 0     = error "esPrimo2: Argumento negativo"
            | x <= 1    = False
            | otherwise = esPrimo2' x 2
    where esPrimo2' x i | x `mod` i == 0 && x /=i = False
                        | x == i                  = True
                        | otherwise               = esPrimo2' x (i+1)

-- Solución 3
-- Si n es compuesto, existe un divisor primo p tal que p <= sqrt(n).
-- Un entero es primo si no es divisible por ningún primo menor o igual que su raíz cuadrada.
esPrimo3 :: Integer -> Bool
esPrimo3 x  | x <= 0    = error "esPrimo3: Argumento negativo o cero."
            | x == 1    = False
            | otherwise = esPrimo3' x 2
  where esPrimo3' x i | (x `mod` i == 0) && (i /= x)        = False -- compuesto
                      | (i > floor(sqrt (fromIntegral x)))  = True  -- primo
                      | otherwise                           = esPrimo3' x (i+1)

-- Solución 4
esPrimo4 :: Integer -> Bool
esPrimo4 n = length [ x | x <- [1..n], (n `mod` x == 0) ] == 2

-- Solución 5
esPrimo5 :: Integer -> Bool
esPrimo5 n  | (n < 2)     = False
            | otherwise = null [ x | x <- [2..(floor . sqrt . fromIntegral) n], (n `mod` x == 0)] --null: (list is empty, length == 0)

-- b)
primosHasta :: Integer -> [Integer]
primosHasta n = [x | x <- [2..n], esPrimo5 x]

-- c)
primosHasta' :: Integer -> [Integer]
primosHasta' n = filter esPrimo5 [2..n]

-- d)
p1_primos :: Integer -> Property
p1_primos n = True ==> primosHasta n == primosHasta' n

{-
*Main> quickCheck p1_primos
+++ OK, passed 100 tests.
-}

-- Extra: Criba de Eratóstenes
criba :: [Integer] -> [Integer]
criba (p:xs) = [x | x <- xs, p `noDivideA` x]
  where m `noDivideA` n = (mod n m /= 0)

primos :: [Integer]
primos = map head (iterate criba [2..])

{-
*Main> take 30 primos
[2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113]
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 9
--------------------------------------------------------------------------------
--  a) Consejo: usar Hoogle usando la signatura de la función
pares :: Integer -> [(Integer, Integer)]
pares n = [ (x, y) | x <- primosHasta n, y <- primosHasta n, (x + y == n) && (x <= y)]

-- b)
goldbach :: Integer -> Bool
goldbach n = (n > 2) && (even n) && (not . null) (pares n)

-- c)
goldbachHasta :: Integer -> Bool
goldbachHasta n = and [ goldbach x | x <- [4..n], even x ] -- sólo le aplico goldbach a los que son pares

-- d)
goldbachDébilHasta :: Integer -> [Bool]
goldbachDébilHasta n =  [ goldbach(x-3) | x <- [7..n], odd x]

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 10
--------------------------------------------------------------------------------
-- Solución 1
esPerfecto1 :: Integer -> Bool
esPerfecto1 n = (n == (sum . divisores)n - n)

-- Solución 2
esPerfecto2 :: Integer -> Bool
esPerfecto2 n = (n == (sum . init . divisores) n)

-- Solución 3
esPerfecto3 :: Integer -> Bool
esPerfecto3 n = (n == (sum . divisoresProp) n)
  where divisoresProp n = [ x | x <- [1..n-1], x `divideA` n ]

-- Solución 4
esPerfecto4 :: Integer -> Bool
esPerfecto4 n = n == sum [i | i <- [1..n-1], n `mod` i == 0]

-- Solución 5
esPerfecto5 :: Integer -> Bool
esPerfecto5 n = (n == (foldr (+) 0 . divisoresProp) n)
  where divisoresProp n = [ x | x <- [1..div n 2], x `divideA` n ]

-- Solución 6
esPerfecto6 :: Integer -> Bool
esPerfecto6 n = n == sum [i | i <- [1..techo], i `divideA` n]
  where techo = div n ((minimum . tail . divisores) n)

--prop_divisors n = (n>1) ==> (maximum . init . divisores) n == div n ((minimum . tail . divisores) n)
-- https://math.stackexchange.com/questions/445715/find-the-largest-divisor-of-an-integer-b

-- b)
perfectosMenoresQue :: Integer -> [Integer]
perfectosMenoresQue n = [ x | x <- [1..n], esPerfecto1 x]

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 11
--------------------------------------------------------------------------------
-- a)
take' :: Int -> [a] -> [a]
take' n xs = [ x | (p, x) <- zip [0..n-1] xs]

-- b)
drop' :: Int -> [a] -> [a]
drop' n xs = [ x | (p, x) <- zip [0..length xs] xs, (p >= n) ]

-- c)
prop_takedrop :: Eq a => Int -> [a] -> Property
prop_takedrop n xs = (n >= 0) ==> (take' n xs ++ drop' n xs) == xs

{-
*Main> quickCheck prop_takedrop
+++ OK, passed 100 tests.
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 12
--------------------------------------------------------------------------------
-- a)
concat' :: [[a]] ->[a]
concat' xs = foldr (++) [] xs

-- b)
concat'' :: [[a]] -> [a]
concat'' xs = [ y | x <- xs, y <- x ]

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 13
--------------------------------------------------------------------------------
desconocida :: (Ord a) => [a] -> Bool
desconocida xs = and [ (x <= y) | (x, y) <- zip xs (tail xs) ]

{-
Toma una lista de elementos que pueden ordenarse y devuelve un booleano.
El booleano resultado surge de comprobar si x <= y en las 2-tuplas obtenidas.
zip recibe dos listas y empareja los elementos formando 2-tuplas.
Si alguna lista tiene más elementos que otra, estos son descartados.
zip son la lista argumento y la lista argumento sin el primer elemento (tail)
La función devuelve True si cada elemento es menor o igual al de la siguiente posición.
Es decir, devuelve True si la lista argumento está ordenada.
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 14
--------------------------------------------------------------------------------
-- a)
inserta :: (Ord a) => a -> [a] -> [a]
inserta e xs = takeWhile (<e) xs ++ [e] ++ dropWhile (<e) xs

-- b)
inserta' :: (Ord a) => a -> [a] -> [a]
inserta' e [] = [e]
inserta' e (x:xs)  | (e < x) = e : (x:xs)
                    | otherwise = x : (inserta' e xs)

-- c)
p1_inserta :: (Ord a) => a -> [a] -> Property
p1_inserta x xs = desconocida xs ==> desconocida (inserta x xs)

{-
Si la lista argumento está ordenada, también lo estará al inserta un elemento mediante la función "inserta"

*Main> quickCheck p1_inserta
+++ OK, passed 100 tests.
-}

-- d)
{-
El algoritmo funciona porque la lista argumento siempre estará ordenada.
Empieza estando vacía e inserto el primer el elemento.
Inserto el segundo manteniendo el orden, y así sucesivamente.
La clave está en que la inserción del nuevo elemento se hace sobre una lista ordenada.
-}

-- e)
ordena :: (Ord a) => [a] -> [a]
ordena xs = foldr (inserta) [] xs

-- f)
p_ordena :: (Ord a) => [a] -> Property
p_ordena xs = True ==> desconocida(ordena xs)

{-
*Main> quickCheck p_ordena
+++ OK, passed 100 tests.
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 15
--------------------------------------------------------------------------------
-- a)
geométrica :: Integer -> Integer -> [Integer]
geométrica x r = iterate (*r) x

-- b)
p1_geométrica x r = x > 0 && r > 0 ==> and [ div z y == r | (y, z) <- zip xs (tail xs) ]
                                            where xs = take 100 (geométrica x r)

{-
Si el valor inicial y la razón de la secuencia son mayores que 0, entonces
la conjunción de los booleanos generados por comprensión será True.
zip xs (tail xs) genera 2-tuplas de cada elemento con su siguiente.
Se comprueba que en cada 2-tupla, el primer miembro divida al segundo, dando
como resultado la razón de secuencia, algo totalmente razonable sabiendo que
si tenemos geométrica x r, los elementos la lista serán [x, x*r, (x*r)*r, ...].
Como tenemos (y, z), siendo z = y*r, entonces r = z `div` y
-}

-- c)
múltiplosDe :: Integer -> [Integer]
múltiplosDe n = iterate (+n) 0

-- d)
potenciasDe :: Integer -> [Integer]
potenciasDe n = iterate (*n) 1

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 16
--------------------------------------------------------------------------------
-- a) Definida en 15 c)

-- b)
primeroComún :: Ord a => [a] -> [a] -> a
primeroComún [] _ = error "primeroComún: no hay elementos comunes"
primeroComún _ [] = error "primeroComún: no hay elementos comunes"
primeroComún (x:xs) (y:ys)  | (x == y)  = x
                            | (x < y)   = primeroComún xs (y:ys)
                            | otherwise = primeroComún (x:xs) ys

-- c)
mcm' :: Integer -> Integer -> Integer
mcm' _ 0 = 0
mcm' x y = primeroComún ((tail . múltiplosDe) x) ((múltiplosDe) y)

-- d)
p_mcm :: Integer -> Integer -> Property
p_mcm x y = (x >= 0) && (y >= 0) ==> mcm' x y == lcm x y

{-
*Main> quickCheck p_mcm
+++ OK, passed 100 tests.
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 17
--------------------------------------------------------------------------------
primeroComúnDeTres :: Ord a => [a] -> [a] -> [a] -> a
primeroComúnDeTres (x:xs) (y:ys) (z:zs) | (x > y)   = primeroComúnDeTres (x:xs) ys (z:zs)
                                        | (x > z)   = primeroComúnDeTres (x:xs) (y:ys) zs
                                        | (y > x)   = primeroComúnDeTres xs (y:ys) (z:zs)
                                        | (y > z)   = primeroComúnDeTres (x:xs) (y:ys) zs
                                        | (z > x)   = primeroComúnDeTres (x:xs) ys (z:zs)
                                        | (z > y)   = primeroComúnDeTres xs (y:ys) (z:zs)
                                        | otherwise = x

prop_pc3 :: Integer -> Integer -> Integer -> Property
prop_pc3 x y z = (x > 0) && (y > 0) && (z > 0) ==>
                          primeroComúnDeTres ((tail . múltiplosDe) x) ((tail . múltiplosDe) y) ((tail . múltiplosDe) z)
                          == lcm (lcm x y) z

{-
*Main> quickCheck prop_pc3
+++ OK, passed 100 tests.
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 18
--------------------------------------------------------------------------------
factPrimos :: Integer -> [Integer]
factPrimos x = fp x 2
  where
    fp x d
      | x' < d  = [x]
      | r == 0  = d : fp x' d
      | otherwise = fp x (d+1)
        where (x', r)  = divMod x d -- cociente y resto

-- a)
{-
factPrimos 220
=> {definición de factPrimos}
fp 220 2
=> {definición de fp, 2ª guarda, < x' = 110, r = 0, x = 220, d = 2}
2 : fp 110 2
=> {definición de fp, 2ª guarda, < x' = 55, r = 0, x = 110, d = 2}
2 : 2 : fp 55 2
=> {definición de fp, 3ª guarda, < x' = 27, r = 1, x = 55, d = 2}
2 : 2 : fp 55 3
=> {definición de fp, 3ª guarda, < x' = 18, r = 1, x = 55, d = 3}
2 : 2 : fp 55 4
=> {definición de fp, 3ª guarda, < x' = 13, r = 3, x = 55, d = 4}
2 : 2 : fp 55 5
=> {definición de fp, 2ª guarda, < x' = 11, r = 0, x = 55, d = 5}
2 : 2 : 5 : fp 11 5
=> {definición de fp, 1ª guarda, < x' = 2, r = 1, x = 11, d = 5}
2 : 2 : 5 : [11]
=> {sintaxis de listas}
[2,2,5,11]
-}

-- b)
{-
Todos son primos porque primero intento dividir el número entre 2 todas las veces posibles.
Cuando ya no admite más divisiones entre 2, paso al siguiente, el 3 y hago lo mismo.
Llegaré al 4 y sé que el resto no será 0, porque ya agoté todas las divisiones entre 2.
Si el número fuera divisible entre 4, también lo es entre 2, puesto que 4 = 2*2,
pero ya sé que no puedo dividir más entre 2...
Debido a que todo número compuesto se puede expresar como producto de números primos,
este algoritmo asegura que ya se ha probado a dividir entre números primos anteriores,
con lo que no es posible que sea divisible por ningún número producto de esos primos y
no se añadirá a la lista.

Al dar un cociente menor que el divisor d, nos indica que ese cociente no va a ser divisible
por ningún d siguiente (un número no será divisible por ningún número mayor), sólo por el propio x.
Estoy probando con un divisor y el máximo cociente que me va a dar es menor que ese divisor.
Ni ese divisor ni sucesivos lo dividirá.
Deduciendo que x es primo y terminando.
Por ejemplo:
*Main> div 23 5
4
5 no va a dividir a div 23 5, por tanto, no tiene sentido seguir incrementando d hasta llegar a 23.
-}

-- c)
factPrimos' :: Integer -> [Integer]
factPrimos' x = fp' x 2
  where
    fp' x d
      | x' < d    = [x]
      | r == 0    = d : fp' x' d
      | (d /= 2)  = fp' x (d+2)
      | otherwise = fp' x (d+1)
      where (x', r)  = divMod x d

prop_fp n = True ==> factPrimos n == factPrimos' n

-- d)
prop_fact :: Integer -> Property
prop_fact n = (n >= 0) ==> n == (product . factPrimos) n

{-
*Main> quickCheck prop_fact
+++ OK, passed 100 tests.
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 19
--------------------------------------------------------------------------------

-- a)
mezcla :: [Integer] -> [Integer] -> [Integer]
mezcla [] ys = ys
mezcla xs [] = xs
mezcla (x:xs) (y:ys)  | (x == y)  = x : mezcla xs ys
                      | (x < y)   = x : mezcla xs (y:ys)
                      | otherwise = y : mezcla (x:xs) ys

-- b)
mcm'' :: Integer -> Integer -> Integer
mcm'' x y = product (mezcla (factPrimos x) (factPrimos y))

-- c)
p_mcm'' :: Integer -> Integer -> Property
p_mcm'' x y = (x >= 0) && (y >= 0) ==> mcm'' x y == lcm x y

{-
*Main> quickCheck p_mcm''
+++ OK, passed 100 tests.
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 20
--------------------------------------------------------------------------------
-- a)
mezc' :: [Integer] -> [Integer] -> [Integer]
mezc' [] ys = []
mezc' xs [] = []
mezc' (x:xs) (y:ys) | (x == y)  = x : mezc' xs ys
                    | (x < y)   = mezc' xs (y:ys)
                    | otherwise = mezc' (x:xs) ys

-- b)
mcd'' :: Integer -> Integer -> Integer
mcd'' 0 x = x
mcd'' x 0 = x
mcd'' x y = product (mezc' (factPrimos x) (factPrimos y))

-- c)
p_mcd'' :: Integer -> Integer -> Property
p_mcd'' x y = (x >= 0) && (y >= 0) ==> mcd'' x y == gcd x y

{-
*Main> quickCheck p_mcd''
+++ OK, passed 100 tests.
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 21
--------------------------------------------------------------------------------
-- a)
-- Solución 1
nub'1  :: (Eq a) => [a] -> [a]
nub'1 l                   = nub'' l []
  where
    nub'' [] _          = []
    nub'' (x:xs) ls
        | x `elem` ls   = nub'' xs ls
        | otherwise     = x : nub'' xs (x:ls)

-- Solución 2
nub'2 :: Eq a => [a] -> [a]
nub'2 [] = []
nub'2 (x:xs)  | x `elem` xs = x : nub'2 (filter (/= x) xs) -- (nub' . filter (/= x)) xs
              | otherwise = x : nub'2 xs

-- b)
p_nub' :: Eq a => [a] -> Property
p_nub' xs = True ==> (nub xs == nub'1 xs) && (nub'1 xs == nub'2 xs)

{-
*Main> quickCheck p_nub'
+++ OK, passed 100 tests.
-}

-- c)
p_sinRepes :: Eq a => [a] -> Property
p_sinRepes xs = True ==> distintos1 (nub'1 xs)

{-
Es incompleta porque no garantiza que se respete la posición de la primera aparición.
Por ejemplo, si nub [1, 1, 2, 3, 4, 2, 3] -> [1, 4, 2, 3], distintos daría True,
pero nub no sería correcto ya que debería haber dado [1, 2, 3, 4].
Además, si nub añadiera elementos distintos a los de la lista original, también
se daría como buena.
Por ejemplo, si nub [1, 1, 2, 3, 4, 2] -> [1, 2, 3, 4, 5, 6], distintos daría True.
-}

-- d)
todosEn :: (Eq a) => [a] -> [a] -> Bool
ys `todosEn` xs = all (`elem` xs) ys  -- comprueba si ys es subconjunto de xs

p_sinRepes' :: (Eq a) => [a] -> Property
p_sinRepes' xs = True ==> distintos1 (nub'1 xs) && xs `todosEn` nub'1 xs

{-
*Main> quickCheck p_sinRepes'
+++ OK, passed 100 tests.
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 22
--------------------------------------------------------------------------------
-- a)
binarios :: Integer -> [[Char]]
binarios 0 = [[]]
binarios n = map ('0' :) (binarios (n-1)) ++ map ('1' :) (binarios (n-1))

-- Otra solución
binarios' :: Integer -> [[Char]]
binarios' 0 = [[]]
binarios' n = [ x : xs | x <- "0, 1", xs <- binarios (n-1) ]

-- b)
p_binarios n = n>=0 && n<=10 ==>
                    long xss== 2^n
                    && distintos1 xss
                    && all (`todosEn` "01") xss
      where xss = binarios n

long :: [a] -> Integer
long xs = fromIntegral (length xs)

{-
El tamaño de las cadenas no es mayor que 10.
La longitud de la lista para una entrada n debe ser 2^n.
Todas las cadenas deben ser distintas.
Todas las cadenas son subconjuntos del conjunto "01", ya que solo están
formadas por 0's y 1's.

*Main> quickCheck p_binarios
+++ OK, passed 100 tests.
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 23
--------------------------------------------------------------------------------
-- a)
varRep :: (Ord a) => Integer -> [a] -> [[a]]
varRep 0 _ = [[]]
varRep n xs = [ x : ys | x <- xs, ys <- varRep (n-1) xs ]

-- b)
p_varRep m xs = m>=0 && m<=5 && n<=5 && distintos1 xs ==>
                    long vss == n^m
                    && distintos1 vss
                    && all (`todosEn` xs) vss
          where vss = varRep m xs
                n   = long xs

{-
Precondinciones: 0 <= m <= 5, longitud <= 5 y todos los elementos de la lista distintos.
Postcondiciones: El número de variaciones debe ser n^m.
Todas esas variaciones deben ser distintas.
Todos los elementos de vss están en xs.
-}

-- c)
{-
*Main> length (varRep 5 ".-")
32
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 24
--------------------------------------------------------------------------------
-- a)
var :: (Ord a) => Integer -> [a] -> [[a]]
var 0 _ = [[]]
var m xs = [ x : ys | x <- xs, ys <- var (m-1) xs, x `notElem` ys ]

-- b)
p_var m xs = n<=5 && distintos1 xs && m>=0 && m<=n ==>
              long vss == fact n `div` fact (n-m)
              && distintos1 vss
              && all distintos1 vss
              && all (`todosEn` xs) vss
      where
        vss = var m xs
        n = long xs

fact :: Integer -> Integer
fact x = product [1..x]

{-
Precondinciones: tamaño lista elementos distintos <= 5, 0 <= m <= 5
Postcondiciones: longitud de la lista con las variaciones == n! / (n-m)!
Todas las variaciones son distintas. ["abc", "acb", ... ] -> "abc" /= "acb"
Todos los elementos de cada variación son distintos (no hay repeticiones).
Aplico distintos1 a todos los elementos de vss y veo si todos dan True.
Todos los elementos de cada variación de vss están en xs: "ab", ['a', 'b'], 'a' <- "abc" y 'b' <- "abc".
"ab" `todosEn` "abc", "ac" `todosEn` "abc", ...
-}

-- c)
-- var 3 [1..9]

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 25
--------------------------------------------------------------------------------
-- a)
intercala :: a -> [a] -> [[a]]
intercala x [] = [[x]]
intercala x (y:ys) = (x:y:ys) : [ y:zs | zs <- intercala x ys ]

-- b)
perm :: [a] -> [[a]]
perm [] = [[]]
perm (x:xs) = [ zs | ys <- perm xs, zs <- intercala x ys ]

-- Otra solución
perm2 :: [a] -> [[a]]
perm2 [] = [[]]
perm2 (x:xs) = concat [ intercala x ys | ys <- perm2 xs ]

-- c)
p_perm xs = n<8 && distintos1 xs ==>
                long pss == fact n
                && distintos1 pss
                && all (`esPermutaciónDe` xs) pss
  where
    n = long xs
    pss = perm xs

esPermutaciónDe :: (Eq a) => [a] -> [a] -> Bool
xs `esPermutaciónDe` ys = null (xs \\ ys) && null (ys \\ xs)

{-
Precondiciones: lista menos de 8 elementos distintos
Postcondiciones:  el número de permutaciones posibles es n!
                  todas las permutaciones son distintas
                  todos los elementos de pss son realmente permutaciones de xs
                  xs es permutación de ys si no hay elementos que estén en xs y
                    no en ys, ni tampoco hay elementos en ys que estén en xs.

*Main> quickCheck p_perm
*** Gave up! Passed only 65 tests.
-}

-- d)
-- *Main> perm [1..5]

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 26
--------------------------------------------------------------------------------
-- a)
comb :: Integer -> [a] -> [[a]]
comb 0 _ = [[]]
comb _ [] = []
comb m (x:xs) =  (comb m xs) ++ [ x : ys | ys <- comb (m-1) xs ]

-- b)
p_comb m xs = m>=0 && n<13 && n>=m && distintos1 xs ==>
                long css == fact n `div` (fact m * fact (n-m))
                && and [ long cs == m | cs <- css ]
                && diferentes css
                && all (`todosEn` xs) css
                && all distintos1 css
    where
      n = long xs
      css = comb m xs

diferentes :: (Eq a) => [[a]] -> Bool
diferentes [] = True
diferentes (xs:xss) = all (=/= xs) xss && diferentes xss
  where xs =/= ys = not (xs `esPermutaciónDe` ys)

{-
Precondiciones: conjuntos de m elementos donde m<=n y n es la longitud de la lista inicial.
                todos los elementos deben ser distintos y no puede haber más de 12.
Postcondiciones:  el número de combinaciones deber ser n! / m!(n-m)!
                  la longitud de todas esas combinaciones debe ser m
                  todas las combinaciones deben ser diferentes
                  todos los elementos de cada combinación están en la lista inicial
                  todos las combinaciones son distintas

*Main> quickCheck p_comb
*** Gave up! Passed only 13 tests.
-}

-- c)
{-
*Main> length (comb 4 [1..7])
35
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 27
--------------------------------------------------------------------------------
-- a)
esPrefijoDe :: [Char] -> [Char] -> Bool
esPrefijoDe [] _ = True
esPrefijoDe _ [] = False
esPrefijoDe (x:xs) (y:ys) = (x == y) && esPrefijoDe xs ys

-- b)
búsquedas :: String -> String -> [Int]
búsquedas xs ys = búsquedas' xs ys 0
  where
    búsquedas' xs [] n = []
    búsquedas' xs (y:ys) n  | esPrefijoDe xs (y:ys) = n : búsquedas' xs ys (n+1)
                            | otherwise             = búsquedas' xs ys (n+1)

-- Otra solución
búsquedas2 :: String -> String -> [Int]
búsquedas2 xs ys = [ length ys - length zs | zs <- cads, xs `esPrefijoDe` zs ]
  where cads = take (length ys) (iterate (drop 1) ys)

-- Otra solución
búsquedas3 :: String -> String -> [Int]
búsquedas3 xs ys = findIndices (== True) [ xs `esPrefijoDe` zs | zs <- cads ]
  where cads = take (length ys) (iterate (drop 1) ys)

p_búsquedas xs ys = True ==> (búsquedas xs ys == búsquedas2 xs ys) && (búsquedas2 xs ys == búsquedas3 xs ys)

{-
*Main> quickCheck p_búsquedas
+++ OK, passed 100 tests.
-}

-- c)
distancia :: String -> String -> Int
distancia [] ys = length ys
distancia xs [] = length xs
distancia (x:xs) (y:ys) | (x /= y)  = 1 + distancia xs ys
                        | otherwise = distancia xs ys

-- Otra solución
distancia' :: String -> String -> Int
distancia' xs ys = (length . filter (== True)) [ (x /= y) | (x, y) <- zip xs ys ] + abs (length xs - length ys)

p_distancia xs ys = True ==> distancia xs ys == distancia' xs ys

{-
*Main> quickCheck p_distancia
+++ OK, passed 100 tests.
-}

-- d)
parecidas :: Int -> String -> String -> [Int]
parecidas n xs ys = parecidas' n xs ys 0
  where
    parecidas' n xs [] m = []
    parecidas' n xs s@(y:ys) m  | distancia xs sub <= n = m : parecidas' n xs ys (m+1)
                                | otherwise                = parecidas' n xs ys (m+1)
                                  where sub = take (length xs) s

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 28
--------------------------------------------------------------------------------
-- a)
inteDef :: (Double -> Double) -> Double -> Double -> Double -> Double
inteDef f a b ep  | (b - a) <= ep  = (b - a) * (f a + f b) / 2
                  | otherwise           = (inteDef f a m ep) + (inteDef f m b ep)
  where m = (b + a) / 2 -- ((b - a) / 2) + a

-- b)
inteDef' :: (Double -> Double) -> Double -> Double -> Double -> Double
inteDef' f a b n =  ((b - a) / n) * ( ((f a + f b) / 2) + sum [ f (a + k * (b-a)/n) | k <- [1..n-1] ] )

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 29
--------------------------------------------------------------------------------
-- a)
mediana :: [Double] -> Double
mediana xs  | odd t     = sxs !! c
            | otherwise = ((sxs !! c) + (sxs !! (c - 1))) / 2
  where
    t   = length xs
    sxs = sort xs
    c = div t 2

-- b)
p_mediana :: [Double] -> Property
p_mediana xs = True ==> all (<= med) pm && all (>= med) sm
  where med = mediana xs
        sxs = sort xs
        mit = div (length xs) 2
        (pm, sm) = splitAt mit sxs

{-
*Main> quickCheck p_mediana
+++ OK, passed 100 tests.
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 30
--------------------------------------------------------------------------------
-- a)
fibs :: [Integer]
fibs = fibsAux 0 1

-- https://softwareengineering.stackexchange.com/questions/304019/how-does-repeat-x-xrepeat-x-return-a-list-in-haskell
-- página 186 Razonando con Haskell
fibsAux :: Integer -> Integer -> [Integer]
fibsAux p q = p : fibsAux q (p+q)


-- Otra solución
-- https://stackoverflow.com/questions/6273621/understanding-a-recursively-defined-list-fibs-in-terms-of-zipwith
fibs' :: [Integer]
fibs' = 0 : 1 : zipWith (+) fibs (tail fibs)

-- b)
cocientePorMillón :: Integer -> Integer -> Integer
cocientePorMillón a b = div (a * 10^6) b

-- c)
relaciones :: [Integer] -> [Integer]
relaciones (x:y:xs) = cocientePorMillón y x : relaciones xs

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 31
--------------------------------------------------------------------------------
facts :: [Integer]
facts = factsAux 1 1  -- 0!, 1!

factsAux :: Integer -> Integer -> [Integer]
factsAux n p = p : factsAux (n+1) (p*n)

factsAux' :: Integer -> Integer -> [Integer]
factsAux' n p = n : factsAux' (p*n) (p+1)

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 32
--------------------------------------------------------------------------------
type Base = Double;
type Valor = Base;
type Polinomio = [Base];
type Punto = Base

evalPoli :: Polinomio -> Punto -> Valor
evalPoli xs p = sum $ zipWith (\x n -> x*p^n) xs [0..]

-- a)
{-
evalPoli [1, 2, 3] 5
sum $ zipWith (\x n -> x*p^n) [1, 2, 3] [0..]
sum $ zipWith (\x n -> x*p^n) [1, 2, 3] [0, 1, 2] para el emparejamiento, el resto de la lista infinita se desecha
sum $ [1*5^0, 2*5^1, 3*5^2]
sum $ [1, 10, 75]
86
Nota: https://stackoverflow.com/questions/940382/what-is-the-difference-between-dot-and-dollar-sign
-}

-- b)
evalPoli1 :: Polinomio -> Punto -> Valor
evalPoli1 xs p = evalPoli1Aux xs p 1
  where
    evalPoli1Aux [] _ _ = 0
    evalPoli1Aux (x:xs) p pn = x*pn + evalPoli1Aux xs p (pn*p) -- x*p^n + evalPoli1Aux xs p (n+1) menos eficiente, recalcula potencias

p_evalPoli1 xs p = length xs < 6 ==> evalPoli1 xs p ~= evalPoli xs p

infix 4 ~=
(~=) :: Double -> Double -> Bool
x ~= y = abs (x-y) < epsilon
  where epsilon = 1/1000

{-
*Main> quickCheck p_evalPoli1
+++ OK, passed 100 tests.
-}

-- c)
{-
Para un polinomio de grado n, tenemos:
                                      - (n+1) sumas
                                      - 2*(n+1) productos
Con x*p^n + evalPoli1Aux xs p (n+1), el número de sumas no varía, pero
el número de productos pasaría a (n+1) + sum [1..n] = (n+1) + (n*(n+1))/2 productos
-}

-- d)
evalPoli2 :: Polinomio -> Punto -> Valor
evalPoli2 xs p = evalPoli2Aux xs p
  where
    evalPoli2Aux [] _ = 0
    evalPoli2Aux (x:xs) p = x + p*(evalPoli2 xs p)

-- e)
{-
nº productos: (n+1)
nº sumas: (n+1)

evalPoli2 es más eficiente que evalPoli1
-}

-- f)
evalPoli3 :: Polinomio -> Punto -> Valor
evalPoli3 xs p = foldr (\x y -> x + p*y) 0 xs

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 33
--------------------------------------------------------------------------------
-- a)
macLaurinSeno :: Double -> [Double]
macLaurinSeno x = zipWith (/) nums denoms
  where
    nums    = zipWith (^) (cycle [x, -x]) [1,3..]
    denoms  = scanl (*) 1 (zipWith (*) [2, 4..] [3, 5..])

-- b)
aproxSeno :: Int -> Double -> Double
aproxSeno n x = (sum . take n) $ macLaurinSeno x

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 34
--------------------------------------------------------------------------------
bipartición :: (Double -> Double) -> Double -> Double -> Double -> Double
bipartición f a b ep  | (a * b) > 0     = error "bipartición: No hay cambio de signo en el intervalo"
                      | otherwise       = bipartición' f a b ep
  where bipartición' f a b ep | (b - a) <= ep   = c
                              | f c ~= 0        = c
                              | (f a * f c) < 0 = bipartición' f a c ep
                              | otherwise       = bipartición' f c b ep
          where c = (a + b) / 2

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 35 (tipos recursivos: página 78)
--------------------------------------------------------------------------------
data Nat = Cero | Suc Nat deriving (Eq, Ord, Show)

uno, dos, tres :: Nat
uno   = Suc Cero
dos   = Suc (Suc Cero)  -- o también dos = Suc uno
tres  = Suc (Suc (Suc Cero)) -- o también tres = Suc dos

instance Arbitrary Nat where
  arbitrary = do
    n <- choose (0,25) -- genera naturales pequeños
    return $ aNat n

aNat :: Integer -> Nat
aNat 0 = Cero
aNat n | (n > 0) = Suc . aNat $ n-1 -- Suc (aNat (n-1))

-- a)
esPar :: Nat -> Bool
esPar Cero    = True
esPar (Suc n) = not (esPar n) -- not . esPar $ n

-- b)
prop_nat :: Nat -> Property
prop_nat n = True ==> esPar (Suc (Suc n)) == esPar n

{-
*Main> quickCheck prop_nat
+++ OK, passed 100 tests.
-}

-- c)
instance Num Nat where
  Cero + y = y
  Suc x + y = Suc (x + y)
  abs x = x
  signum Cero = Cero
  signum x = 1
  fromInteger x = aNat x
-- e)
  Cero * y = Cero
  Suc x * y = x * y + y
-- g)
{- Otra solución
  x - y | (y > x) = error "Resultado negativo"
        | (x == y) = Cero
        | otherwise = Suc (x - Suc y)
-}
  x - Cero = x
  Suc x - Suc y = x - y
  x - y = error "Resultado negativo"

-- d)
prop_conm :: Nat -> Nat -> Property
prop_conm a b = True ==> a + b == b + a

prop_asoc :: Nat -> Nat -> Nat -> Property
prop_asoc a b c = True ==> a + (b + c) == (a + b) + c

prop_neut :: Nat -> Property
prop_neut n = True ==> n + Cero == n

{-
*Main> quickCheck prop_conm
+++ OK, passed 100 tests.
*Main> quickCheck prop_asoc
+++ OK, passed 100 tests.
*Main> quickCheck prop_neut
+++ OK, passed 100 tests.
-}

-- e) ir al apartado c)

-- f)
prop_conm2 :: Nat -> Nat -> Property
prop_conm2 a b = True ==> a * b == b * a

prop_asoc2 :: Nat -> Nat -> Nat -> Property
prop_asoc2 a b c = True ==> a * (b * c) == (a * b) * c

prop_neut2 :: Nat -> Property
prop_neut2 n = True ==> n * uno == n

{-
*Main> quickCheck prop_conm2
+++ OK, passed 100 tests.
*Main> quickCheck prop_asoc2
+++ OK, passed 100 tests.
*Main> quickCheck prop_neut2
+++ OK, passed 100 tests.
-}

-- g) ir al apartado c)

-- h) pág 92
{-
La definición de la suma de naturales que se usará es
                      y + Cero = y
                      x + Suc y = Suc (x + y)

Tomamos z igual Cero. Comenzamos probando el caso base. Demostramos que
                      (x + y) + Cero = x + (y + Cero)

Se simplifica el miembro izquierdo de la igualdad
                      (x + y) + Cero
                      => { por definición de (+) }
                      (x + y)

Simplificamos el miembro derecho
                    x + (y + Cero)
                    => { por definición de (+) }
                    (x + y)

De este modo, queda probado el caso base P(Cero)

Ahora se demuestra el paso inductivo P(Suc z) suponiendo P(z)
                  (x + y) + Suc z = x + (y + Suc z)

Se simplifica el miembro izquierdo de la igualdad
                  (x + y) + Suc z
                  => { por definición de (+) }
                  Suc ((x + y) + z)
                  => { por hipótesis de inducción }
                  Suc (x + (y + z))

Simplificamos el miembro derecho
                x + (y + Suc z)
                => { por definición de (+) }
                x + Suc (y + z)
                => { por definición de (+) }
                Suc (x + (y + z))

Con lo que queda demostrado el paso inductivo, que junto con la demostración
del caso base establecen la asociatividad de la suma de naturales.
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 36
--------------------------------------------------------------------------------
data Vector = V Double Double Double

instance Show Vector where
  show (V x y z) = concat (zipWith (++) vs ["i", "j", "k"])
    where
      vs = show x : map conSigno [y, z]
      conSigno x = (if x>=0 then " + " else " - ") ++ show (abs x)

v1, v2 :: Vector
v1 = V 1 (-3) 2
v2 = V (-2) 5 9

-- a)
{-
show (V 1 (-3) 2)
concat (zipWith (++) ["1", " - 3", " + 2"] ["i", "j", "k"])
concat (["1i", " - 3j", " + 2k"])
"1i", " - 3j", " + 2k"
-}

-- b)
instance Eq Vector where
  (V ux uy uz) == (V vx vy vz) = (ux ~= vx) && (uy ~= vy) && (uz ~= vz)

-- c)
zipWithVector :: (Double -> Double -> Double) -> Vector -> Vector -> Vector
zipWithVector f (V ux uy uz) (V vx vy vz) = V (f ux vx) (f uy vy) (f uz vz)

-- d)
-- (+), (-), (*) :: Vector -> Vector -> Vector

instance Num Vector where
  (+) = zipWithVector (+) -- v1 + v2 = zipWithVector (+) v1 v2 ... n-reducción
  (-) = zipWithVector (-)
  (V x1 y1 z1) * (V x2 y2 z2) = zipWithVector (-) (V (y1*z2) (z1*x2) (x1*y2)) (V (z1*y2) (x1*z2) (y1*x2))
  abs (V x y z) = error "abs no tiene sentido para vectores"
  signum = error "signum no tiene sentido para vectores"
  fromInteger x = V (fromInteger x) (fromInteger x) (fromInteger x)

-- e)
instance Arbitrary Vector where
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    z <- arbitrary
    return (V x y z)

prop_distr :: Vector -> Vector -> Vector -> Property
prop_distr v1 v2 v3 = True ==> (v1 + v2) * v3 == (v1 * v3) + (v2 * v3)

prop_antic :: Vector -> Vector -> Property
prop_antic v1 v2 = True ==> v1 * v2 == - (v2 * v1)

prop_idjac :: Vector -> Vector -> Vector -> Property
prop_idjac v1 v2 v3 = True ==> v1*(v2 * v3) + v3*(v1 * v2) + v2*(v3 * v1) == 0

{-
*Main> quickCheck prop_distr
+++ OK, passed 100 tests.
*Main> quickCheck prop_antic
+++ OK, passed 100 tests.
*Main> quickCheck prop_idjac
+++ OK, passed 100 tests.

-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 37
--------------------------------------------------------------------------------
type Fila = [Double]
data Matriz = M Int Int [Fila] deriving Eq

m1 :: Matriz
m1 = M 2 3  [ [ 1/3, -1/2, 1/5 ] ,
              [ 1/8,  3/7, 1/4 ]
            ]

-- a)
instance Show Matriz where
  show (M f c fs) = unlines . map (("| "++) . (++" |") . unwords . map rellena) $ fs
    where
      ancho = 8 --espacio para cada componente de la matriz (incluye punto y dos decimales)
      decimales = 2 --límite de decimales
      rellena n --map (map) a lista de listas de números ... rellena se aplica a cada número
        | l >= ancho = replicate ancho '*' --si tamaño string numérico >= 8 (contando el punto y los dos decimales), aparece un ********
        | otherwise = replicate (ancho-l) ' ' ++ xs --relleno de blancos lo que sobre y concateno con el string numérico
        where
          xs = showFFloat (Just decimales) n "" --devuelve string numérico de n con dos decimales
          l = length xs --longitud del string numérico

{-
>>> unlines ["Hello", "World", "!"]
"Hello\nWorld\n!\n"

*Main> map ((+2) . (+3)) [1, 2, 3]
[6,7,8]

>>> unwords ["Lorem", "ipsum", "dolor"]
"Lorem ipsum dolor"

*Main> showFloat 123.456 ""
"123.456"
*Main> showFFloat (Just 2) 123.456 ""
"123.46"
*Main> showFFloat (Just 1) 123.456 ""
"123.5"

showFFloat devuelve un string numérico y unwords recibe una lista con listas con strings numéricos.
Se le pone la barra (|) por la derecha y por la izquierda a cada elemento y luego se aplica el fin de línea

Prelude Numeric> map (map (\x -> showFFloat (Just 2) x "")) [[1, 2], [3, 4]]
[["1.00","2.00"],["3.00","4.00"]]

Prelude Numeric> map (unwords . map (\x -> showFFloat (Just 2) x "")) [[1, 2], [3, 4]]
["1.00 2.00","3.00 4.00"]

Prelude Numeric> map ((++" |"). unwords . map (\x -> showFFloat (Just 2) x "")) [[1, 2], [3, 4]]
["1.00 2.00 |","3.00 4.00 |"]

Prelude Numeric> map (("| "++) . (++" |"). unwords . map (\x -> showFFloat (Just 2) x "")) [[1, 2], [3, 4]]
["| 1.00 2.00 |","| 3.00 4.00 |"]

Prelude Numeric> unlines . map (("| "++) . (++" |"). unwords . map (\x -> showFFloat (Just 2) x "")) $ [[1, 2], [3, 4]]
"| 1.00 2.00 |\n| 3.00 4.00 |\n"
-}

-- b)
esMatriz :: Matriz -> Bool
esMatriz (M f c fs) = (f == length fs) && (all (\xs -> length xs == c) fs)

-- c)
sumaF :: Fila -> Fila -> Fila
sumaF = zipWith (+) -- sumaF xs ys = zipWith (+) xs ys

-- d)
sumaM :: Matriz -> Matriz -> Matriz
sumaM (M f1 c1 fs1) (M f2 c2 fs2) | (f1 /= f2) || (c1 /= c2) = error "sumaF: Matrices no sumables"
                                  | otherwise = M f1 c1 fr
                                  where
                                    fr = zipWith (sumaF) fs1 fs2  -- los elementos del zipWith externo son listas

-- e)
{-
restaF :: Fila -> Fila -> Fila
restaF = zipWith (-)
-}

restaM :: Matriz -> Matriz -> Matriz
restaM (M f1 c1 fs1) (M f2 c2 fs2) | (f1 /= f2) || (c1 /= c2) = error "restaF: Matrices no restables"
                                  | otherwise = M f1 c1 fr
                                  where
                                    fr = zipWith (\xs ys -> zipWith (-) xs ys) fs1 fs2

-- f)
traspuesta :: Matriz -> Matriz
traspuesta (M f c fs) = (M f c fs')
  where
    fs' = trasp fs
    trasp :: [Fila] -> [Fila]
    trasp ([]:_) = []
    trasp fs = (map head fs) : trasp (map tail fs)
{-
traspuesta [[1,2,3],[4,5,6],[7,8,9]]
<=>
(map head [[1,2,3],[4,5,6],[7,8,9]]) : (trasp (map tail [[1,2,3],[4,5,6],[7,8,9]]))
<=>
[1,4,7] : (trasp [[2,3],[5,6],[8,9]])
<=>
[1,4,7] : (map head [[2,3],[5,6],[8,9]]) : (trasp (map tail [[2,3],[5,6],[8,9]]))
<=>
[1,4,7] : [2,5,8] : (trasp [[3],[6],[9]])
<=>
[1,4,7] : [2,5,8] : (map head [[3],[6],[9]]) : (trasp (map tail [[3],[6],[9]]))
<=>
[1,4,7] : [2,5,8] : [3, 6, 9] : (trasp [[], [], []])
<=>
[1,4,7] : [2,5,8] : [3, 6, 9] : [] -- ya que trasp ([]:_) = []
<=>
[[1,4,7],[2,5,8],[3,6,9]]
-}

-- g)
porM :: Matriz -> Matriz -> Matriz
porM (M f1 c1 fs1) (M f2 c2 fs2)
  | c1 /= f2 = error "porM: matrices no multiplicables" -- el nº de columnas de la 1ª matriz debe ser igual al nº de filas de la 2ª
  | otherwise = M f1 c2 [ [ prodEsc f c | c <- tfs2 ] | f <- fs1 ] -- A_mxn * B_nxp = C_mxp
    where prodEsc f c = sum (zipWith (*) f c)
          (M _ _ tfs2) = traspuesta (M f2 c2 fs2)

{-
Obtengo una lista de [Double]
Cada elemento de fs1 lo opero con todos los elementos de tfs2, obteniendo las filas de la matriz resultado.

prueba xs ys = [ [sum (zipWith (+) a b) | b <- ys] | a <- xs ]
*Main> prueba [[1, 2, 3], [4, 5, 6]] [[4, 5, 6], [7,8, 9]]
[[21,30],[30,39]]
-}

-- h)
instance Num Matriz where
  m1 + m2 = sumaM m1 m2
  m1 - m2 = restaM m1 m2
  m1 * m2 = porM m1 m2
  abs (M f c fs) = (M f c fs') where fs' = map (map abs) fs
  fromInteger = error "fromInteger no tiene sentido para matrices"
  signum = error "signum no tiene sentido para matrices"

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 38
--------------------------------------------------------------------------------
-- a)
p_neutroDer :: Eq a => [a] -> Property
p_neutroDer xs = True ==> xs == xs ++ []

-- b)
{-
La definición del operador ++ es
                      (++) :: [a] -> [a] -> [a]
                      [] ++ ys = ys
                      (x:xs) ++ ys = x : (xs++ys)

Queremos demostrar que xs ++ [] = xs

Primero probamos el caso base. Tomamos xs igual []
Queremos demostrar que [] ++ [] = []
=> { por definición de (++) }
[] = []

Queda demostrado el caso base

Ahora demostramos el caso inductivo
Queremos demostrar que si xs ++ [] = xs entonces (x:xs) ++ [] = (x:xs)

(x:xs) ++ [] = (x:xs)
=> { por definición de ++ (izq) }
x : (xs++[]) = (x:xs)
=> { por hipótesis de inducción (izq) }
(x:xs) = (x:xs)

Con lo que queda demostrado el paso inductivo, que junto con la demostración del
caso base, prueba que la lista vacía es el elemento neutro por la derecha para el
operador ++
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 39
--------------------------------------------------------------------------------
-- a)
p_asociativa :: Eq a => [a] -> [a] -> [a] -> Property
p_asociativa xs ys zs = True ==> (xs ++ ys) ++ zs == xs ++ (ys ++ zs)

-- b)
{-
Probamos el caso base sustituyendo xs por [] demostrando que
([] ++ ys) ++ zs = [] ++ (ys ++ zs)

Miembro izquierdo
([] ++ ys) ++ zs
=> { por definición de (++) }
ys ++ zs

Miembro derecho
[] ++ (ys ++ zs)
=> { definición de (++) }
ys ++ zs

Quedando el caso base demostrado

Ahora demostramos el caso inductivo.
Si (xs ++ ys) ++ zs == xs ++ (ys ++ zs) entonces ((x:xs) ++ ys) ++ zs == (x:xs) ++ (ys ++ zs)

(xs ++ ys) ++ zs = xs ++ (ys ++ zs)

Miembro izquierdo
(xs ++ ys) ++ zs
=> { por definición de (++) }
(x : (xs++ys)) ++ zs
=> { por definición de (++) }
x : ((xs++ys) ++ zs)
=> { por hipótesis de inducción }
x : (xs ++ (ys ++ zs))

Miembro derecho
xs ++ (ys ++ zs)
=> { por definición de (++) }
x : (xs ++ (ys ++ zs))

Con lo que los dos miembros son iguales y queda demostrado el paso inductivo y
la asociatividad del operador (++)
-}

-- c)
{-
Supongamos  xs = [1, 2, 3]
            ys = [4]
            zs = [5, 6]
Por tanto, lx = 3, ly = 1, lz = 2

Calculemos los pasos para (xs ++ ys) ++ zs
([1, 2, 3] ++ [4]) ++ [5, 6]
(1 : ([2, 3] ++ [4])) ++ [5, 6]
(1 : (2: ([3] ++ [4]))) ++ [5, 6]
(1 : (2: (3 : ([] ++ [4])))) ++ [5, 6]
(1 : (2: (3 : ([4])))) ++ [5, 6]
1 : ([2, 3, 4] ++ [5, 6])
1 : (2 : ([3, 4] ++ [5, 6]))
1 : (2 : (3 : ([4] ++ [5, 6])))
1 : (2 : (3 : (4 : ([] ++ [5, 6]))))
1 : (2 : (3 : (4 : ([5, 6]))))
[1, 2, 3, 4, 5, 6]

El número de pasos es (lx + 1) + (lx + ly + 1) = (3 + 1) + (3 + 1 + 1) = 9

Ahora calculemos los pasos para xs ++ (ys ++ zs)
[1, 2, 3] ++ ([4] ++ [5, 6])
[1, 2, 3] ++ (4 : ([] ++ [5, 6]))
[1, 2, 3] ++ (4 : ([5, 6]))
1 : ([2, 3] ++ [4, 5, 6])
1 : (2 : ([3] ++ [4, 5, 6]))
1 : (2 : (3 :([] ++ [4, 5, 6])))
1 : (2 : (3 :([4, 5, 6])))
[1, 2, 3, 4, 5, 6]

El número de pasos es (ly + 1) + (lx + 1) = (1 + 1) + (3 + 1) = 6

Haciendo xs ++ (ys ++ zs) logramos mayor eficiencia.
-}

-- d)
{-
Es asociativo a la derecha porque así evitamos tener que volver a sacar todos los
elementos del miembro de la izquierda una y otra vez.
-}

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 40
--------------------------------------------------------------------------------
{-
Recordemos la definición de map

        map :: (a -> b) -> [a] -> [b]
        map f [] = []
        map f (x:xs) = f x : map f xs

1ª propiedad: map id xs = xs
Caso base. Tomamos xs = []
map id []
=> { por definición de map }
[]

Con lo que queda demostrado el caso base.

Caso inductivo
Si map id xs = xs entonces map id (x:xs) = (x:xs)
map id (x:xs)
=> { por definición de map }
id x : map id xs
=> { por hipótesis de inducción }
id x : xs
=> { por definición de id }
(x:xs)

Quedando demostrado el paso inductivo y por ello, la 1ª propiedad.

--------------------------------------------------------------------------------
Recordemos la definición de (.)

          (.) :: (b -> c) -> (a -> b) -> a -> c
          f . g = \x -> f (g x)

Ejemplo
*Main> map ((<5) . (+2)) [1, 2, 3, 4]
[True,True,False,False]

*Main> map (\x -> (<5)(x + 2)) [1, 2, 3, 4]
[True,True,False,False]

2ª propiedad: map (f . g) xs = (map f . map g) xs
Caso base. Tomamos xs = []

Miembro izquierdo
map (f . g) []
=> { por definición de map }
[]

Miembro derecho
(map f . map g) []
=> { por definición de (.) }
map f (map g [])
=> { por definición de map }
map f ([])
=> { por definición de map }
[]

Con lo que queda demostrado el caso base.

Caso inductivo
Si  map (f . g) xs = (map f . map g) xs entonces  map (f . g) (x:xs) = (map f . map g) (x:xs)

Miembro izquierdo
map (f . g) (x:xs)
=> { por definición de map }
(f . g) x : map (f . g) xs
=> { por hipótesis de inducción }
(f . g) x : (map f . map g) xs
=> { por definición de (.) }
f (g x) : (map f . map g) xs
=> { por definición de (.) }
f (g x) : map f (map g xs)

Miembro derecha
(map f . map g) (x:xs)
=> { por definición de (.) }
map f (map g (x:xs))
=> { por definición de map }
map f (g x : map g xs)
=> { por definición de map }
f (g x) : map f (map g xs)

Quedando demostrado el paso inductivo y por ello, la 2ª propiedad.
-}

------------------------------------ fin ---------------------------------------

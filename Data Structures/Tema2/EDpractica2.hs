-- Alumno: Salvador CF
-- Relación de ejercicios 2. Ejercicios resueltos: 6, 7, 8, 13, 14, 23, 24, 31

import Test.QuickCheck
import Data.List

-- Ejercicio 6
divideA :: (Integral a) => a -> a -> Bool
divideA x y = mod y x == 0

divisores :: (Integral a) => a -> [a]
divisores v = [x | x <- [1..abs (v)], divideA x v]  -- el "<-" significa pertenece. Me quedo con todos los valores de 1 a v que cumpla la guarda: divideA x v

divisores' :: (Integral a) => a -> [a]
divisores' v = [x | x <- [(-v)..(-1)] ++ [1..abs(v)], divideA x v] -- el "++" es la concatenación de listas

-- Ejercicio 7
-- a)
mcd :: (Integral a) => a -> a -> a
mcd b c = maximum[x | x <- divisores b, x `elem` divisores c]

-- b)
prop_mcd x y z = x/=0 && y/=0 && z/=0 ==> mcd (z*x) (z*y) == (abs z)* mcd x y

-- c)
mcm :: (Integral a) => a -> a -> a
mcm x y = div (x*y) (mcd x y)

-- Extra: algoritmo de Euclides
mcdEuclides :: Integer -> Integer -> Integer
mcdEuclides x y  | y == 0 = x
                 | otherwise = mcdEuclides y (mod x y)

-- Ejercicio 8 (uso contador bucle for)
-- a)
esPrimo :: (Integral a) => a -> Bool
esPrimo x | x < 0 = error "Argumento negativo"
          | x <= 1 = False
          | otherwise = esPrimo' x 2
    where esPrimo' x i | x `mod` i == 0 && x /=i = False
                       | x == i = True
                       | otherwise = esPrimo' x (i+1)

-- b)
primosHasta :: (Integral a) => a -> [a]
primosHasta x = [ x | x <- [2..x], esPrimo x]

-- c)
primosHasta' :: (Integral a) => a -> [a]
primosHasta' x = filter esPrimo [2..x]

-- d)
p1_primos x = primosHasta x == primosHasta' x
{-
*Main> quickCheck p1_primos
+++ OK, passed 100 tests.
-}

-- Ejercicio 13
desconocida :: (Ord a) => [a] -> Bool
desconocida xs = and [ x<=y | (x,y) <- zip xs (tail xs)]

{-
Explicación: Recibe un "a" de tipo ordenado y devuelve un booleano.
Indica si una lista está ordenada o no:

*Main> zip [1,2,3] (tail [1,2,3])
[(1,2),(2,3)] : True and True = True

Obtendré una lista de booleanos correspondientes a la evaluación de que el primer componente del par sea menor al segundo para la lista de pares es especificada
Si el primer componente siempre es menor, todo será True, así como el resultado final.

-tail: devuelve la lista sin su primer elemento
-zip: recibe dos listas y devuelve una lista asociando los elementos de las dos primeras según su posición en la lista.
  ejemplo zip:
  *Main> zip [1,2,3,4] [5,6,7,8,9]
  [(1,5),(2,6),(3,7),(4,8)]
-and: recibe una lista de booleanos y devuelve el resultado de hacerle "and" a todos ellos
-}

-- Ejercicio 14 (diapo 8 tema 2: patrones)
-- a)
inserta :: (Ord a) => a -> [a] -> [a]
inserta x [] = [x]
inserta x (y:ys) = takeWhile (<x) (y:ys) ++ [x] ++ dropWhile (<x) (y:ys)

-- b) y es la cabeza de la lista. ys es el resto de la lista.
-- si x es menor oigual que la cabeza de la lista, lo mete delante
-- si no, avanza una posición y vuelve a hacer la llamada hasta que se encuentre con un elemento menor o igual
inserta' :: (Ord a) => a -> [a] -> [a]
inserta' x [] = [x]
inserta' x (y:ys) | x <= y = x:y:ys
                  | otherwise = y: inserta' x ys        -- la cabeza se queda y la llamo a inserta' con mi elemento y la cola

-- c)
-- Para todo x, xs, si la lista xs está ordenada, entonces al insertar x en su lugar, seguirá estando ordenada
p1_inserta x xs = desconocida xs ==> desconocida (inserta x xs)

-- d)
{- Plegando listas: diapo 33
9 `inserta` (3 `inserta` (7 `inserta` []))
Primero se inserta el 7 y queda [7]
Luego el 3 y luego el 9 sobre la lista que va quedando
Lo interesante es el uso infijo de la función
-}

-- e) -- Diapo 32
ordena :: (Ord a) => [a] -> [a]
ordena xs = foldr inserta [] xs
-- Le doy una lista y pliega desde la derecha y el primer elemento es la lista vacía
{-
xs = [3,1,6,4]
3 `inserta`(1 `inserta` (6 `inserta` (4 `inserta` [])))
-}

-- f) import Data.List
prop1_ord xs = True ==> ordena xs == sort xs
prop2_ordena xs = desconocida(ordena xs)
{-
*Main Data.List> quickCheck prop_ord
+++ OK, passed 100 tests.
*Main Data.List> quickCheck prop2_ordena
+++ OK, passed 100 tests.
-}

-- g) Para toda lista xs, desconocida(ordena xs) = True
-- inserta 2 (3:[4,5,6,7])
{-
*Caso base: desconocida (ordena []) = True
** Demostración caso base:
    desconocida (ordena []) = desconocida (foldr inserta [] [])
                            = desconocida ([] `inserta` [])
                            = desconocida ([[]])
                            = True

*Paso inductivo
  Si desconocida (ordena xs) = True [H.I]
  Entonces desconocida (ordena x:xs) = True
    ** Demostración caso inductivo:
        desconocida (ordena x:xs) = desconocida (ordena x) and desconocida (ordena xs)
                                  = desconocida ([x]) and True [H.I]
                                  = True and True
                                  = True
-}

-- Ejercicio 23
-- a) "_" se refiere a un elemento, sin importar qué elemento es
nub'  :: (Ord a) => [a] -> [a]
nub' l                   = nub'' l [] -- al inicio, el segundo argumento es la lista vacía
  where
    nub'' [] _           = [] -- si l era una lista vacía, me da igual lo que haya al lado, devuelvo la vacía
    nub'' (x:xs) ls
        | x `elem` ls   = nub'' xs ls -- tail [x] = []
        | otherwise     = x : nub'' xs (x:ls) -- 1:2:3:[] = [1,2,3]

{-
al final entra por nub'' [] _ y quedara x:y:z:...:[] = [x,y,z...]
Si el elemento pertence a la lista, se llama a nub'' con la cola (se avanza) y la lista de acumulados
Si el elemento x no pertenece, tendrá que inclurise a la lista resultado (x:) y se llama de nuevo a nub''
con la cola (avanza) y la lista de haber añadido el nuevo elemento a los acumulados
El segundo array (ls) es la lista de acumulados, se chequea si el nuevo elemento pertence a esa lista o no.
En la primera no se vuelve a meter el elemento, en la segunda, sí
-}

-- b)
p_nub' xs = nub xs == nub' xs
{-
*Main> quickCheck p_nub'
+++ OK, passed 100 tests.
-}

-- c) p_sinRepes xs = distintos (nub' xs)
{-
Si nub' hiciera lo que tiene que hacer y además le metiera otro elemento distinto a todos los que hay,
distintos seguiría dando True, al igual que p_sinRepes. Sin embargo, nub' no sólo se ha dedicado a elimnar los
repetidos, sino que ha añadido un elemento sin tener que hacerlo.
-}

-- d) Comprueba si todos los de la primera lista se encuentran en la segunda
todosEn :: (Eq a) => [a] -> [a] -> Bool
ys `todosEn` xs = all (`elem` xs) ys
-- y `elem` xs para todo elemento y perteneciente a ys

p_sinRepes' xs = distintos (nub' xs) && (todosEn (nub' xs) (xs))

distintos :: Ord a => [a] -> Bool
distintos [] = True
distintos [_] = True
distintos (x:xs) | elem x xs = False
                 | otherwise = distintos xs

-- Ejercicio 24: "010" == ['0', '1', '0']
-- a)
binarios :: Integer -> [[Char]]
binarios 0 = [[]]
binarios 1 = ["0", "1"]
binarios x = (map ("0"++) (binarios (x-1))) ++ (map ("1"++) (binarios (x-1)))

-- b)
p_binarios n = n>=0 && n<=10 ==>
                    long xss== 2^n
                    && distintos xss
                    && all (`todosEn` "01") xss
      where xss = binarios n

long :: [a] -> Integer  -- los elementos tiene que ser del mismo tipo
long xs = fromIntegral (length xs)

{-
*Main> quickCheck p_binarios
+++ OK, passed 100 tests.
En cuanto a la cuarta línea comentar que todos los elementos de xss por ejem ["00","01","10","11"]: esto es una
lista cuyos elementos son listas de caracteres. Entonces, cada elemento al ser una lista, puede usar la
función todosEn, siendo el primer argumento una lista de caracteres del conjunto de cadenas y el segundo
una lista con dos caracteres, '0' y '1': "01" == ['0','1']
Se comprueba que no haya ningún caracter diferente de 0 o 1
-}

-- Ejercicio 31
-- (Double -> Double) es la función f
-- a)
inteDef :: (Double -> Double)-> Double -> Double -> Double -> Double
inteDef f a b ep | (b-a) <= ep = (b-a)*(f a + f b)/2
                 | otherwise = (inteDef f a m ep) + (inteDef f m b ep)
                      where m = (a+b)/2
{-
Explicación:
inteDef f 2 10 2
(inteDef f 2 6 2) + (inteDef f 6 10 1)
[(inteDef f 2 4 2)+(inteDef f 4 6 2)]+[(inteDef f 6 8 2)+(inteDef f 8 10 2)]
Ahora el intervalo es <= a ep y devuelve el área del trapecio, sumándose todo
-}

-- b)
inteDef' :: (Double -> Double)-> Double -> Double -> Double -> Double
inteDef' f a b n = ((b-a)/n) * ((f a + f b)/2 + sum [(f (a+k*(b-a)/n)) | k <- [1..(n-1)]])

--

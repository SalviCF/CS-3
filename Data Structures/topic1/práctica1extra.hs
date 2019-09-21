-- Práctica 1 - Ejercicios extra
--
-- Alumno: Salvador CF
-------------------------------------------------------------------------------

module Practica1Extra where

import Test.QuickCheck

-------------------------------------------------------------------------------
-- Ejercicio - esPrimo
-------------------------------------------------------------------------------

-- esPrimo :: completa la definición de tipo

-- Si n es compuesto, existe un divisor primo p tal que p <= sqrt(n).
-- Un entero es primo si no es divisible por ningún primo menor o igual que su raíz cuadrada.

esPrimo :: Integer -> Bool
esPrimo x | x <= 0    = error "esPrimo: Argumento negativo o cero."
          | x == 1    = False
          | otherwise = esPrimo' x 2
  where esPrimo' x i  | (x `mod` i == 0) && (i /= x)        = False -- compuesto
                      | (i > floor(sqrt (fromIntegral x)))  = True  -- primo
                      | otherwise                           = esPrimo' x (i+1)

{-
    Referencias:
      https://en.wikipedia.org/wiki/Primality_test
      https://wiki.haskell.org/Converting_numbers
-}
-------------------------------------------------------------------------------
-- Ejercicio - libre de cuadrados
-------------------------------------------------------------------------------

libreDeCuadrados :: Integer -> Bool
libreDeCuadrados n | n <= 0 = error "libreDeCuadrados: Argumento negativo o cero"
                   | n <= 3 = True
                   | otherwise = libreDeCuadrados' n 2 1
  where
    libreDeCuadrados' n i s | (s >= n)                              = True -- libre
                            | (n `mod` i^2 == 0)                    = False
                            | (n `mod` i == 0) && (s `mod` i /= 0)  = libreDeCuadrados' n (i+1) (s*i) -- multiplico primos
                            | otherwise                             = libreDeCuadrados' n (i+1) s

----------------------------------------------------------------------
-- Ejercicio - números de Harshad
----------------------------------------------------------------------

sumaDigitos :: Integer -> Integer
sumaDigitos n | n < 0     = error "sumaDigitos: Argumento negativo."
              | n < 10    = n
              | otherwise = (mod n 10) + sumaDigitos(div n 10)

harshad :: Integer -> Bool
harshad x | x <= 0    = error "harshad: Argumento no positivo."
          | otherwise = (x `mod` sumaDigitos x) == 0

harshadMultiple :: Integer -> Bool
harshadMultiple n = harshad n && harshad(n `div` sumaDigitos n)

vecesHarshad :: Integer -> Integer
vecesHarshad n  | not(harshad n)                   = 0
                | (n == 1) || (sumaDigitos n == 1) = 1
                | otherwise                        = 1 + vecesHarshad(n `div` sumaDigitos n)

prop_Bloem_Harshad_OK :: Integer -> Property
prop_Bloem_Harshad_OK n = n>0 ==> vecesHarshad(1008*10^n) == (n+2)

{-
    *Practica1Extra> quickCheck prop_Bloem_Harshad_OK
    +++ OK, passed 100 tests.
-}

----------------------------------------------------------------------
-- Ejercicio - ceros del factorial
----------------------------------------------------------------------

-- The common way to translate a body recursion into a tail recursion is to add a accumulator in argument list.
-- A continuación se implementan dos funciones que calculan el factorial de un número:

factorial :: Integer -> Integer
factorial n | (n < 0)   = error "factorial: Argumento negativo."
            | (n < 2)   = 1
            | otherwise = n * factorial(n-1)

factorial' :: Integer -> Integer
factorial' n = facAc n 1
  where
    facAc n ac  | (n < 0)   = error "factorial': Argumento negativo."
                | (n == 0)  = ac
                | otherwise = facAc (n-1) (n*ac)

cerosDe :: Integer -> Integer
cerosDe n | (n == 0)          = 1
          | (n `mod` 10 /= 0) = 0
          | otherwise         = 1 + cerosDe(n `div` 10)

prop_cerosDe_OK :: Integer -> Integer -> Property
prop_cerosDe_OK n m = (0 <= m && m <= 1000 && mod n 10 /= 0) ==> cerosDe(n * 10^m) == m

{-
*Practica1Extra> quickCheck prop_cerosDe_OK
+++ OK, passed 100 tests.
-}

{-

Responde las siguientes preguntas:

¿En cuańtos ceros acaba el factorial de 10?
2

¿En cuańtos ceros acaba el factorial de 100?
24

¿En cuańtos ceros acaba el factorial de 1000?
249

¿En cuańtos ceros acaba el factorial de 10000?
2499

-}

----------------------------------------------------------------------
-- Ejercicio - números de Fibonacci y fórmula de Binet
----------------------------------------------------------------------

fib :: Integer -> Integer
fib n | (n < 0)   = error "fib: Argumento negativo."
      | (n == 0)  = 0
      | (n == 1)  = 1
      | otherwise = fib(n-1) + fib(n-2)

llamadasFib :: Integer -> Integer
llamadasFib n | (n < 0)   = error "llamadasFib: Argumento negativo."
              | (n < 2)   = 1
              | otherwise = llamadasFib(n-1) + llamadasFib(n-2) + 1

{-

Responde a las siguientes preguntas:

¿Cuántas llamadas a fib son necesarias para calcular fib 30?
2692537

¿Cuántas llamadas a fib son necesarias para calcular fib 36?
48315633

-}

fib' :: Integer -> Integer
fib' n = fibAc n 0 1
  where
    fibAc n ac1 ac2 | (n < 0)   = error "fib': Argumento negativo."
                    | (n == 0)  = ac1
                    | otherwise = fibAc (n-1) (ac2) (ac1 + ac2)

llamadasFib' :: Integer -> Integer
llamadasFib' n = llamadasFib'Ac n 1
  where llamadasFib'Ac n ac | (n < 0)   = error "llamadasFib': Argumento negativo."
                            | (n == 0)  = ac
                            | otherwise = llamadasFib'Ac (n-1) (ac+1)

prop_fib_OK :: Integer -> Property
prop_fib_OK n = (0 <= n && n <= 30) ==> fib n == fib' n

{-
    *Practica1Extra> quickCheck prop_fib_OK
    +++ OK, passed 100 tests.

    Referencias:
      http://www.idryman.org/blog/2012/04/14/recursion-best-practices/
-}

{-

Responde a las siguientes preguntas:

¿Cuántas llamadas a fib son necesarias para calcular fib' 30?
31

¿Cuántas llamadas a fib son necesarias para calcular fib' 36?
37

-}


phi :: Double
phi = (1 + sqrt 5) / 2

binet :: Integer -> Integer
binet n = round ( (phi^n - (1-phi)^n) / sqrt 5 )

prop_fib'_binet_OK :: Integer -> Property
prop_fib'_binet_OK n = (n >= 0) ==> fib' n == binet n

{-

Responde a la siguiente pregunta:

¿A partir de qué valor devuelve binet resultados incorrectos?
76

*Practica1Extra> quickCheck prop_fib'_binet_OK
*** Failed! Falsifiable (after 82 tests and 2 shrinks):
76
-}

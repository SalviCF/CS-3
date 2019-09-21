-- Práctica 1 - Ejercicios extra
--
-- Alumno: Salvador CF
-------------------------------------------------------------------------------

module Practica1Extra where

import Test.QuickCheck

----------------------------------------------------------------------
-- Ejercicio - esPrimo (interesante el uso del contador, simula un bucle for)
----------------------------------------------------------------------

-- esPrimo :: completa la definición de tipo
esPrimo :: (Integral a) => a -> Bool
esPrimo x
          | x <= 0 = error "Argumento negativo o cero"
          | x == 1 = False
          | otherwise = esPrimo' x 2

esPrimo' :: (Integral a) => a -> a -> Bool
esPrimo' x i
            | x `mod` i == 0 && x /= i = False
            | x == i = True
            | otherwise = esPrimo' x (i+1)

----------------------------------------------------------------------
-- Ejercicio - libre de cuadrados
----------------------------------------------------------------------

libreDeCuadrados :: Integer -> Bool
libreDeCuadrados n | n <= 0 = error "Argumento negativo o cero"
                   | n <= 3 = True
                   | otherwise = libreDeCuadrados' n 2

libreDeCuadrados' :: Integer -> Integer -> Bool
libreDeCuadrados' n i | n < i^2 = True
                      | n `mod` i^2 == 0 = False
                      | otherwise = libreDeCuadrados' n (i+1)

----------------------------------------------------------------------
-- Ejercicio - números de Harshad
----------------------------------------------------------------------

sumaDigitos :: Integer -> Integer
sumaDigitos n | n < 0 = error "Argumento negativo"
              | n < 10 = n
              | otherwise = sumaDigitos(n `div` 10)+(n `mod` 10)

harshad :: Integer -> Bool
harshad x | x <= 0 = error "Argumento no positivo"
          | x `mod` sumaDigitos x == 0 = True
          | otherwise = False

harshadMultiple :: Integer -> Bool
harshadMultiple n | harshad n && harshad (n `div` sumaDigitos n) = True
                  | otherwise = False

vecesHarshad :: Integer -> Integer
vecesHarshad n | harshad n == False = 0
               | n == 1 || sumaDigitos n == 1 = 1
               | otherwise = 1 + vecesHarshad(n `div` sumaDigitos n)


-- QuickCheck genera números aleatorios pero ninguno satisface el predicado, por eso norealiza ningún test.
-- Tengo que forzar a que se elijan valores que satisfagan el predicado.
prop_Boem_Harshad_OK :: Integer -> Property
prop_Boem_Harshad_OK n = n>=0 ==> vecesHarshad(1008*10^n) == (n+2)

{-
*Practica1Extra> quickCheck prop_Boem_Harshad_OK
+++ OK, passed 100 tests.
-}

----------------------------------------------------------------------
-- Ejercicio - ceros del factorial
----------------------------------------------------------------------

factorial :: Integer -> Integer
factorial n | n<0 = error "Argumento negativo"
            | n==0 = 1
            | n==1 = 1
            | n>1 = n*factorial(n-1)

cerosDe :: Integer -> Integer
cerosDe n | n==0 = 1
          | mod n 10 /= 0 = 0
          | otherwise = 1 + cerosDe(div n 10)

prop_cerosDe_OK :: Integer -> Integer -> Property
prop_cerosDe_OK n m = m>=0 && m<=1000 && mod n 10 /=0 ==> cerosDe (n*10^m) == m



{-

Responde las siguientes preguntas:

¿En cuańtos ceros acaba el factorial de 10?
*Practica1Extra> cerosDe (factorial 10)
2

¿En cuańtos ceros acaba el factorial de 100?
*Practica1Extra> cerosDe (factorial 100)
24

¿En cuańtos ceros acaba el factorial de 1000?
*Practica1Extra> cerosDe (factorial 1000)
249

¿En cuańtos ceros acaba el factorial de 10000?
*Practica1Extra> cerosDe (factorial 10000)
2499

-}

----------------------------------------------------------------------
-- Ejercicio - números de Fibonacci y fórmula de Binet
----------------------------------------------------------------------

fib :: Integer -> Integer
fib n | n < 0 = error "fib: Argumento negativo"
      | n == 0 = 0
      | n == 1 = 1
      | otherwise = fib(n-1) + fib(n-2)

llamadasFib :: Integer -> Integer
llamadasFib n | n==0 || n==1 = 1
              | otherwise = 1 + llamadasFib(n-1) + llamadasFib(n-2)

{-

Responde a las siguientes preguntas:

¿Cuántas llamadas a fib son necesarias para calcular fib 30?
*Practica1Extra> llamadasFib 30
2692537

¿Cuántas llamadas a fib son necesarias para calcular fib 36?
*Practica1Extra> llamadasFib 36
48315633

-}
-- http://www.idryman.org/blog/2012/04/14/recursion-best-practices/
fib' :: Integer -> Integer
fib' n | n<0 = error "fib': Argumento negativo"
       | otherwise = fibAc n 0 1
  where fibAc 0 ac1 ac2 = ac1
        fibAc n ac1 ac2 = fibAc(n-1) ac2 (ac1+ac2)

fib'' :: Integer -> Integer
fib'' n | n<0 = error "fib'': Argumento negativo"
        | otherwise = fibAc' n 0 1 1
          where fibAc' 0 ac1 ac2 llamadas = llamadas
                fibAc' n ac1 ac2 llamadas = fibAc'(n-1) ac2 (ac1+ac2) (llamadas+1)

prop_fib_OK :: Integer -> Property
prop_fib_OK n = n>=0 && n<=30 ==> fib n == fib' n
{-
*Practica1Extra> quickCheck prop_fib_OK
+++ OK, passed 100 tests.
-}

{-

Responde a las siguientes preguntas:

¿Cuántas llamadas a fib son necesarias para calcular fib' 30?
31

¿Cuántas llamadas a fib son necesarias para calcular fib' 36?
37

-}

phi :: Double
phi = (1 + sqrt 5)/2

binet :: Integer -> Integer
binet n = round((phi^n - (1-phi)^n) / sqrt 5)

prop_fib'_binet_OK :: Integer -> Property
prop_fib'_binet_OK n = n>=0 ==> fib' n == binet n

{-

Responde a la siguiente pregunta:

¿A partir de qué valor devuelve binet resultados incorrectos?
75, el 76 ya es incorrecto.
-}

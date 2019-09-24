-- Relación de ejercicios 1
--
-- Alumno: Salvador CF
--------------------------------------------------------------------------------

import Test.QuickCheck

--------------------------------------------------------------------------------
-- Ejercicio 1 - ¿Es terna pitagórica?
--------------------------------------------------------------------------------
-- a)
esTerna :: Integer -> Integer -> Integer -> Bool
esTerna x y z = x*x + y*y == z*z
--------------------------------------------------------------------------------
-- b)
terna :: Integer -> Integer -> (Integer, Integer, Integer)
terna x y = (x*x-y*y, 2*x*y, x*x+y*y)
--------------------------------------------------------------------------------
-- c) Si el antecedente es True, el consecuente también debe serlo.
p_ternas x y = (x>0) && (y>0) && (x>y) ==> esTerna c1 c2 hip
  where
    (c1, c2, hip) = terna x y
--------------------------------------------------------------------------------
-- d)
{-
    *Main> quickCheck(p_ternas :: Integer -> Integer -> Property)
    +++ OK, passed 100 tests.
-}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 2 - Intercambia los elementos de una 2-tupla
--------------------------------------------------------------------------------
intercambia :: (a, b) -> (b, a)
intercambia (x, y) = (y, x)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 3 - Ordena los elementos de una 2-tupla y 3-tupla
--------------------------------------------------------------------------------
-- a)
ordena2 :: Ord a => (a, a) -> (a, a)
ordena2 (x, y)  | x<y       = (x, y)
                | otherwise = (y, x)

p1_ordena2 x y = True ==> enOrden (ordena2(x, y))
  where enOrden(x, y) = x<=y

p2_ordena2 x y = True ==> mismosElementos(x, y) (ordena2(x, y))
  where
    mismosElementos (x, y) (z, v) = (x==z && y==v) || (x==v && y==z)

{-
    *Main> quickCheck p1_ordena2
    +++ OK, passed 100 tests.
    *Main> quickCheck p2_ordena2
    +++ OK, passed 100 tests.
-}
--------------------------------------------------------------------------------
-- b)
ordena3 :: Ord a => (a, a, a) -> (a, a, a)
ordena3 (x, y, z) | x>y       = ordena3 (y, x, z)
                  | y>z       = ordena3 (x, z, y)
                  | x>z       = ordena3 (z, x, y)
                  | otherwise = (x, y, z)
--------------------------------------------------------------------------------
-- c)
p1_ordena3 x y z = True ==> enOrden(ordena3(x, y, z))
  where enOrden(x, y, z) = (x<=y) && (y<=z)

p2_ordena3 x y z = True ==> mismosElementos (x, y, z) (ordena3(x, y, z))
  where
    mismosElementos(x, y, z) (u, v, w) = (x, y, z) == (u, v, w) ||
                                         (x, y, z) == (u, w, v) ||
                                         (x, y, z) == (v, u, w) ||
                                         (x, y, z) == (v, w, u) ||
                                         (x, y, z) == (w, v, u) ||
                                         (x, y, z) == (w, u, v)
{-
    *Main> quickCheck p1_ordena3
    +++ OK, passed 100 tests.
    *Main> quickCheck p2_ordena3
    +++ OK, passed 100 tests.
-}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 4 - Calcula el máximo de dos valores
--------------------------------------------------------------------------------
-- a)
max2 :: Ord a => a -> a-> a
max2 x y | x>y        = x
         | otherwise  = y
--------------------------------------------------------------------------------
-- b)
-- El máximo de dos números x e y coincide o bien con x o bien con y
p1_max2 x y = True ==> (max2 x y == x) || (max2 x y == y)

-- El máximo de x e y es mayor o igual que x, así como mayor o igual que y
p2_max2 x y = True ==> (max2 x y >= x) && (max2 x y >= y)

-- Si x es mayor o igual que y, entonces el máximo de x e y es x
p3_max2 x y = x>=y ==> max2 x y == x

-- Si y es mayor o igual que x, entonces el máximo de x e y es y
p4_max2 x y = y>=x ==> max2 x y == y

{-
    *Main> quickCheck p1_max2
      +++ OK, passed 100 tests.
    *Main> quickCheck p2_max2
      +++ OK, passed 100 tests.
    *Main> quickCheck p3_max2
      +++ OK, passed 100 tests.
    *Main> quickCheck p4_max2
      +++ OK, passed 100 tests.
-}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 5 - Calcula si un valor está entre otros dos
--------------------------------------------------------------------------------
entre :: Ord a => a -> (a, a) -> Bool
entre x (inf, sup) = (x >= inf) && (x <= sup)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 6 - Calcula si los valores de una 3-tupla son iguales
--------------------------------------------------------------------------------
iguales3 :: Eq a => (a, a, a) -> Bool
iguales3 (x, y, z) = (x==y) && (y==z)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 7 - Descomponer segundos en horas minutos y segundos
--------------------------------------------------------------------------------
-- a)
-- Mirar Zvon Haskell Reference (funciones del Prelude)
{-
    *Main> :t divMod
    divMod :: Integral a => a -> a -> (a, a)
-}

type TotalSegundos = Integer
type Horas         = Integer
type Minutos       = Integer
type Segundos      = Integer

descomponer :: TotalSegundos -> (Horas, Minutos, Segundos)
descomponer s = (horas, minutos, segundos)
   where
     (horas, resto)       = divMod s 3600
     (minutos, segundos)  = divMod resto 60

{- Además
https://wiki.haskell.org/Type#Type_and_newtype
http://eliatron.blogspot.com/2012/05/cuanto-vale-la-parte-entera-de-165.html
-}
--------------------------------------------------------------------------------
-- b)
p_descomponer x = x>=0 ==> h*3600 + m*60 + s == x
                           && entre m(0, 59)
                           && entre s(0, 59)
  where (h, m, s) = descomponer x

{-
    *Main> quickCheck p_descomponer
    +++ OK, passed 100 tests.
-}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 8 - Euros y pesetas
--------------------------------------------------------------------------------
unEuro :: Double
unEuro = 166.386

-- a)
pesetasAEuros :: Double -> Double
pesetasAEuros x = x/unEuro
--------------------------------------------------------------------------------
-- b)
eurosAPesetas :: Double -> Double
eurosAPesetas x = x*unEuro
--------------------------------------------------------------------------------
-- c)
-- definida en el ejercicio 9
-- no se verifica porque la división real puede tener infinitos decimales
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 9 - Operador
--------------------------------------------------------------------------------
infix 4 ~=
(~=) :: Double -> Double -> Bool
x ~= y = abs(x-y) < epsilon
  where epsilon = 1/1000

p_inversas x = eurosAPesetas(pesetasAEuros x) ~= x

{-
    *Main> quickCheck p_inversas
    +++ OK, passed 100 tests.
-}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 10 - Ecuación de segundo grado
--------------------------------------------------------------------------------
-- a)
raíces :: Double -> Double -> Double -> (Double, Double)
raíces a b c | (a==b) && (b==c) && (c==0) = (0, 0)
             | (a == b) && (a == 0)       = error "Absurdo."
             | a == 0                     = (-c/b, -c/b)
             | disc == 0                  = (-b/(2*a), -b/(2*a))
             | disc < 0                   = error "El discriminante es negativo, las raíces no son reales."
             | otherwise                  = (r1, r2)
  where
    disc  = (b*b) - (4*a*c)
    r1    = (-b + sqrt(disc)) / (2*a)
    r2    = (-b - sqrt(disc)) / (2*a)
--------------------------------------------------------------------------------
-- b)
p1_raíces a b c = (disc >= 0) ==> (esRaíz r1) && (esRaíz r2)
  where
    (r1, r2)  = raíces a b c
    esRaíz r  = a*r^2 + b*r + c ~= 0
    disc      = (b*b) - (4*a*c)

{-
    *Main> quickCheck p1_raíces
    +++ OK, passed 100 tests.
-}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 11 - Calcula si x es múltiplo de y
--------------------------------------------------------------------------------
esMúltiplo :: Integral a => a -> a -> Bool
esMúltiplo x y = (mod x y == 0)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 12 - Operador implicación lógica
--------------------------------------------------------------------------------
infixl 1 ==>>
(==>>) :: Bool -> Bool -> Bool
False ==>> y = True
True  ==>> y = y
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 13 - Años bisiestos
--------------------------------------------------------------------------------
type Año = Integer
esBisiesto :: Año -> Bool
esBisiesto n = (n `mod` 4 == 0) && ((n `mod` 100 == 0) ==>> (n `mod` 400 == 0))
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 14 - Operador potencia
--------------------------------------------------------------------------------
-- a)
potencia :: Integer -> Integer -> Integer
potencia b n  | n==0      = 1
              | n==1      = b
              | n>0       = b * potencia b (n-1)
              | otherwise = error "Exponente negativo."
--------------------------------------------------------------------------------
-- b)
potencia' :: Integer -> Integer -> Integer
potencia' b n | n==0        = 1
              | n==1        = b
              | even n      = potencia' b (div n 2) * potencia' b (div n 2)
              | otherwise   = b * potencia' b (div (n-1) 2) * potencia' b (div (n-1) 2)
--------------------------------------------------------------------------------
-- c)
p_pot b n = n >= 0 ==> (potencia b n == sol) &&
                       (potencia' b n == sol)
  where sol = b^n

{-
    *Main> quickCheck p_pot
    +++ OK, passed 100 tests.
-}
--------------------------------------------------------------------------------
-- d)
{-
http://www.cs.cmu.edu/~rweba/algf09/solverecurrencesSF.pdf
https://stackoverflow.com/questions/18250132/exponentiation-by-squaring-time-complexity

Para la función potencia el número de multiplicaciones es O(n)
Para la función potencia' el número de multiplicaciones es O(log n), sólo computa una de las ramas
-}
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 15 - Factorial
--------------------------------------------------------------------------------
factorial :: Integer -> Integer
factorial n | n==0      = 1
            | otherwise = n * factorial(n-1)
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 16 - División entera
--------------------------------------------------------------------------------
-- a)
divideA :: Integer -> Integer -> Bool
divideA a b = (b `mod` a == 0)
--------------------------------------------------------------------------------
-- b)
p1_divideA x y = (y /= 0) && (y `divideA` x) ==> div x y * y == x
-- dividendo = divisor * cociente + resto
--    x      =    y    * div x y  +   0
{-
*Main> quickCheck p1_divideA
+++ OK, passed 100 tests.
-}
--------------------------------------------------------------------------------
-- c)
p2_divideA x y z = (x /= 0) && (x `divideA` y) && (x `divideA` z) ==> x `divideA` (y+z)

{-
*Main> quickCheck p2_divideA
*** Gave up! Passed only 57 tests.
-}
-- Lo que indica que, aunque solo se generaron 57 casos de prueba con las condiciones precisas, todos pasaron la prueba.
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Ejercicio 17 - Mediana de una 5-tupla
--------------------------------------------------------------------------------
mediana :: Ord a => (a, a, a, a, a) -> a
mediana (x, y, z, t, u) | x>z       = mediana(z, y, x, t, u)
                        | y>z       = mediana(x, z, y, t, u)
                        | t<z       = mediana(x, y, t, z, u)
                        | u<z       = mediana(x, y, u, t, z)
                        | otherwise = z
--------------------------------------------------------------------------------

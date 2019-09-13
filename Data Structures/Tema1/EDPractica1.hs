-- Práctica 1
--
-- Alumno: Salvador CF
-------------------------------------------------------------------------------

import Test.QuickCheck

-------------------------------------------------------------------------------
-- Ejercicio 2 - intercambia
-------------------------------------------------------------------------------

intercambia :: (a,b) -> (b,a)
intercambia (x,y) = (y,x)

-------------------------------------------------------------------------------
-- Ejercicio 3 - ordena2 y ordena3
-------------------------------------------------------------------------------

-- 3.a
ordena2 :: Ord a => (a,a) -> (a,a)
ordena2 (x,y)
              | x > y = (y,x)
              | otherwise = (x,y)

p1_ordena2 x y = enOrden (ordena2 (x,y))
   where enOrden (x,y) = x <= y

p2_ordena2 x y = mismosElementos (x,y) (ordena2 (x,y))
   where
      mismosElementos (x,y) (x',y') =
           (x == x' && y == y') || (x == y' && y == x')

{-
*Main> quickCheck p1_ordena2
+++ OK, passed 100 tests.
*Main> quickCheck p2_ordena2
+++ OK, passed 100 tests.

-}

-- 3.b
ordena3 :: Ord a => (a,a,a) -> (a,a,a)
ordena3 (x, y, z)
                | x<y = ordena3 (z,x,y)
                | x<z = (y,x,z)
                | y<z = (y,z,x)
                | otherwise = (z,y,x)

-- 3.c
p1_ordena3 x y z = True ==> enOrden (ordena3 (x,y,z))
  where enOrden (x,y,z) = x<=y && y<=z

p2_ordena3 x y z = True ==> mismosElementos (x,y,z) (ordena3 (x,y,z))
  where
    mismosElementos (x,y,z) (u,v,w) = (x==u && y==v && z==w)
                                        || (x==u && y==w && z==v)
                                        || (x==v && y==u && z==w)
                                        || (x==v && y==w && z==u)
                                        || (x==w && y==v && z==u)
                                        || (x==w && y==u && z==v)

{-
*Main> quickCheck (p1_ordena3 :: Integer -> Integer -> Integer -> Property)
+++ OK, passed 100 tests.
*Main> quickCheck (p2_ordena3 :: Integer -> Integer -> Integer -> Property)
+++ OK, passed 100 tests.
-}

-------------------------------------------------------------------------------
-- Ejercicio 4 - max2
-------------------------------------------------------------------------------

-- 4.a
max2 :: Ord a => a -> a -> a
max2 x y
        | x>y = x
        | otherwise = y

-- 4.b
-- p1_max2: el máximo de dos números x e y coincide o bien con x o bien con y.

p1_max2 x y = True ==> (max2 x y == x) || (max2 x y == y)

-- p2_max2: el máximo de x e y es mayor o igual que x y mayor o igual que y.

p2_max2 x y = True ==> (max2 x y >= x) && (max2 x y >= y)

-- p3_max2: si x es mayor o igual que y, entonces el máximo de x e y es x.

p3_max2 x y = x>=y ==> max2 x y == x

-- p4_max2: si y es mayor o igual que x, entonces el máximo de x e y es y.

p4_max2 x y = y>=x ==> max2 x y == y

-------------------------------------------------------------------------------
-- Ejercicio 5 - entre (resuelto, se usa en el ejercicio 7)
-------------------------------------------------------------------------------

entre :: Ord a => a -> (a, a) -> Bool
entre x (inf,sup) = inf <= x && x <= sup

-------------------------------------------------------------------------------
-- Ejercicio 7 - descomponer
-------------------------------------------------------------------------------

-- Para este ejercicio nos interesa utilizar la función predefinida:
--
--              divMod :: Integral a => a -> a -> (a, a)
--
-- que calcula simultáneamente el cociente y el resto de la división entera:
--
--   *Main> divMod 30 7
--   (4,2)

-- 7.a
type TotalSegundos = Integer
type Horas         = Integer
type Minutos       = Integer
type Segundos      = Integer
descomponer :: TotalSegundos -> (Horas,Minutos,Segundos)
descomponer x = (horas, minutos, segundos)
   where
     horas = div x 3600
     minutos = div (mod x 3600) 60
     segundos = mod (mod x 3600) 60

-- 7.b
p_descomponer x = x>=0 ==> h*3600 + m*60 + s == x
                           && m `entre` (0,59)
                           && s `entre` (0,59)
                    where (h,m,s) = descomponer x

{-
*Main> quickCheck(p_descomponer)
+++ OK, passed 100 tests.
-}

-------------------------------------------------------------------------------
-- Ejercicio 14 - potencia
-------------------------------------------------------------------------------

-- 14.a
potencia :: Integer -> Integer -> Integer
potencia b 0 = 1
potencia b n = if n>=0  then b * potencia b (n-1) else error "Exponente negativo"

-- 14.b
potencia' :: Integer -> Integer -> Integer
potencia' x n
  | n == 0              =       1
  | even n         = potencia' x (div n 2) * potencia' x (div n 2)
  | otherwise       = x * potencia' x (div (n-1) 2) * potencia' x (div (n-1) 2)

-- 14.c
p_pot b n = n>=0 ==> potencia b n == sol
  && potencia' b n == sol
       where sol = b^n

{-
*Main> quickCheck p_pot
+++ OK, passed 100 tests.
-}

-- 14.d
{-

Para "potencia" el número de multiplicaciones coincide con n.
Para "potencia'" el número de multiplicaciones también coincide con n

-}

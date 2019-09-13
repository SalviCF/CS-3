import Test.QuickCheck
import Data.List

data Direction = North | South | East | West deriving Show

instance Eq Direction where
  North == North  = True
  South == South  = True
  East  == East   = True
  West  == West   = True
  _     == _      = False -- cualquier otra combinación será False (no hay más igualdades)

instance Ord Direction where
    North <= _      = True
    South <= North  = False
    South <= _      = True
    East  <= North  = False
    East  <= South  = False
    East  <= _      = True
    West  <= North  = False
    West  <= South  = False
    West  <= East   = False
    West  <= _      = True

sorted :: (Ord a) => [a] -> Bool
sorted [] = True
sorted [_] = True
sorted (x:xs@(y:_)) = (x<=y) && sorted xs -- xs se refiere a (y:_)

infix 4 ~=
(~=) :: Float -> Float -> Bool
x ~= y = abs(x-y) < 0.0001

-- Composición de funciones: (not . even) 3 es equivalente a not(even 3)


longitud :: [Integer] -> Integer
longitud ls = case ls of
                []    -> 0
                _:xs  -> 1 + longitud xs

{-
  Prelude> (not . even) 3
  True
  Prelude> not . even $ 3
  True
-}

fun :: Integer -> Integer -> Integer
fun x y = 2*x + y

f :: Integer -> Integer
f = fun 3 -- aplico parcialmente, la x queda fijada a 3 y yo proporciono la y

g :: Integer -> Integer
g = flip fun 3 -- ahora lo que queda fijado es la y, yo paso la x

-- fin

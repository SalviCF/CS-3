import Test.QuickCheck

maxi :: Integer -> Integer -> Integer
maxi x y = if x >= y then x else y

fact :: Integer -> Integer
fact x =  if x==0 then 1
          else x * fact(x-1)

doble :: Integer -> Integer
doble x = x+x

dobleSC :: (Num a) => a -> a
dobleSC x = x + x

antSig :: Integer -> (Integer, Integer)
antSig x = (x-1, x+1)

signo :: (Ord a, Num a) => a -> a  --al poner el "otherwise", le puedo quitar el Eq (ya no uso "==")
signo x | x > 0 = 1
        | x < 0 = -1
        | otherwise = 0

alCuadrado :: (Num a) => a -> a
alCuadrado x = x * x

{-Propiedad de "alCuadrado"-}
p1 x y = True ==> alCuadrado(x + y) == alCuadrado x + alCuadrado y + 2*x*y

{-Propiedad de "valor absoluto"-}
-- Esta no se verifica
-- p2 x y = True ==> abs(x + y) == abs x + abs y
p2 x y = x>=0 && y>=0 ==> abs(x + y) == abs x + abs y

sumaCurrificada :: Integer -> Integer -> Integer
sumaCurrificada x y = x+y

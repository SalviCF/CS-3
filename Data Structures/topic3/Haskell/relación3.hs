-- Alumno: Salvador CF
-- Relación de ejercicios 3

--------------------------------------------------------------------------------
-- Ejercicio 1:
{-
Escribe una función que permita determinar si una cadena de caracteres está bien
balanceada o equilibrada en lo que se refiere a los paréntesis, corchetes y
llaves que contiene.
-}
--------------------------------------------------------------------------------

module WellBalanced where

import qualified DataStructures.Stack.LinearStack as S    -- diapositiva 14
import Test.QuickCheck
import Data.Char

wellBalanced :: String -> Bool
wellBalanced xs = wellBalanced' xs S.empty

wellBalanced' :: String -> S.Stack Char -> Bool
wellBalanced' [] s = S.isEmpty s
wellBalanced' (x:xs) s
    | any (==x) "{[(" = wellBalanced' xs (S.push x s)
    | any (==x) "}])" = if (not $ S.isEmpty s && S.top s == apertura x) then wellBalanced' xs (S.pop s) else False
    | otherwise       = wellBalanced' xs s
    where apertura x  | (x=='}')  = '{'
                      | (x==']')  = '['
                      | otherwise = '('

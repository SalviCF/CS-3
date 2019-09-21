-------------------------------------------------------------------------------
-- Data Structures
-- Author: Salvi CF
-------------------------------------------------------------------------------

module DataStructures.Set.DisjointSet
                  ( DisjointSet
                  , empty
                  , isEmpty
                  , isElem
                  , numElements
                  , add
                  , root
                  , isRoot
                  , areConnected
                  , kind
                  , union
                  , flatten
                  , kinds
                  ) where

import           Data.List                               (intercalate)
import           Data.Maybe                              (fromJust)
import qualified DataStructures.Dictionary.AVLDictionary as D

data DisjointSet a = DS (D.Dictionary a a)

-- | Exercise 1. empty

empty :: DisjointSet a
empty = DS D.empty

-- | Exercise 2.a isEmpty

isEmpty :: DisjointSet a -> Bool
isEmpty (DS dic) = D.isEmpty dic

-- | Exercise 2.b isElem

isElem :: (Ord a) => a -> DisjointSet a -> Bool
isElem x (DS dic) = x `elem` D.keys dic

-- | Exercise 3. numElements

numElements :: DisjointSet a -> Int
numElements (DS dic) = D.size dic

-- | Exercise 4. add

add :: Ord a => a -> DisjointSet a -> DisjointSet a
add x ds@(DS dic) = DS (D.insert x x dic) -- no hace falta updateOrInsert

-- | Exercise 5. root

root :: Ord a => a -> DisjointSet a -> Maybe a
root x ds@(DS dic)  | (isEmpty ds) || (not $ isElem x ds) = Nothing
                    | (Just x == D.valueOf x dic) = Just x
                    | otherwise = root (fromJust $ D.valueOf x dic) ds


-- | Exercise 6. isRoot

isRoot :: Ord a => a -> DisjointSet a -> Bool
isRoot x ds@(DS dic) = (root x ds == Just x)


-- | Exercise 7. areConnected

areConnected :: Ord a => a -> a -> DisjointSet a -> Bool
areConnected x y ds@(DS dic)  | (not $ isElem x ds) || (not $ isElem y ds) = False
                              | otherwise = (rx == ry)
  where
    rx = fromJust $ root x ds
    ry = fromJust $ root y ds

-- | Exercise 8. kind

kind :: Ord a => a -> DisjointSet a -> [a]
kind x ds@(DS dic) = [ e | e <- D.keys dic, areConnected x e ds ]

-- | Exercise 9. union

union :: Ord a => a -> a -> DisjointSet a -> DisjointSet a
union x y ds@(DS dic) | (not $ isElem x ds) || (not $ isElem y ds) = error "union: missing element(s)"
                      | (rx < ry) = DS (D.insert ry rx dic)
                      | otherwise = DS (D.insert rx ry dic)
                      where
                        rx = fromJust $ root x ds
                        ry = fromJust $ root y ds

-- |------------------------------------------------------------------------

flatten :: Ord a => DisjointSet a -> DisjointSet a
flatten ds@(DS dic) = DS (D.foldKeysValues f z dic)
  where
    f k v acc = D.insert k (fromJust $ root k ds) acc
    z = D.empty

kinds :: Ord a => DisjointSet a -> [[a]]
kinds ds@(DS dic) = [ kind x ds | x <- D.keys dic, isRoot x ds ]

-- |------------------------------------------------------------------------

instance (Ord a, Show a) => Show (DisjointSet a) where
  show (DS d)  = "DictionaryDisjointSet(" ++ intercalate "," (map show (D.keysValues d)) ++ ")"


{-

-- Examples

-- | Exercise 1. empty

>>> empty
DictionaryDisjointSet()

-- | Exercise 2.a isEmpty

>>> isEmpty empty
True

>>> isEmpty (add 1 empty)
False

-- | Exercise 2.b isElem

>>> isElem 1 empty
False

>>> isElem 1 (add 1 empty)
True

>>> isElem 2 (add 1 empty)
False

>>> isElem 1 (add 2 (add 1 empty))
True

-- | Exercise 3. numElements

>>> numElements empty
0

>>> numElements (add 1 empty)
1

>>> numElements (add 2 (add 1 empty))
2

-- | Exercise 4. add

>>> add 1 empty
DictionaryDisjointSet((1,1))

>>> add 2 (add 1 empty)
DictionaryDisjointSet((1,1),(2,2))

>>> add 1 (add 2 (add 1 empty))
DictionaryDisjointSet((1,1),(2,2))

-- | Exercise 5. root

>>> root 1 empty
Nothing

>>> root 1 (add 1 empty)
Just 1

>>> root 2 (add 2 (add 1 empty))
Just 2

>>> root 1 (union 1 2 (add 2 (add 1 empty)))
Just 1

>>> root 2 (union 1 2 (add 2 (add 1 empty)))
Just 1

>>> root 1 (union 1 3 (add 3 (add 2 (add 1 empty))))
Just 1

>>> root 2 (union 1 3 (add 3 (add 2 (add 1 empty))))
Just 2

>>> root 3 (union 1 3 (add 3 (add 2 (add 1 empty))))
Just 1

>>> root 4 (union 1 3 (add 3 (add 2 (add 1 DisjointSet.empty))))
Nothing

-- | Exercise 6. isRoot

>>> isRoot 1 empty
False

>>> isRoot 1 (add 1 empty)
True

>>> isRoot 1 (union 1 2 (add 2 (add 1 empty)))
True

>>> isRoot 2 (union 1 2 (add 2 (add 1 empty)))
False

>>> isRoot 1 (union 1 3 (add 3 (add 2 (add 1 empty))))
True

>>> isRoot 2 (union 1 3 (add 3 (add 2 (add 1 empty))))
True

>>> isRoot 3 (union 1 3 (add 3 (add 2 (add 1 empty))))
False

-- | Exercise 7. areConnected

>>> areConnected 1 3 (union 1 3 (add 3 (add 2 (add 1 empty))))
True

>>> areConnected 3 1 (union 1 3 (add 3 (add 2 (add 1 empty))))
True

>>> areConnected 1 1 (union 1 3 (add 3 (add 2 (add 1 empty))))
True

>>> areConnected 1 2 (union 1 3 (add 3 (add 2 (add 1 empty))))
False

>>> areConnected 1 2 (union 2 3 (union 1 3 (add 3 (add 2 (add 1 empty)))))
True

>>> areConnected 1 5 (union 2 3 (union 1 3 (add 3 (add 2 (add 1 empty)))))
False

-- | Exercise 8. kind

>>> kind 1 (add 2 (add 1 empty))
[1]

>>> kind 2 (add 2 (add 1 empty))
[2]

>>> kind 3 (add 2 (add 1 empty))
[]

>>> kind 1 (union 1 3 (add 3 (add 2 (add 1 empty))))
[1,3]

>>> kind 3 (union 1 3 (add 3 (add 2 (add 1 empty))))
[1,3]

>>> kind 2 (union 1 3 (add 3 (add 2 (add 1 empty))))
[2]

>>> kind 2 (union 2 3 (union 1 3 (add 3 (add 2 (add 1 empty)))))
[1,2,3]

-- | Exercise 9. union

>>> union 1 2 (add 2 (add 1 empty))
DictionaryDisjointSet((1,1),(2,1))

>>> union 2 1 (add 2 (add 1 empty))
DictionaryDisjointSet((1,1),(2,1))

>>> union 1 1 (add 2 (add 1 empty))
DictionaryDisjointSet((1,1),(2,2))

>>> union 1 3 (add 3 (add 2 (add 1 empty)))
DictionaryDisjointSet((1,1),(2,2),(3,1))

>>> union 1 2 (add 1 empty)
*** Exception: union: missing element(s)
-}

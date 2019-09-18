-- | Data Structures
-- | Author: Salvi CF

module Huffman where

import qualified DataStructures.Dictionary.AVLDictionary as D
import qualified DataStructures.PriorityQueue.WBLeftistHeapPriorityQueue as PQ
import Data.List (nub)

-- | Exercise 1

weights :: Ord a => [a] -> D.Dictionary a Int
weights lista = foldr f z lista
  where
    f e acc = D.updateOrInsert e (+1) 1 acc
    z = D.empty

-- Otra posible solución
{-
weights :: Ord a => [a] -> D.Dictionary a Int
weights [] = D.empty
weights (x:xs) = D.updateOrInsert x (+1) 1 (weights xs)
-}

{-

> weights "abracadabra"
AVLDictionary('a'->5,'b'->2,'c'->1,'d'->1,'r'->2)

> weights [1,2,9,2,0,1,6,1,5,5,8]
AVLDictionary(0->1,1->3,2->2,5->2,6->1,8->1,9->1)

> weights ""
AVLDictionary()

-}


-- Implementation of Huffman Trees
data WLeafTree a = WLeaf a Int  -- Stored value (type a) and weight (type Int)
                 | WNode (WLeafTree a) (WLeafTree a) Int -- Left child, right child and weight
                 deriving (Eq, Show)

weight :: WLeafTree a -> Int
weight (WLeaf _ n)   = n
weight (WNode _ _ n) = n

-- Define order on trees according to their weights
instance Eq a => Ord (WLeafTree a) where
  wlt <= wlt' =  weight wlt <= weight wlt'

-- Build a new tree by joining two existing trees
merge :: WLeafTree a -> WLeafTree a -> WLeafTree a
merge wlt1 wlt2 = WNode wlt1 wlt2 (weight wlt1 + weight wlt2)


-- | Exercise 2

-- 2.a

huffmanLeaves :: String -> PQ.PQueue (WLeafTree Char)
huffmanLeaves cadena = D.foldKeysValues f z cadena'
  where
    cadena' = weights cadena    -- devuelve el diccionario
    f k v acc = PQ.enqueue (WLeaf k v) acc
    z = PQ.empty

-- Otra posible solución
{-
huffmanLeaves :: String -> PQ.PQueue (WLeafTree Char)
huffmanLeaves cadena = hl cadena'
  where
    hl [] = PQ.empty
    hl ((k,v):xs) = PQ.enqueue (WLeaf k v) (hl xs)
    cadena' = D.keysValues . weights $ cadena
-}

{-

> huffmanLeaves "abracadabra"
WBLeftistHeapPriorityQueue(WLeaf 'c' 1,WLeaf 'd' 1,WLeaf 'b' 2,WLeaf 'r' 2,WLeaf 'a' 5)

-}

-- 2.b
huffmanTree :: String -> WLeafTree Char
huffmanTree cadena = ht cola -- llamo con la cola de partida
  where
    ht q
      | (q == cola) && PQ.isEmpty (PQ.dequeue q) = error "huffmanTree: the string must have at least two different symbols"
      | PQ.isEmpty (PQ.dequeue q) = PQ.first q  -- cuando tiene un solo elemento, lo devuelvo
      | otherwise = ht (PQ.dequeue . PQ.dequeue . PQ.enqueue (mezcla q) $ q)  -- recursivamente, meto mezcla y extraigo los menores
    mezcla q' = merge (PQ.first q') (PQ.first . PQ.dequeue $ q') -- mezcla de los dos árboles de menor peso de q'
    cola      = huffmanLeaves cadena   -- obtiene la cola de partida (n árboles hoja)

{-

> printWLeafTree $ huffmanTree "abracadabra"
      11_______
      /        \
('a',5)        6_______________
              /                \
        ('r',2)          _______4
                        /       \
                       2        ('b',2)
                      / \
                ('c',1) ('d',1)

> printWLeafTree $ huffmanTree "abracadabra pata de cabra"
                         ______________________25_____________
                        /                                     \
         ______________10______                          ______15
        /                      \                        /       \
       4_______                6_______                6        ('a',9)
      /        \              /        \              / \
('d',2)        2        (' ',3)        3        ('b',3) ('r',3)
              / \                     / \
        ('e',1) ('p',1)         ('t',1) ('c',2)

> printWLeafTree $ huffmanTree "aaa"
*** Exception: huffmanTree: the string must have at least two different symbols

-}


-- | Exercise 3

-- 3.a
joinDics :: Ord a => D.Dictionary a b -> D.Dictionary a b -> D.Dictionary a b
joinDics d1 d2 = D.foldKeysValues f z d1
  where
    f e acc = D.insert e acc
    z = d2

-- Otra posible solución
{-
joinDics :: Ord a => D.Dictionary a b -> D.Dictionary a b -> D.Dictionary a b
joinDics d1 d2 = jd d1' d2
  where
    jd [] d2 = d2
    jd ((k, v):ks) d2 = D.insert k v (jd ks d2)
    d1' = D.keysValues d1
-}

{-

> joinDics (D.insert 'a' 1 $ D.insert 'c' 3 $ D.empty) D.empty
AVLDictionary('a'->1,'c'->3)

> joinDics (D.insert 'a' 1 $ D.insert 'c' 3 $ D.empty) (D.insert 'b' 2 $ D.insert 'd' 4 $ D.insert 'e' 5 $ D.empty)
AVLDictionary('a'->1,'b'->2,'c'->3,'d'->4,'e'->5)

-}

-- 3.b
prefixWith :: Ord a => b -> D.Dictionary a [b] -> D.Dictionary a [b]
prefixWith pre dict = D.foldKeysValues f z dict
  where
    f k vs acc = D.insert k (pre:vs) acc
    z = D.empty

-- Otra posible solución
{-
prefixWith :: Ord a => b -> D.Dictionary a [b] -> D.Dictionary a [b]
prefixWith pre dict = pw dict'
  where
    pw [] = D.empty
    pw ((k,v):ks) = D.insert k (pre:v) (pw ks)
    dict' = D.keysValues dict
-}

{-

> prefixWith 0 (D.insert 'a' [0,0,1] $ D.insert 'b' [1,0,0] $ D.empty)
AVLDictionary('a'->[0,0,0,1],'b'->[0,1,0,0])

> prefixWith 'h' (D.insert 1 "asta" $ D.insert 2 "echo" $ D.empty)
AVLDictionary(1->"hasta",2->"hecho")

-}

-- 3.c
huffmanCode :: WLeafTree Char -> D.Dictionary Char [Integer]
huffmanCode (WLeaf v p) = D.insert v [] D.empty
huffmanCode (WNode hi hd p) = joinDics (prefixWith 0 $ huffmanCode hi) (prefixWith 1 $ huffmanCode hd)

{-

> huffmanCode (huffmanTree "abracadabra")
AVLDictionary('a'->[0],'b'->[1,1,1],'c'->[1,1,0,0],'d'->[1,1,0,1],'r'->[1,0])

-}

-- ONLY for students not taking continuous assessment

-- | Exercise 4
encode :: String -> D.Dictionary Char [Integer] -> [Integer]
encode [] _ = []
encode (c:cs) dic = (valorDe c) ++ (encode cs dic)
  where
    valorDe x = concat [ snd kv | kv <- D.keysValues dic, x == fst kv ]


-- Otra posible solución
{-
encode :: String -> D.Dictionary Char [Integer] -> [Integer]
encode [] _ = []
encode (c:cs) dic = concat [ snd kv | kv <- kvs, c == fst kv ] ++ (encode cs dic)
  where
    kvs = D.keysValues dic
-}

-- Otra posible solución
{-
encode :: String -> D.Dictionary Char [Integer] -> [Integer]
encode [] _ = []
encode (c:cs) dic = (D.foldKeysValues f [] dic) ++ (encode cs dic)
  where
    f k v acc = if (k==c) then v else acc
-}

{-

> encode "abracadabra" (huffmanCode (huffmanTree "abracadabra"))
[0,1,1,1,1,0,0,1,1,0,0,0,1,1,0,1,0,1,1,1,1,0,0]

-}

-- | Exercise 5

-- 5.a
takeSymbol :: [Integer] -> WLeafTree Char -> (Char, [Integer])
takeSymbol bits (WLeaf v p) = (v, bits)
takeSymbol (0:bs) (WNode hi hd p) = takeSymbol bs hi
takeSymbol (1:bs) (WNode hi hd p) = takeSymbol bs hd

{-

> takeSymbol [0,1,1,1,1,0,0,1,1,0,0,0,1,1,0,1,0,1,1,1,1,0,0] (huffmanTree "abracadabra")
('a',[1,1,1,1,0,0,1,1,0,0,0,1,1,0,1,0,1,1,1,1,0,0])

> takeSymbol [1,1,1,1,0,0,1,1,0,0,0,1,1,0,1,0,1,1,1,1,0,0] (huffmanTree "abracadabra")
('b',[1,0,0,1,1,0,0,0,1,1,0,1,0,1,1,1,1,0,0])

-}

-- 5.b
decode :: [Integer] -> WLeafTree Char -> String
decode [] _ = []
decode code tree = symbol : (decode rest tree)
  where
    (symbol, rest) = (takeSymbol code tree)

{-

> decode [0,1,1,1,1,0,0,1,1,0,0,0,1,1,0,1,0,1,1,1,1,0,0] (huffmanTree "abracadabra")
"abracadabra"

-}

-------------------------------------------------------------------------------
-- Pretty Printing a WLeafTree
-- (adapted from http://stackoverflow.com/questions/1733311/pretty-print-a-tree)
-------------------------------------------------------------------------------

printWLeafTree :: (Show a) => WLeafTree a -> IO ()
printWLeafTree t = putStrLn (unlines xss)
 where
   (xss,_,_,_) = pprint t

pprint :: Show a => WLeafTree a -> ([String], Int, Int, Int)
pprint (WLeaf x we)             =  ([s], ls, 0, ls-1)
  where
    s = show (x,we)
    ls = length s
pprint (WNode lt rt we)         =  (resultLines, w, lw'-swl, totLW+1+swr)
  where
    nSpaces n = replicate n ' '
    nBars n = replicate n '_'
    -- compute info for string of this node's data
    s = show we
    sw = length s
    swl = div sw 2
    swr = div (sw-1) 2
    (lp,lw,_,lc) = pprint lt
    (rp,rw,rc,_) = pprint rt
    -- recurse
    (lw',lb) = if lw==0 then (1," ") else (lw,"/")
    (rw',rb) = if rw==0 then (1," ") else (rw,"\\")
    -- compute full width of this tree
    totLW = maximum [lw', swl,  1]
    totRW = maximum [rw', swr, 1]
    w = totLW + 1 + totRW
{-
A suggestive example:
     dddd | d | dddd__
        / |   |       \
      lll |   |       rr
          |   |      ...
          |   | rrrrrrrrrrr
     ----       ----           swl, swr (left/right string width (of this node) before any padding)
      ---       -----------    lw, rw   (left/right width (of subtree) before any padding)
     ----                      totLW
                -----------    totRW
     ----   -   -----------    w (total width)
-}
    -- get right column info that accounts for left side
    rc2 = totLW + 1 + rc
    -- make left and right tree same height
    llp = length lp
    lrp = length rp
    lp' = if llp < lrp then lp ++ replicate (lrp - llp) "" else lp
    rp' = if lrp < llp then rp ++ replicate (llp - lrp) "" else rp
    -- widen left and right trees if necessary (in case parent node is wider, and also to fix the 'added height')
    lp'' = map (\s -> if length s < totLW then nSpaces (totLW - length s) ++ s else s) lp'
    rp'' = map (\s -> if length s < totRW then s ++ nSpaces (totRW - length s) else s) rp'
    -- first part of line1
    line1 = if swl < lw' - lc - 1 then
                nSpaces (lc + 1) ++ nBars (lw' - lc - swl) ++ s
            else
                nSpaces (totLW - swl) ++ s
    -- line1 right bars
    lline1 = length line1
    line1' = if rc2 > lline1 then
                line1 ++ nBars (rc2 - lline1)
             else
                line1
    -- line1 right padding
    line1'' = line1' ++ nSpaces (w - length line1')
    -- first part of line2
    line2 = nSpaces (totLW - lw' + lc) ++ lb
    -- pad rest of left half
    line2' = line2 ++ nSpaces (totLW - length line2)
    -- add right content
    line2'' = line2' ++ " " ++ nSpaces rc ++ rb
    -- add right padding
    line2''' = line2'' ++ nSpaces (w - length line2'')
    resultLines = line1'' : line2''' : zipWith (\lt rt -> lt ++ " " ++ rt) lp'' rp''

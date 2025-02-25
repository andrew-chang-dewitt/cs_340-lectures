% CS 340: Programming Paradigms and Patterns
% Lect 06 - Recursion
% Michael Lee

\begin{code}
module Lect06 where
import Data.List (nub)
import Debug.Trace
import Data.Function.Memoize
\end{code}

Recursion
=========

Agenda:

- Common patterns of recursion:
  A. Iteration & Reduction
  B. Filtering
  C. Accumulation
  D. Combinations & Permutations
  E. Divide & Conquer
  F. Generative recursion


A. Iteration & Reduction (Processing elements one by one)

\begin{code}
-- sum up the elements of a list
sum' :: Num a => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum' xs

-- a classic!
factorial :: Integer -> Integer
factorial 0 = 1
factorial n = n * factorial (n-1)
\end{code}


B. Filtering (Selective iteration/reduction)

\begin{code}
-- sum only the positive numbers in a list
sumPositives :: Integral a => [a] -> a
sumPositives [] = 0
-- sumPositives (x:xs) | x > 0     = x + sumPositives xs
--                     | otherwise = sumPositives xs
sumPositives (x:xs) = (if x > 0 then x else 0) + sumPositives xs


-- palindroms are strings that read the same forwards as backwards
palindromes :: [String] -> [String]
palindromes [] = []
palindromes (s:ss) | s == reverse s = s : palindromes ss
                   | otherwise      = palindromes ss
-- palindromes (s:ss) = (if s == reverse s then (s:) else id) (palindromes ss)
\end{code}


C. Accumulation (Computing/Passing information "down" while recursing)

\begin{code}
-- reverse a list
reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]
-- reverse' [1,2,3]
-- = reverse' [2,3] ++ [1]
-- = (reverse' [3] ++ [2]) ++ [1]
-- = ((reverse' [] ++ [3]) ++ [2]) ++ [1]
-- = ([3] ++ [2]) ++ [1]
-- = [3, 2] ++ [1]
-- = [3, 2, 1]

-- problem: concatenating lists is expensive! can we avoid concatenation?

reverse'' :: [a] -> [a]
reverse'' xs = rev xs []
  where rev [] acc     = acc
        rev (y:ys) acc = rev ys (y:acc)
\end{code}


D. Combinations & Permutations (Essential combinatorics)

\begin{code}
-- generate all combinations of elements in a list (order doesn't matter)
combinations :: [a] -> [[a]]
combinations [] = [[]]
-- combinations [x] = [[x], []]
-- combinations [x,y] = [[x,y], [x], [y], []]
combinations (x:xs) = [ x:ys | ys <- combinations xs ] ++ combinations xs

-- knapsack problem: given a list of items (value,weight) and a weight 
--                   capacity, find the maximum value that can be carried
-- e.g., knapsack 10 [(60,6), (90,8), (50,2), (40,2)] = 150
knapsack :: (Ord a, Num a) => a -> [(a,a)] -> a
knapsack 0 _  = 0
knapsack _ [] = 0
knapsack w ((v1,w1):is)
  | w1 <= w   = max (v1 + knapsack (w-w1) is) (knapsack w is)
  | otherwise = knapsack w is

-- generate all permutations of elements in a list (order matters)
permutations :: [a] -> [[a]]
permutations [] = [[]]
-- permutations [x] = [[x]]
-- permutations [x,y] = [[x,y],[y,x]]
-- permutations [x,y,z] = [[x,y,z],[y,x,z],[y,z,x],
--                         [x,z,y],[z,x,y],[z,y,x]]
permutations (x:xs) = concat [ interleave x p | p <- permutations xs ]
  where interleave x [] = [[x]]
        interleave x (y:ys) = (x:y:ys) : [y:zs | zs <- interleave x ys]

-- generate all palindromes from a given string (use `nub` to remove dups)
allPalindromes :: String -> [String]
allPalindromes s = nub [ ws | ws <- permutations s, ws == reverse ws ]
\end{code}


E. Divide & Conquer (Break a problem into smaller ones of the same structure)

\begin{code}
-- another classic!
fib :: Int -> Integer
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)

-- problem: the above version is incredibly inefficient (lots of repeated
--          recursive calls). How can we optimize it?

fib' :: Int -> Integer
fib' n = memo !! n
  where
    memo = [fib i | i <- [0..]]
    fib 0 = 0
    fib 1 = 1
    fib i = memo !! (i - 1) + memo !! (i - 2)

fib'' :: Int -> Integer
fib'' = memoFix fib
  where
    fib f 0 = 0
    fib f 1 = 1
    fib f n = f (n-1) + f (n-2)

fib''' :: Int -> Integer
fib''' n = fib 0 1 n
  where
    fib x _ 0 = x
    fib x y n = fib y (x+y) (n-1)

-- sort by splitting the list in half and merging the sorted halves
mergesort :: Ord a => [a] -> [a]
mergesort [] = []
mergesort [x] = [x]
mergesort xs = merge (mergesort lhs) (mergesort rhs)
  where (lhs,rhs) = splitAt (length xs `div` 2) xs
        merge xs [] = xs
        merge [] ys = ys
        merge (x:xs) (y:ys)
          | x < y     = x : merge xs (y:ys)
          | otherwise = y : merge (x:xs) ys
\end{code}


F. Generative recursion (Generates new subproblems (in size/structure))

\begin{code}
-- Newton's method for finding square roots
-- 1. Start with a guess g -- for sqrt x, try g=x/2
-- 2. Is g^2 = x?
--    - if so, we're done
-- 3. Improve the guess; g'=(g + x/g)/2
--    (if g is too low this will increase it, and vice versa)
sqrt' :: Double -> Double
sqrt' x = newtons (x/2)
  where newtons g | goodEnough g = g
                  | otherwise    = newtons (improve g)
        goodEnough g = abs (g^2 - x) < 0.000001
        improve g = (g + x/g) / 2
\end{code}

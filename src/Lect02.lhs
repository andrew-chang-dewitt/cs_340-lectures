% CS 340: Programming Paradigms and Patterns
% Lect 02 - Types and Type Classes
% Michael Lee

> module Lect02 where
> import Data.Char 
> import Data.List

Types and Type Classes
======================

Agenda:
  - Types
  - Basic Types
  - Function types
  - Function application
  - Functions of multiple arguments
  - "Operators"
  - Polymorphic functions
  - Type Classes
  - Class constraints


Types
-----

- What is a *type*?

- How do we indicate the type of an expression in Haskell?

Basic types
-----------

  - Bool    - True/False
  - Char    - Unicode character
  - Int     - 64 bit signed integer
  - Integer - arbitrary-precision integer
  - Float   - 32-bit IEEE single-precision floating point number
  - Double  - 64-bit IEEE double-precision floating point number
  - Tuple   - finite (i.e., of a given arity) sequence of zero or more types

What are the types of the following?

    True
    'a'
    5
    1.5
    ('b', False, 'c')
    ()
    (True)
    (1, 2, 3, True)

Function types
--------------

- How would we describe a function in terms of types?

- How do we specify function types in Haskell?

What are the types of the following functions?

    not
    isDigit
    toUpper
    ord
    chr

Function application
--------------------

What is the syntax for function application in Haskell?

Functions of multiple arguments
-------------------------------

How about functions of multiple arguments?

E.g., interpret the following functions that map from a `Bool` and a `Char` to an `Int`:

    foo1 :: (Bool, Char) -> Int

    foo2 :: Bool -> (Char -> Int)

    foo3 :: Bool -> Char -> Int

Functions of multiple arguments in Haskell are "curried". 

  - What does this mean?

  - What does this say about the associativity of `->`?

  - What does this say about the associativity of function application?

  - What happens if we "partially apply" a function of multiple arguments?

    an example:

    given:
      `repeatStr :: Int -> String -> String` (aka `repeatStr :: Int -> ( String -> String )`)

    if we call this like `repeatStr 5`, what do we get?
        `(String -> String)`, a fn that takes a string and applies repeatStr w/ the first arg being 5 to it

Aside: what about:

    foo4 :: (Bool -> Char) -> Int

"Operators"
-----------

Operators are just functions whose names start with non-letters, and are used
(by default) in infix form (e.g., `13 + 25`)

  - You can ask for information about an operator's type at GHCi using `:i`

    - Also includes information about the precedence and associativity

    - Note: function application has the highest precedence!

  - Check out some operators:

        +
        *
        ^
        **
        &&
        ==
        /=

  - Operators can be used in prefix form if we put them in parentheses (try it!)

  - Functions can be used in infix form (try it with `mod` and `gcd`)


Polymorphic functions
---------------------

- What are polymorphic functions?

  ### An example: The identity fn

  Let's type `λx.x` in Haskell. Using concrete types gets tricky.
  Instead, we can use type variables to make our identity fn polymorphic:

    `identity :: a -> a`

  In this type signature for our `identity` fn, `a` is a type variable—an id that stands in for the type that's given.
  Our `identity` fn says give me anything, & I'll give you the same type back.
  This is called _parametric polymorphism_.

  Looking at this example, we can now answer the original question, "what are polymorphic functions?"
  As we saw, a polymorphic function is one that can be applied to any given argument type (assumint the argument type conforms to any constraints).

  | Aside: unconstrained/arbitrary type vars in Haskell
  | ---------------------------------------------------
  | in Haskell, there's no universal behavior that can be applied to all types, no matter what type.
  | looking again at our `identity :: a -> a` above, we never specified the definition.
  | naively, we might say that knowing only the type signature, it's possible that `identity` might
  | still modify the value of type `a`.
  | however, because haskell has no universal behavior, we can deduce that `(a -> a)` will always be
  | the idenity function as the only possible thing we can do with an unknown value is say, "here's
  | the value" (e.g. return it).
  | 
  | we can use this knowledge to conclude similar things about a function of the type `(a -> b -> a)`.
  | this unknown function has a new arg of unknown type `b`, yet we can still know that all we can
  | possibly get back is the value of the first arg of type `a`.

- What do their type declarations look like?

Check out these polymorphic functions? Can you guess what they do?
  
  - `id :: a -> a`
    the identity function
  - `const :: a -> b -> a`
    makes a function that always returns the value given first of type `a`.
    ex: `const True` returns a function of type `const True :: b -> Bool` that 
    always returns `True`.
  - `fst :: (a, b) -> a`
    returns the first element of a two tuple
  - `snd :: (a, b) -> b`
    returns the second element of a two tuple
  - `. :: (b -> c) -> (a -> b) -> a -> c`
    composes two functions of (b -> c) & (a -> b) & returns a function of a -> c; 
    e.g. given 
      A, B, C <- sets representing domains & ranges of functions
      g: B -> C
      h: A -> B
    then f can be defined as the composition of g & h like:
      f <- g . h
    giving us a new function that takes a value in A & returns a value in C
  - `flip :: (a -> b -> c) -> b -> a -> c`

The type declaration of a polymorphic function can give a lot of information about what the function does! (Why?)


Type Classes (aka Classes)
--------------------------

| Comparison to known things
| --------------------------
| These are the same idea (& behave in almost exactly the same way) as Rust's
| Traits. 
| (Similarly, the parametric polymorphic functions above are the same
| idea and behave in nearly the same way as Rust's Generics--only differing at
| runtime implementations since Haskell strips all types at runtime in parametric
| polymorphic functions, while Rust makes a new copy of each function for each
| type it's called on.)

- What is a type class?

- What information is specified by a type class?

Check out these classes and their methods:

    Eq
    Ord
    Num
    Enum
    Integral
    Bounded
    Show

Class constraints
-----------------

- What is a class constraint?

- Why are class constraints useful?

Inspect and explain the type declarations for:

    ^
    exp
    /=
    <
    fromIntegral
    read
    sort
    lookup

module State.Escapable
    ( StateRef,
      StateArray,
      EState,
      StateRef,
      liftToState,
      andThen,
      newRef,
      deRef,
      writeRef,
      newArray,
      arrayElement,
      writeArray,
      runState
      
    ) where

{-| A Library for escapable, mutable state,
similar to the ST type in Haskell.
Mutations are encapsulated using computation expressions,
which can be sequenced using `andThen`.
Side effects of the operations are encapsulated, and unlike promises,
results don't depend on external values.

Elm's type system isn't powerful enough to forbid returning of StateRefs,
so a runtime error occurs if runState is used on a computation
returning a StateRef.

This library should NOT be your first choice if you need memoization.
The `Array` module is more suitable for general purposes.
However, if you have code where in-place, fast memoization
is important, such as a dynamic-programming algorithm,
this module may provide performance benefits.

Example:

    testComp : S.EState ph String
    testComp = 
        S.newRef 3 `S.andThen` \myRef ->
        S.deRef myRef `andThen` \refVal ->
        S.writeRef myRef (refVal + 4) `S.andThen` \_pastVal ->
        S.deRef myRef

    seven :: Int
    seven = runState testComp

This will return 

# Base Types
@docs EState, StateRef

# Sequencing operations
@docs addToState, andThen

# Creating, Getting, Setting state
@docs newRef, deRef, writeRef

# Getting the value from a EState computation
@docs runState

-}



import Native.EState
import Debug

--Internal type, used by Native to store the mutable data
type InternalState ph = InternalState

{-| A reference to a value used within a computation.
-}
type StateRef ph a = StateRef

{-| A reference to an array used within a computation.
-}
type StateArray ph a = StateArray

{-| A computation storing state, with a resulting value a.
Here `ph` is a phantom type. Advances in Elm's type-system
may eventually prohibit the returning of StateRefs.  
-}
type EState ph a = EState ((InternalState ph) -> (InternalState ph, a))

{-| Given a value, wrap it in a state computation
-}
liftToState : a -> EState ph a
liftToState a = EState ( \s -> (s, a) )


{-| Sequence two stateful computations.
-}
andThen : EState ph a -> (a -> EState ph b) -> EState ph b
andThen (EState es) f = let
    ret = \s -> let
        (nextState, val) = es s
        (EState newES) = f val
      in (newES nextState)
  in EState ret

{-| Given an initial value, generate a new reference in the given computation.
-}
newRef : a -> EState ph (StateRef ph a)
newRef a = EState <| \s -> Native.EState.newRef (a,s)

{-| Get the value stored in a given reference.
-}
deRef : StateRef ph a -> EState ph a
deRef stateRef = EState <| \s -> Native.EState.deRef (stateRef, s)

{-| Given a reference and a value, overwrite the old value with the given one,
with the old value as the result of the computation 
-}
writeRef : StateRef ph a -> a -> EState ph a
writeRef stateRef newVal = EState <|  \s -> Native.EState.writeRef (stateRef, newVal, s)

{-| Given an initial value, and inclusive lower and upper bounds,
generate a new array in the given computation.
The initial value is stored in each element of the array.
-}
newArray : a -> (Int, Int) -> EState ph (StateArray ph a)
newArray a (lower, upper) = EState <| \s -> Native.EState.newArray (a, lower, upper, s)

{-| Get the value stored in a given index of an array.
-}
arrayElement : StateArray ph a -> Int -> EState ph a
arrayElement stateRef i = EState <| \s -> Native.EState.arrayElement (stateRef, i, s)

{-| Given a reference and a value, overwrite the old value with the given one,
with the old value as the result of the computation 
-}
writeArray : StateArray ph a -> a -> Int -> EState ph a
writeArray stateRef newVal i = EState <|  \s -> Native.EState.writeArray (stateRef, newVal, i, s) 

{-| Given a mutable state computation, extract its result
Throws a runtime error if a StateRef is ever the result.
-}
runState : EState ph a -> a
runState (EState es) = let
    ret = snd <| es (Native.EState.newState {})
  in case (Native.EState.checkIfIsRef ret) of
    False -> ret
    _ -> Debug.crash "Cannot return StateRef from runState"
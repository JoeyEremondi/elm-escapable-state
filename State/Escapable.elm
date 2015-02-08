module State.Escapable where

import Native.EState
import Debug

type StateArray ph = StateArray

type StateRef ph a = StateRef

type EState ph a = EState ((StateArray ph) -> (StateArray ph, a))


addToState : a -> EState ph a
addToState a = EState ( \s -> (s, a) )



andThen : EState ph a -> (a -> EState ph b) -> EState ph b
andThen (EState es) f = let
    ret = \s -> let
        (nextState, val) = es s
        (EState newES) = f val
      in (newES nextState)
  in EState ret

newRef : a -> EState ph (StateRef ph a)
newRef a = EState <| \s -> Native.EState.newRef (a,s)

deRef : StateRef ph a -> EState ph a
deRef stateRef = EState <| \s -> Native.EState.deRef (stateRef, s)

writeRef : StateRef ph a -> a -> EState ph {}
writeRef stateRef newVal = EState <|  \s -> Native.EState.writeRef (stateRef, newVal, s)

runState : EState ph a -> a
runState (EState es) = let
    ret = snd <| es (Native.EState.newState {})
  in case (Native.EState.checkIfIsRef ret) of
    False -> ret
    _ -> Debug.crash "Cannot return StateRef from runState"
# Escapable State in Elm

Intended to be similar to [ST](https://hackage.haskell.org/package/base-4.3.1.0/docs/Control-Monad-ST.html) in Haskell,
this library allows you to run computations with side-effects,
which are encapsulated.

The library uses Elm's standard technique of an `andThen`
function to sequence computations.

A usage example can be found in [Test.elm](https://github.com/JoeyEremondi/elm-escapable-state/blob/master/Test.elm)
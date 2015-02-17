# Escapable State in Elm

This package allows you to use mutation is a safe and localized way. There are
a few algorithms and data structures that rely crucially on mutation, such as
the [union-find data structure](http://en.wikipedia.org/wiki/Disjoint-set_data_structure),
and this package makes it possible to use them in a small part of your code without
infecting your *whole* codebase.

(If you have seen [ST](https://hackage.haskell.org/package/base-4.3.1.0/docs/Control-Monad-ST.html)
in Haskell, this should look similar.)

The library uses Elm's standard technique of an `andThen`
function to chain computations.

A usage example can be found in [Test.elm](https://github.com/JoeyEremondi/elm-escapable-state/blob/master/Test.elm)

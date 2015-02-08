import State.Escapable as S

import Text

testState : S.EState ph String
testState = 
    S.newRef "Hello" `S.andThen` \myRef ->
    S.writeRef myRef "Goodbye" `S.andThen` \_ ->
    S.deRef myRef

badCase : S.StateRef ph String
badCase = S.runState <| 
    S.newRef "Hello" `S.andThen` \myRef ->
    S.writeRef myRef "Goodbye" `S.andThen` \_ ->
    S.newRef ""

main = let
    _ = badCase
  in Text.plainText <| S.runState testState    
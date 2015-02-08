import State.Escapable as S

import Text

testState : S.EState ph String
testState = 
    S.newRef "Hello" `S.andThen` \myRef ->
    S.writeRef myRef "Goodbye" `S.andThen` \_ ->
    S.deRef myRef


main = Text.plainText <| S.runState testState    
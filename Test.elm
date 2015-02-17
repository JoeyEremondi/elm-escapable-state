import State.Escapable as S

import Text

testState : S.EState ph String
testState = 
    S.newRef "Hello" `S.andThen` \myRef ->
    S.writeRef myRef "Goodbye" `S.andThen` \_ ->
    S.deRef myRef

fillFibonacci : S.StateArray ph Int -> Int -> Int -> S.EState ph {}
fillFibonacci arr i n = if
    | i == 0 -> S.writeArray arr 1 0 `S.andThen` \_ ->
               if n > 0 then fillFibonacci arr 1 n else S.liftToState {}
    | i == 1 ->  S.writeArray arr 1 1 `S.andThen` \_ ->
               if n > 1 then fillFibonacci arr 2 n else S.liftToState {}
    | otherwise  -> S.arrayElement arr (i-1) `S.andThen` \f1 ->
                         S.arrayElement arr (i-2) `S.andThen` \f2 ->
                         S.writeArray arr (f1 + f2) i `S.andThen` \_ ->
                         if i < n then fillFibonacci arr (i+1) n else S.liftToState {}

fastFib : Int -> Int
fastFib n = S.runState <|
  S.newArray 0 (0,n) `S.andThen` \arr ->
  fillFibonacci arr 0 n `S.andThen` \_ ->
  S.arrayElement arr n


main = Text.asText <| fastFib 100   
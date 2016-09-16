module Game exposing (..)

import Data exposing (..)


updateClick : (Maybe Player -> Model) -> Model -> Model
updateClick update model =
    case model.state of
        Ongoing player ->
            procedeState player <| update <| Just player

        _ ->
            model


procedeState : Player -> Model -> Model
procedeState currentPlayer model =
    { model | state = Ongoing (nextPlayer currentPlayer) }

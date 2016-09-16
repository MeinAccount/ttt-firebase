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
    case getWinner model of
        Just winner ->
            { model | state = Won winner }

        Nothing ->
            if isDraw model then
                { model | state = Draw }
            else
                { model | state = Ongoing (nextPlayer currentPlayer) }



-- DETERMINING WINNERS


getWinner : Model -> Maybe Player
getWinner model =
    Maybe.oneOf
        [ getWinnerRow model.top
        , getWinnerRow model.center
        , getWinnerRow model.bottom
        , getWinnerColumn model .left
        , getWinnerColumn model .middle
        , getWinnerColumn model .right
        , getWinnerDiagonal model
        ]


getWinnerRow : Row -> Maybe Player
getWinnerRow row =
    findWinner row.left row.middle row.right


getWinnerColumn : Model -> (Row -> Maybe Player) -> Maybe Player
getWinnerColumn model access =
    findWinner (access model.top) (access model.center) (access model.bottom)


getWinnerDiagonal : Model -> Maybe Player
getWinnerDiagonal model =
    Maybe.oneOf
        [ findWinner model.top.left model.center.middle model.bottom.right
        , findWinner model.top.right model.center.middle model.bottom.left
        ]


findWinner : Maybe Player -> Maybe Player -> Maybe Player -> Maybe Player
findWinner a b c =
    case a of
        Just winner ->
            if a == b && a == c then
                Just winner
            else
                Nothing

        Nothing ->
            Nothing



-- DETECTING DRAWS


isDraw : Model -> Bool
isDraw model =
    isRowFull model.top && isRowFull model.center && isRowFull model.bottom


isRowFull : Row -> Bool
isRowFull row =
    isMaybe row.left && isMaybe row.middle && isMaybe row.right


isMaybe val =
    case val of
        Just _ ->
            True

        Nothing ->
            False

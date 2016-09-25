module Game
    exposing
        ( Player(..)
        , nextPlayer
        , GameState(..)
        , isDone
        , GameCoord
        , Game
        , newGame
        , insertCoord
        , updateState
        )

import Dict exposing (Dict)


type Player
    = Cross
    | Circle


nextPlayer : Player -> Player
nextPlayer player =
    case player of
        Cross ->
            Circle

        Circle ->
            Cross



-- GAME STATE


type GameState
    = Ongoing Player
    | Won Player
    | Draw


isDone : GameState -> Bool
isDone state =
    case state of
        Ongoing _ ->
            False

        _ ->
            True



-- GAME


type alias GameCoord =
    ( Int, Int )


type alias Game =
    { coords : Dict GameCoord Player
    , state : GameState
    }


newGame : Game
newGame =
    Game Dict.empty (Ongoing Cross)


insertCoord : GameCoord -> Game -> Game
insertCoord coord game =
    case game.state of
        Ongoing player ->
            updateState player <|
                { game | coords = Dict.insert coord player game.coords }

        _ ->
            game


updateState : Player -> Game -> Game
updateState player game =
    case getWinner game.coords of
        Just winner ->
            { game | state = Won winner }

        Nothing ->
            if isDraw game.coords then
                { game | state = Draw }
            else
                { game | state = Ongoing (nextPlayer player) }


getWinner : Dict GameCoord Player -> Maybe Player
getWinner coords =
    let
        check coord1 coord2 coord3 =
            Dict.get coord1 coords
                == Dict.get coord2 coords
                && Dict.get coord1 coords
                == Dict.get coord3 coords

        -- only allow the start of sequences
        filter ( x, y ) player =
            check ( x, y ) ( x + 1, y ) ( x + 2, y )
                || check ( x, y ) ( x, y + 1 ) ( x, y + 2 )
                || check ( x, y ) ( x + 1, y + 1 ) ( x + 2, y + 2 )
                || check ( x, y ) ( x - 1, y + 1 ) ( x - 2, y + 2 )
    in
        List.head <| Dict.values <| Dict.filter filter coords


isDraw : Dict GameCoord Player -> Bool
isDraw coords =
    Dict.size coords == 9

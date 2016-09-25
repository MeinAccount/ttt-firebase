port module StorageGame exposing (save, subscribe)

import Auth exposing (..)
import Dict exposing (Dict)
import Game exposing (..)


type alias GameCoordStore =
    { x : Int, y : Int, playerRaw : Bool }


type alias GameStore =
    { uid : Maybe String
    , coords : List GameCoordStore
    , nextPlayer : Maybe Bool
    }


port saveGame : GameStore -> Cmd msg


port updateGame : (GameStore -> msg) -> Sub msg


save : Maybe User -> Game -> Cmd msg
save user game =
    let
        coords =
            List.map conv <| Dict.toList game.coords

        conv ( ( x, y ), player ) =
            GameCoordStore x y (player == Cross)

        uid =
            Maybe.map .uid user
    in
        case game.state of
            Ongoing player ->
                saveGame <| GameStore uid coords (Just <| player == Cross)

            _ ->
                saveGame <| GameStore uid coords Nothing


subscribe : (Game -> msg) -> Sub msg
subscribe msg =
    let
        toGame { coords, nextPlayer } =
            let
                dict =
                    (Dict.fromList <| List.map parseCoord coords)
            in
                case nextPlayer of
                    Just playerRaw ->
                        Game dict (Ongoing <| boolToPlayer playerRaw)

                    _ ->
                        updateState Cross <|
                            Game dict Draw
    in
        updateGame (msg << toGame)


parseCoord : GameCoordStore -> ( GameCoord, Player )
parseCoord { x, y, playerRaw } =
    ( ( x, y ), boolToPlayer playerRaw )


boolToPlayer : Bool -> Player
boolToPlayer playerRaw =
    if playerRaw then
        Cross
    else
        Circle

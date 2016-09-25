port module StorageGame exposing (save, subscribe)

import Auth exposing (..)
import Dict exposing (Dict)
import Game exposing (..)


type alias GameCoordStore =
    { x : Int, y : Int, playerRaw : Bool }


type alias GameStore =
    { user : Maybe User
    , coords : List GameCoordStore
    , nextPlayer : Maybe Bool
    , won : Maybe Bool
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
    in
        case game.state of
            Ongoing player ->
                saveGame <| GameStore user coords (Just <| player == Cross) Nothing

            Won player ->
                saveGame <| GameStore user coords Nothing (Just <| player == Cross)

            Draw ->
                saveGame <| GameStore user coords Nothing Nothing


subscribe : (Game -> msg) -> Sub msg
subscribe msg =
    let
        toGame { coords, nextPlayer, won } =
            let
                state =
                    case ( nextPlayer, won ) of
                        ( Just playerRaw, _ ) ->
                            Ongoing (boolToPlayer playerRaw)

                        ( _, Just winnerRaw ) ->
                            Won (boolToPlayer winnerRaw)

                        _ ->
                            Draw
            in
                Game (Dict.fromList <| List.map parseCoord coords) state
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

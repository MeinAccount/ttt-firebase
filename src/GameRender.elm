module GameRender
    exposing
        ( viewGameState
        , viewGameBoard
        )

import Dict exposing (Dict)
import Game exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onDoubleClick)


viewGameState : Game -> msg -> Html msg
viewGameState model resetHandler =
    let
        attr =
            [ onDoubleClick resetHandler, class "center" ]
    in
        case model.state of
            Ongoing player ->
                h1 attr [ text <| "Next player: " ++ toString player ]

            Won player ->
                h1 attr [ text <| "Won: " ++ toString player ]

            Draw ->
                h1 attr [ text "Draw" ]


viewGameBoard : Game -> (GameCoord -> msg) -> Html msg
viewGameBoard game msg =
    let
        rows clickHandler =
            List.map (viewGameRow game.coords clickHandler) [1..3]
    in
        case isDone game.state of
            False ->
                table [ id "ttt" ] (rows <| Just msg)

            True ->
                table [ id "ttt", class "done" ] (rows Nothing)


viewGameRow : Dict GameCoord Player -> Maybe (GameCoord -> msg) -> Int -> Html msg
viewGameRow coords clickHandler row =
    let
        cell column =
            Maybe.withDefault (viewEmptyCell clickHandler ( row, column )) <|
                Maybe.map viewPlayerCell <|
                    Dict.get ( row, column ) coords
    in
        tr [] (List.map cell [1..3])


viewPlayerCell : Player -> Html msg
viewPlayerCell player =
    td [ class (toString player) ] []


viewEmptyCell : Maybe (GameCoord -> msg) -> GameCoord -> Html msg
viewEmptyCell clickHandler coord =
    case clickHandler of
        Just msg ->
            td [ onClick (msg coord), style [ ( "cursor", "pointer" ) ] ] []

        Nothing ->
            td [] []

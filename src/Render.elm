module Render exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onDoubleClick)
import Game exposing (..)


viewState : Table -> msg -> Html msg
viewState model handler =
    let
        attr =
            [ onDoubleClick handler ]
    in
        case model.state of
            Ongoing player ->
                h1 attr [ text <| "Next player: " ++ toString player ]

            Won player ->
                h1 attr [ text <| "Won: " ++ toString player ]

            Draw ->
                h1 attr [ text "Draw" ]


type alias Click =
    Maybe Player -> Table


viewTable : Table -> (Click -> msg) -> Html msg
viewTable model handler =
    let
        clickable =
            not (isDone model.state)
    in
        table [ id "ttt", classList [ ( "done", isDone model.state ) ] ]
            [ viewRow clickable model.top (\new -> { model | top = new }) handler
            , viewRow clickable model.center (\new -> { model | center = new }) handler
            , viewRow clickable model.bottom (\new -> { model | bottom = new }) handler
            ]


viewRow : Bool -> Row -> (Row -> Table) -> (Click -> msg) -> Html msg
viewRow clickable row update handler =
    let
        -- this should really use lenses!
        cell val update =
            viewCell clickable val (handler update)
    in
        tr []
            [ cell row.left (\new -> update { row | left = new })
            , cell row.middle (\new -> update { row | middle = new })
            , cell row.right (\new -> update { row | right = new })
            ]


viewCell : Bool -> Maybe Player -> msg -> Html msg
viewCell clickable val msg =
    case val of
        Just player ->
            td [ class (toString player) ] []

        Nothing ->
            if clickable then
                td [ onClick msg, style [ ( "cursor", "pointer" ) ] ] []
            else
                td [ onClick msg ] []

module GameSelection
    exposing
        ( ActiveGame(..)
        , viewGameSelect
        )

import Game exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type ActiveGame
    = LocalMP
    | LocalAI


viewGameSelect : ActiveGame -> (ActiveGame -> msg) -> Html msg
viewGameSelect activeGame msg =
    let
        attr game =
            [ onClick (msg game)
            , classList
                [ ( "collection-item", True )
                , ( "active", activeGame == game )
                ]
            ]
    in
        div [ class "collection" ]
            [ a (attr LocalMP) [ text "Lokal MP" ]
            , a (attr LocalAI) [ text "Lokal AI" ]
            ]

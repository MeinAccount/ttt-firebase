module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onDoubleClick)
import Data exposing (..)
import Game exposing (..)


main =
    App.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- UPDATE


type Msg
    = Click (Maybe Player -> Model)
    | Start


update : Msg -> Model -> Model
update msg model =
    case msg of
        Click update ->
            updateClick update model

        Start ->
            { model
                | top = emptyRow
                , center = emptyRow
                , bottom = emptyRow
                , state = Ongoing Cross
            }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewState model [ onDoubleClick Start ]
        , viewModel model
          -- , input [ type' "password", placeholder "Password", onInput Password ] []
        ]


viewState : Model -> List (Html.Attribute Msg) -> Html Msg
viewState model attr =
    case model.state of
        Ongoing player ->
            h1 attr [ text <| "Next player: " ++ toString player ]

        Won player ->
            h1 attr [ text <| "Won: " ++ toString player ]

        Draw ->
            h1 attr [ text "Draw" ]


viewModel : Model -> Html Msg
viewModel model =
    table [ classList [ ( "done", isDone model.state ) ] ]
        [ viewRow model.state model.top (\new -> { model | top = new })
        , viewRow model.state model.center (\new -> { model | center = new })
        , viewRow model.state model.bottom (\new -> { model | bottom = new })
        ]


viewRow : GameState -> Row -> (Row -> Model) -> Html Msg
viewRow state row update =
    let
        cell val update =
            viewCell state val (Click update)
    in
        tr []
            [ cell row.left (\new -> update { row | left = new })
            , cell row.middle (\new -> update { row | middle = new })
            , cell row.right (\new -> update { row | right = new })
            ]


viewCell : GameState -> Maybe Player -> Msg -> Html Msg
viewCell state val msg =
    case val of
        Just player ->
            td [ class (toString player) ] []

        Nothing ->
            case state of
                Ongoing _ ->
                    td [ onClick msg, style [ ( "cursor", "pointer" ) ] ] []

                _ ->
                    td [ onClick msg ] []

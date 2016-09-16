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
    table []
        [ viewRow model.top (\new -> { model | top = new })
        , viewRow model.center (\new -> { model | center = new })
        , viewRow model.bottom (\new -> { model | bottom = new })
        ]


viewRow : Row -> (Row -> Model) -> Html Msg
viewRow row update =
    tr []
        [ viewCell row.left <| Click (\new -> update { row | left = new })
        , viewCell row.middle <| Click (\new -> update { row | middle = new })
        , viewCell row.right <| Click (\new -> update { row | right = new })
        ]


viewCell : Maybe Player -> Msg -> Html Msg
viewCell val msg =
    case val of
        Nothing ->
            td [ onClick msg, style [ ( "cursor", "pointer" ) ] ] []

        Just player ->
            td [ class <| toString player ] []

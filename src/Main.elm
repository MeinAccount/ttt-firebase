module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onDoubleClick)
import Game exposing (..)


main =
    App.beginnerProgram
        { model = model
        , view = view
        , update = update
        }



-- MODEL


type alias Model =
    { top : Row
    , center : Row
    , bottom : Row
    , state : GameState
    , player : Player
    }


model : Model
model =
    Model emptyRow emptyRow emptyRow Ongoing Cross



-- UPDATE


type Msg
    = Click (Maybe Player -> Model)
    | Start


update : Msg -> Model -> Model
update msg model =
    case msg of
        Click update ->
            let
                newModel =
                    update <| Just model.player
            in
                { newModel | player = nextPlayer model.player }

        Start ->
            { model
                | top = emptyRow
                , center = emptyRow
                , bottom = emptyRow
                , state = Ongoing
                , player = Cross
            }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewState model [ onDoubleClick Start ]
        , viewTable model
          -- , input [ type' "password", placeholder "Password", onInput Password ] []
        ]


viewState : Model -> List (Html.Attribute Msg) -> Html Msg
viewState model attr =
    case model.state of
        Ongoing ->
            h1 attr [ text <| "Next player: " ++ toString model.player ]

        Won ->
            h1 attr [ text <| "Won: " ++ toString model.player ]

        Draw ->
            h1 attr [ text "Draw" ]


viewTable : Model -> Html Msg
viewTable model =
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

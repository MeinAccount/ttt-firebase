port module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Game exposing (..)
import Render exposing (..)
import Update exposing (..)


main =
    App.program
        { init = emptyModel ! [ bindClick True ]
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- GENERATED CONTENT EVENTS


port bindClick : Bool -> Cmd msg


port clickOverlay : (Bool -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    clickOverlay (always Start)



-- UPDATE


type Msg
    = Click (Maybe Player -> Model)
    | Start


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Click update ->
            updateClick update model ! [ Cmd.none ]

        Start ->
            { model
                | top = emptyRow
                , center = emptyRow
                , bottom = emptyRow
                , state = Ongoing Cross
            }
                ! [ bindClick True ]



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewState model Start
        , viewModel model Click
          -- , input [ type' "password", placeholder "Password", onInput Password ] []
        ]

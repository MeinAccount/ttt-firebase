port module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Auth exposing (..)
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
    Sub.batch
        [ clickOverlay (always ResetGame)
        , currentUser SetUser
        ]



-- MODEL


type alias Model =
    { table : Table
    , user : Maybe User
    }


emptyModel : Model
emptyModel =
    Model emptyTable Nothing



-- UPDATE


type Msg
    = ClickCell (Maybe Player -> Table)
    | AuthAction AuthMsg
    | SetUser (Maybe User)
    | ResetGame


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickCell update ->
            { model | table = updateClick update model.table } ! []

        AuthAction msg ->
            model ! [ authMsg (toString msg) ]

        SetUser user ->
            { model | user = user } ! []

        ResetGame ->
            { model | table = emptyTable }
                ! [ bindClick True ]



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ viewAuth model.user AuthAction
        , main' []
            [ div []
                [ viewState model.table ResetGame
                , viewTable model.table ClickCell
                ]
            ]
          -- , input [ type' "password", placeholder "Password", onInput Password ] []
        ]

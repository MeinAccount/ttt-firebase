port module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Auth exposing (..)
import Game exposing (..)
import Render exposing (..)
import Storage exposing (..)
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


type ActiveGame
    = LocalMP
    | LocalAI


type alias Model =
    { localMP : Table
    , localAI : Table
    , user : Maybe User
    , activeGame : ActiveGame
    }


emptyModel : Model
emptyModel =
    Model emptyTable emptyTable Nothing LocalMP



-- UPDATE


type Msg
    = ClickCell (Maybe Player -> Table)
    | AuthAction AuthMsg
    | SetUser (Maybe User)
    | SetActiveGame ActiveGame
    | ResetGame


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickCell update ->
            updateTable (updateClick update) model
                ! []

        AuthAction msg ->
            model ! [ authMsg (toString msg) ]

        SetUser user ->
            { model | user = user } ! []

        SetActiveGame activeGame ->
            { model | activeGame = activeGame } ! []

        ResetGame ->
            updateTable (always emptyTable) model
                ! [ bindClick True ]


getTable : Model -> Table
getTable model =
    case model.activeGame of
        LocalMP ->
            model.localMP

        LocalAI ->
            model.localAI


updateTable : (Table -> Table) -> Model -> Model
updateTable update model =
    case model.activeGame of
        LocalMP ->
            { model | localMP = update model.localMP }

        LocalAI ->
            { model | localAI = update model.localAI }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ aside []
            [ viewUser model.user
            , viewAuth model.user AuthAction
            , viewGameSelect model.activeGame
            ]
        , main' []
            [ viewState (getTable model) ResetGame
            , viewTable (getTable model) ClickCell
            ]
        ]


viewGameSelect : ActiveGame -> Html Msg
viewGameSelect activeGame =
    let
        attr game =
            [ onClick (SetActiveGame game)
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

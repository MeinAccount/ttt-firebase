port module Main exposing (..)

import Auth exposing (..)
import Dict exposing (Dict)
import Game exposing (..)
import GameRender exposing (..)
import GameSelection exposing (..)
import Html exposing (..)
import Html.App as App
import StorageGame as Store


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
        , Store.subscribe StoreLoad
        ]



-- MODEL


type alias Model =
    { localMP : Game
    , localAI : Game
    , user : Maybe User
    , activeGame : ActiveGame
    }


emptyModel : Model
emptyModel =
    Model newGame newGame Nothing LocalMP



-- UPDATE


type Msg
    = AuthAction AuthMsg
    | SetUser (Maybe User)
    | SetActiveGame ActiveGame
    | UpdateGame GameCoord
    | StoreLoad Game
    | ResetGame


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AuthAction msg ->
            model ! [ authMsg (toString msg) ]

        SetUser user ->
            { model | user = user } ! []

        SetActiveGame activeGame ->
            { model | activeGame = activeGame } ! []

        UpdateGame coord ->
            model
                ! [ Store.save model.user
                        (insertCoord coord <| getActiveGame model)
                  ]

        StoreLoad game ->
            { model | localMP = game }
                ! [ bindClick True ]

        ResetGame ->
            updateActiveGame (always newGame) model
                ! [ bindClick True ]


getActiveGame : Model -> Game
getActiveGame model =
    case model.activeGame of
        LocalMP ->
            model.localMP

        LocalAI ->
            model.localAI


updateActiveGame : (Game -> Game) -> Model -> Model
updateActiveGame update model =
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
            , viewGameSelect model.activeGame SetActiveGame
            ]
        , main' []
            [ viewGameState (getActiveGame model) ResetGame
            , viewGameBoard (getActiveGame model) UpdateGame
            ]
        ]

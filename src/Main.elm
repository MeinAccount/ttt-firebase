port module Main exposing (..)

import Auth exposing (..)
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
        [ clickOverlay (always ActiveGameReset)
        , currentUser AuthUser
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
    | AuthUser (Maybe User)
    | ActiveGameSelect ActiveGame
    | ActiveGamePlace GameCoord
    | ActiveGameReset
    | StoreLoad Game


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AuthAction msg ->
            model ! [ authMsg (toString msg) ]

        AuthUser user ->
            { model | user = user } ! []

        ActiveGameSelect activeGame ->
            { model | activeGame = activeGame } ! []

        ActiveGamePlace coord ->
            let
                game =
                    insertCoord coord <| getActiveGame model
            in
                case model.activeGame of
                    LocalMP ->
                        case model.user of
                            Just user ->
                                model ! [ Store.save user game ]

                            Nothing ->
                                { model | localMP = game } ! []

                    LocalAI ->
                        { model | localAI = game } ! []

        ActiveGameReset ->
            case model.activeGame of
                LocalMP ->
                    { model | localMP = newGame } ! [ bindClick True ]

                LocalAI ->
                    { model | localAI = newGame } ! [ bindClick True ]

        StoreLoad game ->
            { model | localMP = game } ! [ bindClick True ]


getActiveGame : Model -> Game
getActiveGame model =
    case model.activeGame of
        LocalMP ->
            model.localMP

        LocalAI ->
            model.localAI



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ aside []
            [ viewUser model.user
            , viewAuth model.user AuthAction
            , viewGameSelect model.activeGame ActiveGameSelect
            ]
        , main' []
            [ viewGameState (getActiveGame model) ActiveGameReset
            , viewGameBoard (getActiveGame model) ActiveGamePlace
            ]
        ]

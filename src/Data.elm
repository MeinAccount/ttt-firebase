module Data exposing (..)


type Player
    = Cross
    | Circle


nextPlayer : Player -> Player
nextPlayer player =
    case player of
        Cross ->
            Circle

        Circle ->
            Cross



-- GAME STATE


type GameState
    = Ongoing Player
    | Won Player
    | Draw



-- ROW


type alias Row =
    { left : Maybe Player
    , middle : Maybe Player
    , right : Maybe Player
    }


emptyRow : Row
emptyRow =
    Row Nothing Nothing Nothing



-- TABLE


type alias Model =
    { top : Row
    , center : Row
    , bottom : Row
    , state : GameState
    }


model : Model
model =
    Model emptyRow emptyRow emptyRow (Ongoing Cross)

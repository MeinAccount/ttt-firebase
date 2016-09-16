module Game exposing (..)


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
    = Ongoing
    | Won
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

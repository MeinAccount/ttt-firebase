port module Storage exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Game exposing (..)


type alias RowRaw =
    { left : Maybe Bool
    , middle : Maybe Bool
    , right : Maybe Bool
    }


type alias TableRaw =
    { top : RowRaw
    , center : RowRaw
    , bottom : RowRaw
    }


port storeTableRaw : TableRaw -> Cmd msg


storeTable : Table -> Cmd msg
storeTable table =
    let
        convert { left, middle, right } =
            { left = Maybe.map ((==) Cross) left
            , middle = Maybe.map ((==) Cross) middle
            , right = Maybe.map ((==) Cross) right
            }
    in
        storeTableRaw
            { top = convert table.top
            , center = convert table.center
            , bottom = convert table.bottom
            }

port module Auth exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)


type AuthMsg
    = SignInGoogle
    | SignOut


type alias User =
    { uid : String
    , displayName : String
    }


port authMsg : String -> Cmd msg


port currentUser : (Maybe User -> msg) -> Sub msg


viewUser : Maybe User -> Html msg
viewUser val =
    h4 [ class "center" ]
        [ text <| "Welcome " ++ Maybe.withDefault "Anonymus" (Maybe.map .displayName val) ]


viewAuth : Maybe User -> (AuthMsg -> msg) -> Html msg
viewAuth val handler =
    case val of
        Just user ->
            button [ onClick (handler SignOut), class "btn" ]
                [ text "Sign Out" ]

        Nothing ->
            button [ onClick (handler SignInGoogle), class "btn" ]
                [ text "Sign In" ]

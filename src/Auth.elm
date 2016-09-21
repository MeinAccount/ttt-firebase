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


viewAuth : Maybe User -> (AuthMsg -> msg) -> Html msg
viewAuth val handler =
    aside []
        [ h4 [ class "center" ]
            [ text <| "Welcome " ++ Maybe.withDefault "Anonymus" (Maybe.map .displayName val) ]
        , case val of
            Just user ->
                viewUser user (handler SignOut)

            Nothing ->
                viewLogin (handler SignInGoogle)
        ]


viewLogin : msg -> Html msg
viewLogin handler =
    div []
        [ button [ onClick handler, class "btn" ]
            [ text "Sign In" ]
        ]


viewUser : User -> msg -> Html msg
viewUser user handler =
    div []
        [ button [ onClick handler, class "btn" ]
            [ text "Sign Out" ]
        ]

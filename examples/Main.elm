module Main exposing (main)

import Html exposing (Html)
import Pluralize


main : Html msg
main =
    Html.text <| notificationMessage 5


notificationMessage : Int -> String
notificationMessage n =
    "Successfully deleted "
        ++ String.fromInt n
        ++ " "
        ++ Pluralize.pluralize n "message"

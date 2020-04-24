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
        -- The below results in "messages": not found in the Rules -> defaultPluralize!
        ++ Pluralize.pluralize n "message"
        ++ " from "
        ++ String.fromInt n
        ++ " "
        -- The below results in "queries": found in Rules!
        ++ Pluralize.pluralize n "query"

module Pluralize exposing (pluralize)

{-| An example of your custom-built module with a home-grown dictionary of words
you use that can't be pluralized using `defaultPluralize` (adding `"s"` to the
end of the word).
-}

import PluralRules exposing (Cardinal(..), Rules)
import PluralRules.En


rules : Rules
rules =
    PluralRules.fromList
        -- see the usage in Main; note the ommision of "message" here!
        [ ( "query"
          , [ ( One, "query" )
            , ( Other, "queries" )
            ]
          )
        ]


pluralize : Int -> String -> String
pluralize n word =
    PluralRules.En.pluralize rules n word

module Pluralize exposing (pluralize)

import PluralRules exposing (Cardinal(..), Rules)
import PluralRules.En


rules : Rules
rules =
    PluralRules.fromList
        [ ( "Query"
          , [ ( One, "Query" )
            , ( Other, "Queries" )
            ]
          )
        ]


pluralize : Int -> String -> String
pluralize n word =
    PluralRules.En.pluralize rules n word

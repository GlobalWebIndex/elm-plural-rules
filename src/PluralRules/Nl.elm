module PluralRules.Nl exposing (pluralize, pluralizeFloat)

{-| Dutch is simple wrt. pluralization: it has just 1 vs "not 1".
The main gimmick of this module is adding `"en"` to the word unless your provided
`Rules` dictionary says it should behave differently.


# Usage

Create your own dictionary of "non-s" pluralizations and a helper function that
provides that dictionary to the `pluralize` function. Here's an example (see also
the `examples/` folder):

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

@docs pluralize, pluralizeFloat

-}

import PluralRules exposing (Cardinal(..), Rules)


toCardinal : Float -> Cardinal
toCardinal float =
    if abs float == 1 then
        One

    else
        Other


{-| Dutch language has this nice default case, which greatly reduces the
number of words you'll have to add to your `Rules` dictionary.
-}
defaultPluralize : String -> String
defaultPluralize word =
    word ++ "en"


{-| Pluralization function for Dutch rules (adding `"en"` in the general case).

Make your own helper function that gives `pluralize` your rules, so that you
don't need to mention them every time!

(See the `examples/` folder.)

    myPluralize : Int -> String -> String
    myPluralize n word =
        PluralRules.Nl.pluralize rules n word

-}
pluralize : Rules -> Int -> String -> String
pluralize rules n word =
    PluralRules.fromInt
        { toCardinal = toCardinal
        , defaultPluralize = defaultPluralize
        }
        rules
        n
        word


{-| A `Float` variant of `pluralize`.
-}
pluralizeFloat : Rules -> Float -> String -> String
pluralizeFloat rules n word =
    PluralRules.fromFloat
        { toCardinal = toCardinal
        , defaultPluralize = defaultPluralize
        }
        rules
        n
        word

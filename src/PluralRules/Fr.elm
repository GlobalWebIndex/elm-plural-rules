module PluralRules.Fr exposing (pluralize, pluralizeFloat)

{-| French is simple wrt. pluralization: it has just 1 vs "not 1".
The main gimmick of this module is adding `"s"` to the word unless your provided
`Rules` dictionary says it should behave differently.


# Usage

Create a `Rules` dictionary and a helper function that provides that dictionary
to the `fromInt` function.

Over the course of development, as you add more usages of the `pluralize`
function, add those words into your `Rules` dictionary.

You can look at the `examples/` folder for the intended usage.

@docs pluralize, pluralizeFloat

-}

import PluralRules exposing (Cardinal(..), Rules)


toCardinal : Float -> Cardinal
toCardinal float =
    if abs float == 1 then
        One

    else
        Other


defaultPluralize : String -> String
defaultPluralize word =
    word ++ "s"


{-| Pluralization function for French rules (adding `"s"` in the general case).

Make your own helper function that gives `pluralize` your rules, so that you
don't need to mention them every time!

(See the `examples/` folder.)

    myPluralize : Int -> String -> String
    myPluralize n word =
        PluralRules.Fr.pluralize rules n word

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

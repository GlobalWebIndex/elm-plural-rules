module PluralRules.Fr exposing (pluralize, pluralizeFloat)

{-| French is simple wrt. pluralization: it has just 1 vs "not 1".

See En.Elm for a simple example, and Cz.Elm for a much more complete one.

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


pluralize : Rules -> Int -> String -> String
pluralize rules n word =
    PluralRules.fromInt
        { toCardinal = toCardinal
        , defaultPluralize = defaultPluralize
        }
        rules
        n
        word


pluralizeFloat : Rules -> Float -> String -> String
pluralizeFloat rules n word =
    PluralRules.fromFloat
        { toCardinal = toCardinal
        , defaultPluralize = defaultPluralize
        }
        rules
        n
        word

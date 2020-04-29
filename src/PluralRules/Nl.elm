module PluralRules.Nl exposing (pluralize, pluralizeFloat)

import PluralRules exposing (Cardinal(..), Rules)


{-| Dutch is simple wrt. pluralization: it has just 1 vs "not 1".

See En.Elm for a simple example, and Cz.Elm for a much more complete one.

-}
toCardinal : Float -> Cardinal
toCardinal float =
    if abs float == 1 then
        One

    else
        Other


defaultPluralize : String -> String
defaultPluralize word =
    word ++ "en"


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

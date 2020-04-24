module PluralRules.Cz exposing (pluralize, pluralizeFloat)

{-| Czech is not so simple wrt. pluralization compared to English: it uses
almost the whole gamut of Cardinals. So our `defaultPluralize` function is just
`identity` and instead we rely on all pluralized words being present in the
`Rules` dictionary.

The `toCardinal` function in this module is doing much more than in the English
module, as the rules are more complex.


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
    let
        { integerDigits, hasFractionDigits } =
            PluralRules.operands float
    in
    if integerDigits == 1 && not hasFractionDigits then
        One

    else if integerDigits >= 2 && integerDigits <= 4 && not hasFractionDigits then
        Few

    else if hasFractionDigits then
        Many

    else
        Other


{-| There is no default case in Czech language (no common suffix), we declense
words instead.

All the words used will have to be written in the `Rules` dictionary instead.

-}
defaultPluralize : String -> String
defaultPluralize word =
    word


{-| Pluralization function for Czech rules (doing nothing in the general case).

Make your own helper function that gives `pluralize` your rules, so that you
don't need to mention them every time!

(See the `examples/` folder.)

    myPluralize : Int -> String -> String
    myPluralize n word =
        PluralRules.Cz.pluralize rules n word

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

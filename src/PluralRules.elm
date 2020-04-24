module PluralRules exposing
    ( Rules, empty, fromList, add
    , Cardinal(..)
    , fromInt, fromFloat
    , Operands, operands
    )

{-| Abstraction for working with pluralization rules.

Check [Unicode Language Plural
Rules](https://unicode-org.github.io/cldr-staging/charts/37/supplemental/language_plural_rules.html)
for more information and examples for various languages.

![Screenshot of English
rules](https://github.com/GlobalWebIndex/elm-plural-rules/raw/master/doc/en.png)

![Screenshot of Czech
rules](https://github.com/GlobalWebIndex/elm-plural-rules/raw/master/doc/cz.png)


# Rules

@docs Rules, empty, fromList, add


# Cardinals

@docs Cardinal


# Pluralization

@docs fromInt, fromFloat


# Plural Operands

When implementing the `toCardinal` function you'll likely reference the table of
[Plural Rules](https://unicode-org.github.io/cldr-staging/charts/37/supplemental/language_plural_rules.html#rules)
for your language.

The rules have conditions like `i = 2..4 and v = 0`. See the
[Plural Operand Meanings
table](http://unicode.org/reports/tr35/tr35-numbers.html#Operands) or below for
description of these.

@docs Operands, operands

-}

import Dict exposing (Dict)
import Dict.Any exposing (AnyDict)


{-| Rules are a dictionary with various plural forms of words in your given
language.

Elsewhere you can supply a function giving the default case (in English
that's adding a `-s` suffix), but here in `Rules` you'll have to supply the
"exceptions" (like words that add an `-es` suffix instead).

For an example see `fromList`.

-}
type Rules
    = Rules (Dict String (AnyDict Int Cardinal String))


{-| Create Rules from a list of given exceptions to the general rule.

    fromList
        [ ( "Query"
          , [ ( One, "Query" )
            , ( Other, "Queries" )
            ]
          )
        ]

You can imagine more complicated rules in other languages:

    -- Czech rules
    fromList
        [ ( "muž"
          , [ ( One, "muž" ) -- 1, no decimal digits
            , ( Few, "muži" ) -- 2..4, no decimal digits
            , ( Many, "muže" ) -- with decimal digits
            , ( Other, "mužů" ) -- the rest
            ]
          )
        ]

-}
fromList : List ( String, List ( Cardinal, String ) ) -> Rules
fromList list =
    List.foldl
        (\( item, forms ) acc -> add item forms acc)
        empty
        list


{-| Initialize empty Rules.
-}
empty : Rules
empty =
    Rules Dict.empty


{-| Add rules for a new word.

Behaves like `Dict.insert` in case of collisions: replaces the previous value in
`Rules` with the new value.

-}
add : String -> List ( Cardinal, String ) -> Rules -> Rules
add word xs (Rules dict) =
    Rules <|
        Dict.insert
            word
            (Dict.Any.fromList toComparable xs)
            dict


{-| Each language will have its own rules for when to use which cardinal.

Check [Unicode Language Plural
Rules](https://unicode-org.github.io/cldr-staging/charts/37/supplemental/language_plural_rules.html)
for more information and examples for various languages.

-}
type Cardinal
    = Zero
    | One
    | Two
    | Few
    | Many
    | Other


toComparable : Cardinal -> Int
toComparable cardinal =
    case cardinal of
        Zero ->
            0

        One ->
            1

        Two ->
            2

        Few ->
            3

        Many ->
            4

        Other ->
            5


{-| Integer-specialized pluralization function. For more info see `fromFloat`.
-}
fromInt :
    { toCardinal : Float -> Cardinal
    , defaultPluralize : String -> String
    }
    -> Rules
    -> Int
    -> String
    -> String
fromInt config rules num word =
    fromFloat config rules (toFloat num) word


{-| Pluralize a single word.

This is the most general case; the goal is to define and use a partially applied
"homegrown" variant that will apply the configuration and rules and end up with
a function of signature `pluralize : Int -> String -> String`:

    pluralize 5 "word"
    --> "words"

    pluralize 5 "query"
    --> "queries" if you supplied the cases for "query" in the Rules dictionary
    --> "querys" otherwise, as the default rule would fire!

The `defaultPluralize` function is a helper for minimizing the amount of `Rules`
you'll have to write -- it is used when a word or its cardinal isn't found in
`Rules`.

  - This is notably useful for English where most words have the `-s`
    suffix in their plural form; you then have to supply just the "irregular" words
    like `query -> queries`, `index -> indices`, etc.

  - It's admittedly less useful for some other languages like Czech where there is
    no simple default case. In these cases you can supply
    `defaultPluralize = identity` and instead make sure that all the words you're
    pluralizing are found in your `Rules` dictionary.

The `toCardinal` function implements the rules from [Unicode Language Plural
Rules](https://unicode-org.github.io/cldr-staging/charts/37/supplemental/language_plural_rules.html)
for which quantities result in which cardinal. Your `Rules` dictionary can then
just supply a word for each relevant cardinal, for cases where
`defaultPluralize` isn't enough.

-}
fromFloat :
    { toCardinal : Float -> Cardinal
    , defaultPluralize : String -> String
    }
    -> Rules
    -> Float
    -> String
    -> String
fromFloat { toCardinal, defaultPluralize } (Rules dict) num word =
    Dict.get word dict
        |> Maybe.andThen (Dict.Any.get (toCardinal num))
        |> Maybe.withDefault
            (if abs num == 1 then
                word

             else
                defaultPluralize word
            )


{-| Taken from [Plural Operand
Meanings](http://unicode.org/reports/tr35/tr35-numbers.html#Operands).

  - n = absolute value of the source number (integer and decimals)
  - i = integer digits of n
  - v = number of visible fraction digits in n, with trailing zeros
  - w = number of visible fraction digits in n, without trailing zeros
  - f = visible fractional digits in n, with trailing zeros
  - t = visible fractional digits in n, without trailing zeros

Note that `v,w,f,t` are quite problematic because of `Float` behaviour, at least
when not dealing with simple `!= 0`. As the package authors didn't need to deal
with those problematic rules, we're currently keeping only what we can guarantee:
notably `hasFractionDigits == v != 0`.

If you, when implementing `toCardinal` for your language, need those `v,w,f,t`
operands, shoot us a GitHub issue, we can likely create something working on
`String`s which would likely work without bugs. Of course, then the question is
how you get the input strings. Probably by takin raw strings from input
elements?

-}
type alias Operands =
    { absoluteValue : Float
    , integerDigits : Int
    , hasFractionDigits : Bool
    }


{-| Compute operands from a `Float` number.
-}
operands : Float -> Operands
operands float =
    let
        absoluteValue =
            abs float

        integerDigits =
            truncate absoluteValue
    in
    { absoluteValue = absoluteValue
    , integerDigits = integerDigits
    , hasFractionDigits = absoluteValue /= toFloat integerDigits
    }

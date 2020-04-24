module PluralRulesTest exposing (cz, en, fromFloatInt, operands)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import PluralRules exposing (Cardinal(..), Operands, Rules)
import PluralRules.Cz
import PluralRules.En
import Test exposing (..)


operands : Test
operands =
    let
        run : Float -> Operands -> Test
        run float operands_ =
            test (String.fromFloat float) <|
                \() ->
                    PluralRules.operands float
                        |> Expect.equal operands_
    in
    describe "PluralRules.operands"
        [ fuzz Fuzz.float "Doesn't care about minus sign" <|
            \float ->
                PluralRules.operands float
                    |> Expect.equal (PluralRules.operands (abs float))
        , run 1 <| Operands 1 1 False
        , run 1.4 <| Operands 1.4 1 True
        , run -1.04 <| Operands 1.04 1 True
        , run 5.24 <| Operands 5.24 5 True
        ]


fromFloatInt : Test
fromFloatInt =
    let
        config =
            { toCardinal = always Other
            , defaultPluralize = identity
            }
    in
    describe "PluralRules.fromFloat, fromInt"
        [ fuzz2 Fuzz.int Fuzz.string "`fromInt` does same thing as `fromFloat`" <|
            \int string ->
                PluralRules.fromInt config PluralRules.empty int string
                    |> Expect.equal (PluralRules.fromFloat config PluralRules.empty (toFloat int) string)
        ]


rulesWithQuery : Rules
rulesWithQuery =
    PluralRules.add
        "query"
        [ ( One, "query" )
        , ( Other, "queries" )
        ]
        PluralRules.empty


en : Test
en =
    describe "PluralRules.En.pluralize"
        [ test "query -> query if n == 1" <|
            \() ->
                PluralRules.En.pluralize PluralRules.empty 1 "query"
                    |> Expect.equal "query"
        , test "query -> query if n == -1" <|
            \() ->
                PluralRules.En.pluralize PluralRules.empty -1 "query"
                    |> Expect.equal "query"
        , test "query -> queries if rules contain query" <|
            \() ->
                PluralRules.En.pluralize rulesWithQuery 5 "query"
                    |> Expect.equal "queries"
        , test "query -> querys if empty rules" <|
            \() ->
                PluralRules.En.pluralize PluralRules.empty 5 "query"
                    |> Expect.equal "querys"
        ]


rulesWithMuz : Rules
rulesWithMuz =
    PluralRules.add
        "muž"
        [ ( One, "muž" )
        , ( Few, "muži" )
        , ( Many, "muže" )
        , ( Other, "mužů" )
        ]
        PluralRules.empty


cz : Test
cz =
    describe "PluralRules.Cz.pluralize"
        [ test "no default pluralizing" <|
            \() ->
                PluralRules.Cz.pluralize PluralRules.empty 2 "muž"
                    |> Expect.equal "muž"
        , test "0x muz -> muzu" <|
            \() ->
                PluralRules.Cz.pluralize rulesWithMuz 0 "muž"
                    |> Expect.equal "mužů"
        , test "1x muz -> muz" <|
            \() ->
                PluralRules.Cz.pluralize rulesWithMuz 1 "muž"
                    |> Expect.equal "muž"
        , test "2x muz -> muzi" <|
            \() ->
                PluralRules.Cz.pluralize rulesWithMuz 2 "muž"
                    |> Expect.equal "muži"
        , test "3x muz -> muzi" <|
            \() ->
                PluralRules.Cz.pluralize rulesWithMuz 3 "muž"
                    |> Expect.equal "muži"
        , test "4x muz -> muzi" <|
            \() ->
                PluralRules.Cz.pluralize rulesWithMuz 4 "muž"
                    |> Expect.equal "muži"
        , test "5x muz -> muzu" <|
            \() ->
                PluralRules.Cz.pluralize rulesWithMuz 5 "muž"
                    |> Expect.equal "mužů"
        , test "1.5x muz -> muze" <|
            \() ->
                PluralRules.Cz.pluralizeFloat rulesWithMuz 1.5 "muž"
                    |> Expect.equal "muže"
        ]

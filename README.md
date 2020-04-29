# `GlobalWebIndex/elm-plural-rules`

An abstraction for working with pluralization rules.

Based largely on [Unicode Language Plural
Rules](https://unicode-org.github.io/cldr-staging/charts/37/supplemental/language_plural_rules.html).

![Screenshot of English
rules](https://github.com/GlobalWebIndex/elm-plural-rules/raw/master/docs/en.png)

![Screenshot of Czech
rules](https://github.com/GlobalWebIndex/elm-plural-rules/raw/master/docs/cz.png)

![Screenshot of French
rules](https://github.com/GlobalWebIndex/elm-plural-rules/raw/master/docs/fr.png)

(For the description of what the `v = 0` conditions in the above screenshots
mean, look at the [Plural Operand Meanings](http://unicode.org/reports/tr35/tr35-numbers.html#Operands)
table or check the `Plural Operands` section of the `PluralRules` module!)

----

This library helps you arrive at an API like:

```elm
pluralize 1 "message" --> "message"
pluralize 5 "message" --> "messages"

pluralize 1 "man" --> "man"
pluralize 5 "man" --> "men"

pluralize 1 "query" --> "query"
pluralize 5 "query" --> "queries"
```

See the `examples/` folder for how to get there!

There are also helpers for writing pluralization logic for languages not
included in this package. Obviously, there's a lot of languages and each of
those has its own rules for how it pluralizes. Check them
[here!](https://unicode-org.github.io/cldr-staging/charts/37/supplemental/language_plural_rules.html)

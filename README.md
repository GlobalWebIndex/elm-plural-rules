# `GlobalWebIndex/elm-plural-rules`

An abstraction for working with pluralization rules.

Based largely on [Unicode Language Plural
Rules](https://unicode-org.github.io/cldr-staging/charts/37/supplemental/language_plural_rules.html).

![Screenshot of English
rules](https://github.com/GlobalWebIndex/elm-plural-rules/raw/master/docs/en.png)

![Screenshot of Czech
rules](https://github.com/GlobalWebIndex/elm-plural-rules/raw/master/docs/cz.png)

----

This library helps you arrive at this API

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

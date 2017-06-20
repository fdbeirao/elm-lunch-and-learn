# Lunch and Learn - ELM (Day 2)

Today we'll look at some of examples provided by [ELM's official website][ELM Examples]

We will not cover the most basic examples, such as [hello world][Hello World ELM Example], [math][Math ELM Example], [strings][Strings ELM Example], [calling functions][Calling Functions ELM Example], [defining functions][Defining Functions ELM Example], [if][If ELM Example], [let][Let ELM Example], [case][Case ELM Example], [lambda][Lambda ELM Example].


## Unordered list example


The [unordered list example][Unordered List ELM Example] is simple enough for us to get acquainted with the way we represent HTML in ELM. The goal in this example is to represent the following HTML:

```HTML
<ul class="grocery-list">
  <li>Pamplemousse</li>
  <li>Ananas</li>
  <li>Jus d'orange</li>
  <li>Boeuf</li>
  <li>Soupe du jour</li>
  <li>Camembert</li>
  <li>Jacques Cousteau</li>
  <li>Baguette</li>
</ul>
```

If we look closely at the `<ul>` element in this representation, we see that it has two components: a list of attributes and a list of sub-elements. This is true for nearly every HTML element. In ELM, everything is a pure function. This means that even the intention to represent HTML elements needs to be pure. ELM has the [`Html` package][ELM HTML Package], which exposes pure functions for almost every well-known HTML element. In the representation above we are interested in `ul`, `li` and `text`. The signatures for [`ul`][ELM HTML ul function] and [`li`][ELM HTML li function] follow the same pattern as above:

```elm
ul : List (Attribute msg) -> List (Html msg) -> Html msg

li : List (Attribute msg) -> List (Html msg) -> Html msg
```

[`text`][ELM HTML text function], because it doesn't have attributes nor child elements, has a simpler signature:

```elm
text : String -> Html msg
```

In this examples, the `main` function is used as the "`view` function" because there is no need of interaction with the user.


## Union types: either

The [`union types: either`][Union Types Either ELM Example] is using different interesting features of ELM and functional languages in general, such as union types, pattern matching and recursion.

Let's first look into union types.

In this example, the following union type is used:

```elm
type Either a b
    = Left a
    | Right b
```

Several things are going on here. `a` and `b` are type variables. Using `Either Int String` is the same as having this:

```elm
type Either
    = Left Int
    | Right String
```

`Either` is a name that we specify, just like `Left` and `Right`. We could have a union type such as:

```elm
type OneOf
    = Number Int
    | Sentence String
    | Logic Bool
```

`Left`, `Right`, `Number`, `Sentence`, `Logic` are constructors of the `Either` or `OneOf` type. These constructors can be **pattern matched**. Let's see a simple example of pattern matching (inside `toText` function):

```elm
module Main exposing (main)

import Html


type OneOf
    = Number Int
    | Sentence String


toText : OneOf -> String
toText val =
    case val of
        Number numberPayload ->
            toString numberPayload

        Sentence stringPayload ->
            stringPayload


main =
    Html.ul []
        [ Html.li [] [ Html.text (toText (Number 20)) ]
        , Html.li [] [ Html.text (toText (Sentence "Hello there!")) ]
        ]
```

We are using **pattern matching** inside the [`case`][ELM Syntax] construct. `case` will *deconstruct* `val` (which our function's signature defined as being of type `OneOf`) and it will require you to implement all possible branches declared by `OneOf`. Notice that when the constructor pattern matches, the payloads associated with the type constructor are assigned to the variable(s) we define after the pattern match (`numberPayload` or `stringPayload`). We are then able to use the values inside these variables on the body of the pattern matched case statement.


Getting back to the original example, the second thing that it is doing is recursion (in function `partition`).

Recursion is necessary in functional languages due to the nature of immutability. If you cannot change anything in place, all you can do is call "another function" with some transformation on an input of yours. Sometimes, this "another function" is yourself.

Let's have a look into `partition`:

```elm
partition : List (Either a b) -> (List a, List b)
partition eithers =
  case eithers of
    [] ->
      ([], [])

    Left a :: rest ->
      let
        (lefts, rights) =
          partition rest
      in
        (a :: lefts, rights)

    Right b :: rest ->
      let
        (lefts, rights) =
          partition rest
      in
        (lefts, b :: rights)
```

We can start by its signature. It receives as input a `List` of things that are `Either a b`. We have seen above the implementation of `Either a b`. `partition` will return a [tuple][ELM Syntax] with two values: a `List a` and a `List b`. Keep in mind that we do not really care what `a` and `b` are, as long as they are the same on the inputs and the output of `partition`. This means that if partition is called with `Either Int String`, it will behave as `partition : List (Either Int String) -> (List Int, List String)`.

The very first thing that `partition` does is assign its input into the argument `eithers`.

After that, it **pattern matches** on the contents of `eithers`. Remember that `eithers` is a `List`.

A `List` can either be empty (`[]`) or it can have a head and a tail. We have three patterns going on here:

```elm
case eithers of
    [] ->
        ([], [])
```

This one is somewhat self explanatory. If someone called `partitions []` then the result is a tuple with two empty lists: `([], [])`.

```elm
case eithers of
    Left a :: rest ->
```

Okay, before diving any further into the rest of the implementation, let's figure out what is going on here. [`::`][ELM Cons function] is the `cons` function. If we reached this pattern match, it means all pattern matches above have not succeeded. For this particular example, `[]` has not been pattern matched, which can only mean that the list is not empty, therefore it contains at least one element. By using `::` we are saying that this branch can only pattern match if all of its constraints hold true. The only constraint that it has is that its head/first element has a constructor of `Left`. If the head of the list has this constructor, then `a` will be populated with the payload carried when `Left` was instanciated, and `rest` will contain whatever remains of the list. If `eithers` only had one element, then `rest` will be the empty list `[]`.

By the way, IMHO, `a` is an unfortunate name because it ""mentally clashes"" with `a` on the function signature. I have created a [PR][elm-lang.org PR 728] to try to address this issue.

Let's have a look into the implementation of this pattern matched branch:

```elm
case eithers of
    Left a :: rest ->
        let
            (lefts, rights) =
                partition rest
```

Here, two techniques: recursion (when we call `partition rest`) and pattern matching, when we assign whatever the result of `partition rest` was into `(lefts, rights)`. We now have a `lefts` and `rights` in our scope, so we can use them inside the `in` part:

```elm
case eithers of
    Left a :: rest ->
        let
            (lefts, rights) =
                partition rest
        in
            (a :: lefts, rights)
```

Finally we return the tuple `(a :: lefts, rights)`. `a :: lefts` is creating a new list, that has `a` as its head and `lefts` as its tail. Recursivity can be a mind bend, take some time to practice it, and it will soon enough become familiar. If not, just re**curse** and call the function again :)

The branch for the `Right` pattern match is very similar to the `Left` one, but we are adding the `b` payload to the head of the rights return list.



[ELM Examples]: http://elm-lang.org/examples
[Hello World ELM Example]: http://elm-lang.org/examples/hello-html
[Math ELM Example]: http://elm-lang.org/examples/math
[Strings ELM Example]: http://elm-lang.org/examples/strings
[Calling Functions ELM Example]: http://elm-lang.org/examples/functions
[Defining Functions ELM Example]: http://elm-lang.org/examples/define-functions
[If ELM Example]: http://elm-lang.org/examples/if
[Let ELM Example]: http://elm-lang.org/examples/let
[Case ELM Example]: http://elm-lang.org/examples/case
[Lambda ELM Example]: http://elm-lang.org/examples/lambda
[Unordered List ELM Example]: http://elm-lang.org/examples/unordered-list
[ELM HTML Package]: http://package.elm-lang.org/packages/elm-lang/html/latest/Html
[ELM HTML ul function]: http://package.elm-lang.org/packages/elm-lang/html/latest/Html#ul
[ELM HTML li function]: http://package.elm-lang.org/packages/elm-lang/html/latest/Html#li
[ELM HTML text function]: http://package.elm-lang.org/packages/elm-lang/html/latest/Html#text
[Union Types Either ELM Example]: http://elm-lang.org/examples/either
[ELM Syntax]: http://elm-lang.org/docs/syntax
[ELM Cons function]: http://package.elm-lang.org/packages/elm-lang/core/latest/List#::
[elm-lang.org PR 728]: https://github.com/elm-lang/elm-lang.org/pull/728

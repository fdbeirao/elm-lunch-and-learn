# Lunch and Learn - ELM (Day 3)

One of [ELM's examples][ELM Examples] is [http][HTTP ELM Example]. This is both a hilarious example (it displays GIFs of cats!) and also an awesome example, because it shows us how do we do unpure operations in ELM.

Let's first have a look at the example as it is. We will then refactor it to use a different library to "perform" the HTTP requests.

Right now, the example consists of a simple enough `Model` and `Msg`:

```elm
-- MODEL


type alias Model =
    { topic : String
    , gifUrl : String
    }


-- UPDATE


type Msg
    = MorePlease
    | NewGif (Result Http.Error String)
```

Nothing too special. Our `Model` states that our application cares about two things: a `topic` and a `gifUrl`. Our `Msg` states that two things can happen in our application: a `MorePlease` and a `NewGif`, which brings with it a single payload of `Result Http.Error String`.

This type `Result` (we know it is a type because it starts with a capital letter) exists in [`elm-lang/core`][ELm Lang Core Result], and that is why we do not need to explicitly `import` it. 
The implementation of this type is:

```elm
type Result error value
    = Ok value
    | Err error
```

Keep in mind that `error` and `value` are type variables. We have discussed type variables in [Day 2, Union types: either][Day2 Union Types].

Basically what this type `Result` means is that it can convey two situations: a success (`Ok`) and a failure (`Err`).




[ELM Examples]: http://elm-lang.org/examples
[HTTP ELM Example]: http://elm-lang.org/examples/http
[ELm Lang Core Result]: http://package.elm-lang.org/packages/elm-lang/core/latest/Result#
[Day2 Union Types]: ../Day2/#union-types-either
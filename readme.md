# Lunch and Learn - ELM

## Step 0 - Rules

* **Immutability**: you can't mutate a record/*"object"*:
  * Just like in `C#` a `string` is immutable, in ELM **all data** is immutable;

* **Functions**: everything is a **pure** function:
  * You are not allowed to have side effects. This means that calling the same function, with the same **inputs** will **always** yield the **same output**. This gives us predictability. No more "works on my machine" :)
  * `void`, `exceptions` are not a thing. Period.
  * There is **always** a return from a function. Because functions are not allowed to have side effects, a function with no return wouldn't even make sense. What would be the point of asking a computer to run a calculation and then never give it back to us? Pointless I tell you.


#### A data type in ELM

```elm
type alias Model =
  { name : String
  }
```
The name of this data type is `Model`. Data types always start with a Capital letter. Conversely, functions always start with a lowercase letter.

It helps to think of a data type as an immutable DTO/POCO (data transfer object/plain old CLR object).


#### A union type in ELM

```elm
type Msg 
  = Greet
  | Something String
```

Think of union types as `enum`s with potential payload.

#### How to read a function signature in ELM:

```elm
functionName : Input1Type -> Input2Type -> Input3Type -> OutputType
functionName input1 input2 input3 =
  input1 + input2 + input3
```

Notice there is no `return` keyword. This is by design in functional languages. The **last** instruction inside a function is its return.


### The core **functions** in ELM

#### Init

`init` is a function that doesn't have input and always returns the tuple `( Model, Cmd Msg )`.

We will not worry with `Cmd Msg` for now.

The signature for `init` is therefore `init : ( Model, Cmd Msg )`.

#### Update

`update` is a function that receives a **message** and the **current state** as inputs, and returns a tuple with the updated **state** and `Cmd Msg` (we will talk about this later).

The signature for `update` is `update : Msg -> Model -> ( Model, Cmd Msg )`.

#### View

`view` is a function that receives the **current state** as input and returns, and returns an **Html** representation intention. This Html representation also knows about the list of potential messages on our system. Don't worry too much about it for now, we will power through it.

The signature for `view` is `view : Model -> Html Msg`.

In this signature, both `Model` and `Msg` are defined by us as developers and modelers of our solution. `Html` however comes from the package with the same name: `Html`.

## Step 1 - The mandatory hello world

Enough talk more coding.

Our hello world application will have the most useless `Model` ever: a `string`.

```elm
---- MODEL ----
type alias Model = 
  String
```

We also need a list of all the things that can happen in our application.
For now... nothing can happen! This is a **very** contrived situation, but we just want to get the ball rolling and move forward.

```elm
---- MSG ----

type Msg
  = NoOp
```

We have already established a `Model`, we can now have an `init` function:

```elm
---- INIT ----

init : ( Model, Cmd Msg )
init =
  ( "world", Cmd.none )
```

There is a **syntactical sugar** for when we want to return this kind of tuple.

This `init` function is the same as the one above:

```elm
---- INIT ----

init : ( Model, Cmd Msg )
init =
  "world" ! []
```

We can now create our `update` function. Again, in this very contrived initial example, there is nothing that will cause our `Model` to update, so the update function becomes very simple.

```elm
---- UPDATE ----

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  model ! []
```

This is a `function` that effectively *does nothing*. Its responsibility is to take some fact/event that happened in our application (conveyed by the `Msg`), and return a new and updated version of the state of our application (`Model`). Because we have no interactivity in our application, this function does not need to do anything other than return the same `model` that was passed in, with a `Cmd.none` (we are using the `! []` syntactic sugar here instead of writing `( model, Cmd.none )`.

For the final step of our application we need the `view` function. Remember, the `view` function receives as input the current state of the application (just returned by the `update` function) and its job is to return a representation of Html.

```elm
---- VIEW ----

view : Model -> Html Msg
view model =
  Html.text ("Hello " ++ model)
```

We can now try to run `elm-reactor` (installed as part of [elm-lang](http://elm-lang.org/)) and we will see the following errors:

```
Detected errors in 1 module.


-- NAMING ERROR ------------------------------------------------------ step1.elm

Cannot find variable `Html.text`.

31|   Html.text "Hello " ++ model
      ^^^^^^^^^
No module called `Html` has been imported. 



-- NAMING ERROR ------------------------------------------------------ step1.elm

Cannot find type `Html`

29| view : Model -> Html Msg
```

The elm compiler is telling us that it doesn't know what the `Html` type in the view signature is. Also, we are calling a function inside `Html` module, and it has no idea what this `Html` module is.

We will fix this by adding an `import` for this `Html` module to the top of our file:

```elm
import Html exposing (Html)
```

What this `import` directive does is import a module named `Html` (we will talk about modules in a while, don't worry), and from that module expose a `type` named `Html`. We know `Html` is a type because it starts with a Capital letter.


If we now refresh `elm-reactor` we still do not see anything on the browser. This is because even though `init`, `update`, `view`, `Model` and `Msg` are well-known conventions in the ELM language, the only convention that we really need is a function called `main`. This function is responsible for returning a data object to ELM, with these well known functions wired from what elm expects, to what we implemented. Do not concern yourself with the signature of `main : Program Never Model Msg`.

Let's provide this function on our file:

```elm
---- MAIN ----

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
```

What is that strange `subscriptions` function? For now we will not yet worry about it, but this is a function that allows us to declare to ELM that not all the `Msg` may arise from our `view`. Things like time ticks, web sockets, mouse move, keyboard keys (shift, ctrl, etc) aren't provided by the DOM directly. Again, in our simple application we do not require any subscription, therefore the implementation of this function is easy enough:

```elm
---- SUBSCRIPTIONS ----

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
```

Had we called our functions as `our_init`, `our_update`, `our_view`, `our_subscriptions`, and our types as `OurModel` and `OurMsg`, then the `main` function would look like:

```elm
---- MAIN ----

main : Program Never OurModel OurMsg
main =
    Html.program
        { init = our_init
        , update = our_update
        , subscriptions = our_subscriptions
        , view = our_view
        }
```

----

This is how our `main.elm` file looks like right now (after executing `elm-format`):
```elm
module Main exposing (..)

import Html exposing (Html)


---- MODEL ----


type alias Model =
    String



---- MSG ----


type Msg
    = NoOp



---- MAIN ----


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



---- INIT ----


init : ( Model, Cmd Msg )
init =
    "world" ! []



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    model ! []



---- VIEW ----


view : Model -> Html Msg
view model =
    Html.text ("Hello " ++ model)

```

If we run this file with `elm-reactor` we can now see our `Hello world` on the browser, and hopefully understand where it comes from. `elm-reactor` simply called our `main` function, and from there started the ELM runtime.
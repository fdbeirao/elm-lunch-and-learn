# Lunch and Learn - ELM (Day 2)

Today we want something a little more elaborate from our ELM application.

We wish to construct an application which enables a user to edit some contents in a `table`, as well as add more rows to it.

For the MVP (minimum viable product) we have the following acceptance criteria:

- [ ] A table with three columns will be presented to the user;
  - [ ] The first column is the number of the row;
  - [ ] The second column is for "First name";
  - [ ] The third column is for "Last name";
- [ ] The table starts with two rows: `1 | Jack | The Stupid Cat` and `2 | Óscar | Alho`
- [ ] The user can click the cells on the rows to edit the content
  - [ ] The user cannot edit the number of the row;

The following has been identified as features for "next version":

- Adding some style/good looks to our table;
- Obtaining the structure of the table from a remote server (HTTP);
- Submitting the content the user has changes to a remote server (HTTP);
- Using "local storage" to survive F5/refresh/browser crash while the user is editing;

## Let's start with.. the view?

We assume our `main.elm` file starts with the same content as the one from [Day 1](../Day%201/main.elm).

If we were to create a [plain old simple table using HTML](https://www.w3schools.com/html/html_tables.asp) we would have something like:

```html
<table>
  <tr>
    <th>#</th>
    <th>First name</th>
    <th>Last name</th>
  </tr>
  <tr>
    <td>1</td>
    <td>Jack</td>
    <td>The Stupid Cat</td>
  </tr>
  <tr>
    <td>2</td>
    <td>Óscar</td>
    <td>Alho</td>
  </tr>
</table>
```

Let's construct this on our `view` function, to get acquainted with ELM's `Html` package. We need to keep in mind that in ELM **everything is a function**. This means that the `Html` package provides us with pure functions. Let's take a look at how we convey the intention to build the HTML above using ELM functions:

```elm
---- VIEW ----


view : Model -> Html Msg
view model =
    Html.table
        []
        [ Html.tr
            []
            [ Html.th [] [ Html.text "#" ]
            , Html.th [] [ Html.text "First name" ]
            , Html.th [] [ Html.text "Last name" ]
            ]
        , Html.tr
            []
            [ Html.td [] [ Html.text "1" ]
            , Html.td [] [ Html.text "Jack" ]
            , Html.td [] [ Html.text "The Stupid Cat" ]
            ]
        , Html.tr
            []
            [ Html.td [] [ Html.text "2" ]
            , Html.td [] [ Html.text "Óscar" ]
            , Html.td [] [ Html.text "Alho" ]
            ]
        ]

```

Whoa, whoa! What's this? So many things, so strange to look at. Well, let's at least give it an opportunity.

Okay, so in ELM all the functions have a signature. This means we can see (for instance) what is the signature for [`Html.table`](http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html#table). Here is is:

```elm
table : List (Attribute msg) -> List (Html msg) -> Html msg
```

So, the `table` function (inside the `Html` package) takes two inputs and returns `Html msg`. The first input is something that has type `List (Attribute msg)` and the second type is something that has type `List (Html msg)`.

We could dive deep into ELM's types here, but maybe we can try to fit this into our brains a little latter along the way. 

Let me try to come up with an easier way to read the function signature: in order to create a `<table>` HTML element, we need to provide a (possibly empty) list of `Attribute`s and also provide a (possibly empty) list of `Html` elements. 

If we look at the signature for [`Html.tr`](http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html#tr), [`Html.th`](http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html#th), [`Html.td`](http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html#td), we will see the same signature pattern:

```elm
tr : List (Attribute msg) -> List (Html msg) -> Html msg
```

```elm
th : List (Attribute msg) -> List (Html msg) -> Html msg
```

```elm
td : List (Attribute msg) -> List (Html msg) -> Html msg
```

We used one other function from the `Html` package: `Html.text`. This one has an even simpler signature:

```elm
text : String -> Html msg
```

This function represents simple text inside an element. If we wanted to create the HTML `<td>foo</td>` we would use `Html.td [] [ Html.text "foo" ]`.

Let's use `elm-reactor` to observe the result of the `view` function we implemented above. We will see both how it looks on the browser and also have a look at the generated HTML (by using F12/Inspect):

![View result](imgs/236490f2-e43d-4191-bf78-0722354ad758.png)

![Generated HTML](imgs/b4a1876a-28e7-4000-abb6-8e8ec5900c92.png)

The generated HTML looks pretty neat, right? In fact, it even looks exactly like the HTML that we wanted in the first place.

**Protip:** I am using the prefix `Html.` for all the functions in my view, because it helps understand where the function comes from. A trick we can do is to change our `import Html` declaration to this:

```elm
import Html exposing (Html, table, tr, th, td, text)
```

This will then allow us to write our same `view` function like this:
```elm
---- VIEW ----


view : Model -> Html Msg
view model =
    table
        []
        [ tr
            []
            [ th [] [ text "#" ]
            , th [] [ text "First name" ]
            , th [] [ text "Last name" ]
            ]
        , tr
            []
            [ td [] [ text "1" ]
            , td [] [ text "Jack" ]
            , td [] [ text "The Stupid Cat" ]
            ]
        , tr
            []
            [ td [] [ text "2" ]
            , td [] [ text "Óscar" ]
            , td [] [ text "Alho" ]
            ]
        ]
```

This reads even better now. Let's leave it like this. The promise that you need to make is to use explicit import of those functions, so that if a fellow developer wants to know where that `table` function is coming from, he can just *Ctrl+Find* it. This is a best practice and you receive an *elmillion* million internet points for doing this :)

One thing we notice about our table is that it doesn't really "look" like a table. Maybe having some lines would help? We are not CSS designers (yet!), so let's just use the [`border`](https://www.w3schools.com/tags/att_table_border.asp) attribute:

```html
<table border="1">
```

We saw that the `Html.table` function takes a `List (Attribute msg)` as its first input. Right now we are passing an empty list (`[]`). Let's try to put our `border` attribute there. Turns out that `border` is a deprecated attribute, so ELM doesn't provide a `border` function. This is not an issue. We can work around it by using the more generic [`attribute`](http://package.elm-lang.org/packages/elm-lang/html/2.0.0/Html-Attributes#attribute) function:

```elm
attribute : String -> String -> Attribute msg
```

```elm
table
    [ Html.Attributes.attribute "border" "1" ]
    [ ... ]
```

ELM rightfully complains that it never heard about this `Html.Attributes`. Let's import it:

```elm
import Html.Attributes
```

Our table now looks a little more like a table (even if it is still awful):

![Now with borders](imgs/a18f11b9-8908-41b6-ada3-7c0623e3a0a0.png)

**Work in progress ...**

- [ ] Explore `map` function still inside the `view`
- [ ] Now add something to `Model`
- [ ] Implement `init`
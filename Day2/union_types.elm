module Main exposing (main)

import Html


type OneOf
    = Number Int
    | Sentence String


toText : OneOf -> String
toText val =
    case val of
        Number payload ->
            toString payload

        Sentence payload ->
            payload


main =
    Html.ul []
        [ Html.li [] [ Html.text (toText (Number 20)) ]
        , Html.li [] [ Html.text (toText (Sentence "Hello there!")) ]
        ]

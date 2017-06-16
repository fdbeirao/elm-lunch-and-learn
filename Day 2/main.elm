module Main exposing (..)

import Html exposing (Html, table, tr, th, td, text)
import Html.Attributes


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
    table
        [ Html.Attributes.attribute "border" "1" ]
        [ tr
            []
            (asTableHeaders [ "#", "First name", "Last name" ])
        , tr
            []
            (asRowCells 1 [ "Jack", "The Stupid Cat" ])
        , tr
            []
            (asRowCells 2 [ "Óscar", "Alho" ])
        ]


asTableHeaders : List String -> List (Html Msg)
asTableHeaders headers =
    List.map (\headerText -> th [] [ text headerText ]) headers


asRowCells : Int -> List String -> List (Html Msg)
asRowCells rowNumber cells =
    let
        rowNumberCell =
            td [] [ text (toString rowNumber) ]

        rowCells =
            List.map (\cellText -> td [] [ text cellText ]) cells
    in
        rowNumberCell :: rowCells

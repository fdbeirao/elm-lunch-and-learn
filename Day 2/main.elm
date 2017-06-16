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

module Main exposing (..)

import Html exposing (Html, table, tr, th, td, text)
import Html.Attributes
import Html.Events exposing (onMouseEnter, onMouseLeave)


---- MODEL ----


type alias Model =
    { headers : List String
    , rows : List Row
    }


type alias Row =
    List String


type alias CellCoordinates =
    { row : Int
    , col : Int
    }

asCellCoordinates : Int -> Int -> CellCoordinates
asCellCoordinates row col =
    { row = row
    , col = col
    }

---- MSG ----


type Msg
    = OnMouseEnterCell CellCoordinates
    | OnMouseLeaveCell



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
    { headers = [ "#", "First name", "Last name" ]
    , rows =
        [ [ "Jack", "The Stupid Cat" ]
        , [ "Óscar", "Alho" ]
        ]
    }
        ! []



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    model ! []



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        headerRow =
            model.headers
                |> asTableHeaders

        tableRows =
            model.rows
                |> List.indexedMap
                    (\rowNumber row ->
                        asTableRow (rowNumber + 1) row
                    )
    in
        table
            [ Html.Attributes.attribute "border" "1" ]
            (headerRow ++ tableRows)


asTableHeaders : List String -> List (Html Msg)
asTableHeaders headers =
    List.map (\headerText -> th [] [ text headerText ]) headers


asTableRow : Int -> Row -> Html Msg
asTableRow rowNumber cells =
    let
        rowNumberCell =
            td [] [ text (toString rowNumber) ]

        rowCells =
            cells |> (asHoverableRowCells rowNumber)
    in
        tr [] (rowNumberCell :: rowCells)


asHoverableRowCells : Int -> List String -> List (Html Msg)
asHoverableRowCells rowNumber cells =
    let
        cellCoordinate = 
            asCellCoordinates rowNumber
        
        mouseEnterCellMessage =
            OnMouseEnterCell << cellCoordinate
    in
        List.indexedMap (\cellNumber cellText -> 
            td [ onMouseEnter (mouseEnterCellMessage (cellNumber + 1)) ] [ text cellText ]) cells

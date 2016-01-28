module Main (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import StartApp.Simple exposing (start)
import Json.Decode as Json
import Html.Events exposing (on)


type alias Model =
    { rowCount : Int
    , colCount : Int
    , cellHeight : Int
    , cellWidth : Int
    , scrollTop : Int
    , height : Int
    , border : Int
    }


type Action
    = NoOp
    | UserScroll Int


main : Signal Html
main =
    StartApp.Simple.start
        { model = model
        , view = view
        , update = update
        }


update : Action -> Model -> Model
update action model =
    case action of
        NoOp ->
            model

        UserScroll scrollTop ->
            { model | scrollTop = scrollTop }


model : Model
model =
    { rowCount = 20000
    , colCount = 15
    , cellHeight = 20
    , cellWidth = 100
    , scrollTop = 0
    , height = 800
    , border = 1
    }


scrollTop : Json.Decoder Int
scrollTop =
    Json.at [ "target", "scrollTop" ] Json.int


view : Signal.Address Action -> Model -> Html
view address model =
    let
        containerStyle =
            style
                [ ( "position", "absolute" )
                , ( "top", "40px" )
                , ( "left", "40px" )
                , ( "right", "40px" )
                , ( "overflow-x", "hidden" )
                , ( "height", toString (model.height) ++ "px" )
                ]

        tableContainerStyle =
            style
                [ ( "height", toString ((model.cellHeight + model.border) * model.rowCount) ++ "px" )
                ]
    in
        div
            [ containerStyle, on "scroll" scrollTop (Signal.message address << UserScroll) ]
            [ div
                [ tableContainerStyle ]
                [ tableView model
                ]
            ]


calculateViewPort model =
    let
        startRow = model.scrollTop // (model.cellHeight + model.border)

        offset = model.scrollTop % (model.cellHeight + model.border)

        endRow = startRow + model.height // (model.cellHeight + model.border)
    in
        { tableOffset = model.scrollTop - offset
        , startRow = startRow
        , endRow = endRow
        }


tableView : Model -> Html
tableView model =
    let
        tableStyle =
            style
                [ ( "border-collapse", "collapse" )
                , ( "position", "absolute" )
                , ( "top", "0" )
                , ( "transform", "translateY(" ++ (toString viewPort.tableOffset) ++ "px)" )
                ]

        viewPort = calculateViewPort model
    in
        table
            [ tableStyle ]
            [ tbody
                []
                <| List.map
                    (\r -> rowView r model)
                    [viewPort.startRow..viewPort.endRow]
            ]


rowView : Int -> Model -> Html
rowView n model =
    let
        trStyle =
            style
                [ ( "height", toString (model.cellHeight) ++ "px" )
                ]

        tdStyle =
            style
                [ ( "width", toString (model.cellWidth) ++ "px" )
                , ( "border", "1px solid black" )
                ]
    in
        tr [ key (toString n), trStyle ]
            <| List.map (\c -> td [ tdStyle ] [ text ("r" ++ toString (n) ++ " c" ++ toString (c)) ]) [1..model.colCount]


targetRows : Model -> List Int
targetRows model =
    [1..30]

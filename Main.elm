module Main (..) where

import Html exposing (..)
import StartApp.Simple exposing (start)


type alias Model =
    Int


type Action
    = NoOp
    | UserScroll Int


main : Signal Html
main =
    start
        { model = model
        , view = view
        , update = update
        }


update : Action -> Model -> Model
update action model =
    model + 1


model : Model
model =
    1


view : Signal.Address Action -> Model -> Html
view address model =
    div [] [ text "ss" ]

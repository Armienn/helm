module Main exposing (main)

import Browser
import Html exposing (..)

main = Browser.sandbox { init = init, view = view, update = update }

type alias Model = String

init : Model
init =
  "Ja hej du"

update _ model = 
  model

view model =
  div [] [ text model ]

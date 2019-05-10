module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Helming
import Battle

main = Browser.sandbox {
  init = Battle.init,
  view = Battle.view,
  update = Battle.update }

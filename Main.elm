module Main exposing (main)

import Battle
import Browser
import Html exposing (..)
import Html.Events exposing (onClick)


main =
    Browser.sandbox
        { init = Battle.init
        , view = Battle.view
        , update = Battle.update
        }

module Helming exposing (Helming, changeHealth, init, viewHelming)

import CommonViews exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)


type alias Helming =
    { name : String
    , xp : Int
    , maxHealth : Int
    , health : Int
    }


init : Helming
init =
    { name = "Aslak"
    , xp = 50
    , maxHealth = 40
    , health = 30
    }


changeHealth : { a | health : Int, maxHealth : Int } -> Int -> { a | health : Int, maxHealth : Int }
changeHealth thing change =
    { thing | health = max (min (thing.health + change) thing.maxHealth) 0 }



-- VIEW


viewHelming : Helming -> Html msg
viewHelming helming =
    div []
        [ viewName "Helming" helming.name
        , separator
        , viewHealth helming
        , separator
        , viewXp helming.xp
        ]

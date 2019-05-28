module Helming exposing (Helming, changeHealth, updatedHealth, exhaustHelming, init, recoverHelming, viewHelming)

import CommonViews exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)


type alias Helming =
    { name : String
    , maxHealth : Int
    , health : Int
    , strength : Int
    , defense : Int
    , exhausted : Bool
    }


init : Helming
init =
    { name = "Aslak"
    , maxHealth = 50
    , health = 50
    , strength = 50
    , defense = 50
    , exhausted = False
    }


changeHealth : { a | health : Int, maxHealth : Int } -> Int -> { a | health : Int, maxHealth : Int }
changeHealth thing change =
    { thing | health = max (min (thing.health + change) thing.maxHealth) 0 }


updatedHealth : { a | health : Int, maxHealth : Int } -> Int -> Int
updatedHealth thing change =
    max (min (thing.health + change) thing.maxHealth) 0


exhaustHelming : Helming -> Helming
exhaustHelming helming =
    { helming | exhausted = True }


recoverHelming : Helming -> Helming
recoverHelming helming =
    { helming | exhausted = False }



-- VIEW


viewHelming : Helming -> Html msg
viewHelming helming =
    div []
        [ viewName "Helming" helming.name
        , separator
        , viewHealth helming
        ]

module Beast exposing (Beast, init, viewBeast)

import Html exposing (..)
import CommonViews exposing (..)

type alias Beast =
    { name : String
    , maxHealth : Int
    , health : Int
    }


init : Beast
init =
    { name = "Wyrm"
    , maxHealth = 200
    , health = 200
    }

viewBeast : Beast -> Html msg
viewBeast beast =
    div []
        [ viewName "Beast" beast.name
        , separator
        , viewHealth beast
        ]


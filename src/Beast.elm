module Beast exposing (Beast, beastDecoder, viewBeast)

import CommonViews exposing (..)
import Html exposing (..)
import Json.Decode exposing (Decoder, at, field, int, string)


type alias Beast =
    { name : String
    , maxHealth : Int
    , health : Int
    }


viewBeast : Beast -> Html msg
viewBeast beast =
    div []
        [ viewName "Beast" beast.name
        , separator
        , viewHealth beast
        ]


beastDecoder : Decoder Beast
beastDecoder =
    Json.Decode.map3 Beast
        (at [ "species", "name" ] string)
        (at [ "stats", "5", "base_stat" ] int)
        (at [ "stats", "5", "base_stat" ] int)

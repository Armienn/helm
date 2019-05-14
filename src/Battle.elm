module Battle exposing (Battle, init, update, view)

import Beast exposing (..)
import Helming exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)


type alias Battle =
    { hero : Helming
    , beast : Beast
    }


init : Battle
init =
    { hero = Helming.init
    , beast = Beast.init
    }


update : Msg -> Battle -> Battle
update action model =
    { model | hero = Helming.update action model.hero }


view : Battle -> Html Msg
view battle =
    div []
        [ viewHelming battle.hero
        , div [] [ text "asfd" ]
        , viewActions battle.hero
        ]

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


type Msg
    = Attack Int
    | Heal Int


update : Msg -> Battle -> Battle
update msg model =
    case msg of
        Heal amount ->
            { model | hero = changeHealth model.hero amount }

        Attack amount ->
            { model | beast = changeHealth model.beast -amount }



-- VIEW


view : Battle -> Html Msg
view battle =
    div []
        [ viewHelming battle.hero
        , div [] [ text "vs" ]
        , viewBeast battle.beast
        , viewActions battle
        ]


viewActions : Battle -> Html Msg
viewActions battle =
    div []
        [ button [ onClick (Attack 7) ] [ text "Attack" ]
        , button [ onClick (Heal 5) ] [ text "Heal" ]
        ]

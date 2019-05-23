module Battle exposing (Model, Msg(..), init, update, view)

import Beast exposing (..)
import Helming exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)


type alias Model =
    { hero : Helming
    , beast : Beast
    }


init : Beast -> Model
init beast =
    { hero = Helming.init
    , beast = beast
    }


type Msg
    = Attack Int
    | Heal Int
    | Run


update : Msg -> Model -> Model
update msg model =
    case msg of
        Heal amount ->
            { model | hero = changeHealth model.hero amount }

        Attack amount ->
            { model | beast = changeHealth model.beast -amount }

        _ ->
            model



-- VIEW


view : Model -> Html Msg
view battle =
    div []
        [ viewHelming battle.hero
        , div [] [ text "vs" ]
        , viewBeast battle.beast
        , viewActions battle
        ]


viewActions : Model -> Html Msg
viewActions battle =
    div []
        [ button [ onClick (Attack 7) ] [ text "Attack" ]
        , button [ onClick (Heal 5) ] [ text "Heal" ]
        , button [ onClick Run ] [ text "Run" ]
        ]

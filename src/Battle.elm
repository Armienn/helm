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
    = GotHelmingMsg Helming.Msg
    | GotBeastMsg


update : Msg -> Battle -> Battle
update msg model =
    case msg of
        GotHelmingMsg subMsg ->
            { model | hero = Helming.update subMsg model.hero }

        GotBeastMsg ->
            model


view : Battle -> Html Msg
view battle =
    div []
        [ viewHelming battle.hero
        , div [] [ text "asfd" ]
        , Html.map GotHelmingMsg (viewActions battle.hero)
        ]

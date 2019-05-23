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
    = MassiveAttack Int
    | Attack Int
    | Heal Int
    | Recover
    | Run


update : Msg -> Model -> Model
update msg model =
    case msg of
        MassiveAttack amount ->
            { model
                | beast = changeHealth model.beast -amount
                , hero = exhaustHelming model.hero
            }

        Attack amount ->
            { model | beast = changeHealth model.beast -amount }

        Heal amount ->
            { model | hero = changeHealth model.hero amount }

        Recover ->
            { model | hero = recoverHelming model.hero }

        _ ->
            model



-- VIEW


view : Model -> Html Msg
view battle =
    div []
        [ viewBeast battle.beast
        , div [] [ text "vs" ]
        , viewHelming battle.hero
        , viewActions battle
        ]


viewActions : Model -> Html Msg
viewActions battle =
    if battle.hero.exhausted then
        div []
            [ text "You're too exhausted to fight"
            , button [ onClick Recover ] [ text "Recover" ]
            ]

    else
        div []
            [ button [ onClick (MassiveAttack 12) ] [ text "Massive Attack" ]
            , button [ onClick (Attack 7) ] [ text "Attack" ]
            , button [ onClick (Heal 5) ] [ text "Heal" ]
            , button [ onClick Run ] [ text "Run" ]
            ]

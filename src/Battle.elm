module Battle exposing (Model(..), Msg(..), init, update, view)

import Beast exposing (..)
import Helming exposing (..)
import Fighting
import Html exposing (..)
import Html.Events exposing (onClick)


type Model
    = Fight Helming Beast
    | BeastAttack Helming Beast
    | BeastFlinch Helming Beast
    | Lost Helming
    | Finished Helming


init : Beast -> Model
init beast =
    Fight Helming.init beast


type Msg
    = MassiveAttack Int
    | Attack Int
    | Heal Int
    | Recover
    | Run
    | Nothing


update : Msg -> Model -> Model
update msg model =
    case model of
        Fight helming beast ->
            updateFight msg helming beast

        _ ->
            updateBeastAction model


updateFight : Msg -> Helming -> Beast -> Model
updateFight msg helming beast =
    case msg of
        MassiveAttack amount ->
            let
                newHealth =
                    Fighting.healthAfterAttack -amount helming beast
            in
            if newHealth <= 0 then
                Finished helming

            else
                BeastFlinch (exhaustHelming helming) { beast | health = newHealth }

        Attack amount ->
            let
                newHealth =
                    Fighting.healthAfterAttack -amount helming beast
            in
            if newHealth <= 0 then
                Finished helming

            else
                BeastAttack helming { beast | health = newHealth }

        Heal amount ->
            BeastAttack (changeHealth helming amount) beast

        Recover ->
            BeastAttack (recoverHelming helming) beast

        Run ->
            Finished helming

        _ ->
            Fight helming beast


updateBeastAction : Model -> Model
updateBeastAction model =
    case model of
        BeastAttack helming beast ->
            let
                newHealth =
                    Fighting.healthAfterAttack -5 beast helming
            in
            if newHealth <= 0 then
                Lost { helming | health = newHealth }

            else
                Fight { helming | health = newHealth } beast

        BeastFlinch helming beast ->
            Fight helming beast

        _ ->
            model



-- VIEW


view : Model -> Html Msg
view battle =
    case battle of
        Fight helming beast ->
            viewBattle helming beast

        BeastAttack helming beast ->
            viewBeastAttack helming beast

        BeastFlinch helming beast ->
            viewBeastFlinch helming beast

        Lost _ ->
            div [] [ text "You died..." ]

        _ ->
            div [] [ text "huh" ]


viewBattle : Helming -> Beast -> Html Msg
viewBattle helming beast =
    div []
        [ viewBeast beast
        , div [] [ text "vs" ]
        , viewHelming helming
        , viewActions helming
        ]


viewActions : Helming -> Html Msg
viewActions helming =
    if helming.exhausted then
        div []
            [ text "You're too exhausted to fight "
            , button [ onClick Recover ] [ text "Recover" ]
            ]

    else
        div []
            [ button [ onClick (MassiveAttack 12) ] [ text "Massive Attack" ]
            , button [ onClick (Attack 7) ] [ text "Attack" ]
            , button [ onClick (Heal 5) ] [ text "Heal" ]
            , button [ onClick Run ] [ text "Run" ]
            ]


viewBeastAttack : Helming -> Beast -> Html Msg
viewBeastAttack helming beast =
    div [] [ button [ onClick Nothing ] [ text "The beast attacks!" ] ]


viewBeastFlinch : Helming -> Beast -> Html Msg
viewBeastFlinch helming beast =
    div [] [ button [ onClick Nothing ] [ text "The beast flinches!" ] ]

module Battle exposing (Model(..), Msg(..), init, update, view)

import Beast exposing (..)
import Helming exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)


type Model
    = Fight Helming Beast
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


update : Msg -> Model -> Model
update msg model =
    case model of
        Fight helming beast ->
            updateFight msg helming beast

        _ ->
            model


updateFight : Msg -> Helming -> Beast -> Model
updateFight msg helming beast =
    case msg of
        MassiveAttack amount ->
            Fight
                (exhaustHelming helming)
                (changeHealth beast -amount)

        Attack amount ->
            let
                newHealth =
                    updatedHealth beast -amount
            in
            if newHealth <= 0 then
                Finished helming

            else
                Fight helming { beast | health = newHealth }

        Heal amount ->
            Fight (changeHealth helming amount) beast

        Recover ->
            Fight (recoverHelming helming) beast

        Run ->
            Finished helming



-- VIEW


view : Model -> Html Msg
view battle =
    case battle of
        Fight helming beast ->
            viewBattle helming beast
        
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

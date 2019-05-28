module Battle exposing (Model(..), Msg(..), init, update, view)

import Beast exposing (..)
import Fighting
import Helming exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)


type Model
    = Fight Helming Beast
    | BeastAttack Helming Beast String
    | BeastFlinch Helming Beast String
    | Lost Helming
    | Won Helming
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
                damage =
                    Fighting.attackDamage -amount helming beast
            in
            if beast.health - damage <= 0 then
                Won helming

            else
                BeastFlinch
                    (exhaustHelming helming)
                    { beast | health = beast.health - damage }
                    ("You attack the beast, dealing "
                        ++ String.fromInt damage
                        ++ " damage "
                    )

        Attack amount ->
            let
                damage =
                    Fighting.attackDamage -amount helming beast
            in
            if beast.health - damage <= 0 then
                Won helming

            else
                BeastAttack
                    helming
                    { beast | health = beast.health - damage }
                    ("You attack the beast, dealing "
                        ++ String.fromInt damage
                        ++ " damage "
                    )

        Heal amount ->
            BeastAttack
                (changeHealth helming amount)
                beast
                ("You heal yourself for "
                    ++ String.fromInt amount
                    ++ " hp "
                )

        Recover ->
            BeastAttack
                (recoverHelming helming)
                beast
                "You're no longer exhausted "

        Run ->
            Finished helming

        _ ->
            Fight helming beast


updateBeastAction : Model -> Model
updateBeastAction model =
    case model of
        BeastAttack helming beast _ ->
            let
                damage =
                    Fighting.attackDamage -5 beast helming
            in
            if helming.health - damage <= 0 then
                Lost { helming | health = helming.health - damage }

            else
                Fight { helming | health = helming.health - damage } beast

        BeastFlinch helming beast _ ->
            Fight helming beast

        Won helming ->
            Finished
                { helming
                    | strength = helming.strength + 10
                    , defense = helming.defense + 10
                    , maxHealth = helming.maxHealth + 10
                    , health = helming.maxHealth + 10
                }

        Lost helming ->
            Finished Helming.init

        _ ->
            model



-- VIEW


view : Model -> Html Msg
view battle =
    case battle of
        Fight helming beast ->
            viewBattle helming beast (viewActions helming)

        BeastAttack helming beast message ->
            viewBattle helming beast (viewBeastAttack helming beast message)

        BeastFlinch helming beast message ->
            viewBattle helming beast (viewBeastFlinch helming beast message)

        Lost _ ->
            div []
                [ text "You died... "
                , button [ onClick Nothing ] [ text "Reincarnate" ]
                ]

        Won _ ->
            div []
                [ text "You defeated the beast. You gain 10 power "
                , button [ onClick Nothing ] [ text "Continue journey" ]
                ]

        _ ->
            div [] [ text "huh" ]


viewBattle : Helming -> Beast -> Html Msg -> Html Msg
viewBattle helming beast actions =
    div []
        [ viewBeast beast
        , div [] [ text "vs" ]
        , viewHelming helming
        , actions
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


viewBeastAttack : Helming -> Beast -> String -> Html Msg
viewBeastAttack helming beast message =
    div []
        [ text message
        , button [ onClick Nothing ] [ text "The beast attacks!" ]
        ]


viewBeastFlinch : Helming -> Beast -> String -> Html Msg
viewBeastFlinch helming beast message =
    div []
        [ text message
        , button [ onClick Nothing ] [ text "The beast flinches!" ]
        ]

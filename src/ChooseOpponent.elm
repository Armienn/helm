module ChooseOpponent exposing (Model, Msg(..), view)

import Beast exposing (Beast)
import Helming exposing (Helming)
import Html exposing (..)
import Html.Events exposing (onClick)


type alias Model =
    { beasts : List Beast
    , hero : Helming
    }


type Msg
    = Choose Beast



-- VIEW


view : Model -> Html Msg
view choices =
    div [] <|
        text "Three beasts appear"
            :: List.map viewChoice choices.beasts


viewChoice : Beast -> Html Msg
viewChoice beast =
    div []
        [ button [ onClick <| Choose beast ] [ text <| "Fight " ++ beast.name ]
        , text <| " Terrifyingness: " ++ String.fromInt beast.maxHealth
        ]

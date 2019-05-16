module Helming exposing (Helming, Msg, init, update, viewActions, viewHelming)

import Html exposing (..)
import Html.Events exposing (onClick)


type alias Helming =
    { name : String
    , xp : Int
    , maxHealth : Int
    , health : Int
    }


init : Helming
init =
    { name = "Aslak"
    , xp = 50
    , maxHealth = 40
    , health = 40
    }


type Msg
    = GainXp Int
    | DoOtherThing
    | DontDoThing


update : Msg -> Helming -> Helming
update action model =
    case action of
        GainXp amount ->
            { model | xp = model.xp + amount }

        sadf ->
            model



-- VIEW


viewActions : Helming -> Html Msg
viewActions model =
    div []
        [ button [ onClick (GainXp 7) ] [ text "do thing" ]
        , button [ onClick DontDoThing ] [ text "dont do thing" ]
        ]


viewHelming : Helming -> Html msg
viewHelming helming =
    div []
        [ viewName helming.name
        , separator
        , viewHealth helming
        , separator
        , viewXp helming.xp
        ]


separator =
    span [] [ text " - " ]


viewName : String -> Html msg
viewName name =
    span [] [ text ("Helming: " ++ name) ]


viewHealth : { a | health : Int, maxHealth : Int } -> Html msg
viewHealth helming =
    span []
        [ text
            ("Health: "
                ++ String.fromInt helming.health
                ++ " / "
                ++ String.fromInt helming.maxHealth
            )
        ]


viewXp : Int -> Html msg
viewXp xp =
    span [] [ text ("XP: " ++ String.fromInt xp) ]

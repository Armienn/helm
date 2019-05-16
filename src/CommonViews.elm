module CommonViews exposing (separator, viewHealth, viewName, viewXp)

import Html exposing (..)


separator =
    span [] [ text " - " ]


viewName : String -> String -> Html msg
viewName thing name =
    span [] [ text (thing ++ ": " ++ name) ]


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

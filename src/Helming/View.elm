module Helming.View exposing (view, viewHelming)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Helming exposing (..)

view : Helming -> Html Action
view model =
  div [] 
    [ viewHelming model
    , button [ onClick DoThing ] [ text "do thing" ]
    , button [ onClick DontDoThing ] [ text "dont do thing" ]
    ]

viewHelming : Helming -> Html Action
viewHelming helming =
  div [] 
    [ viewName helming.name
    , separator
    , viewHealth helming
    , separator
    , viewXp helming.xp
    ]

separator =
  span [] [ text " - "]

viewName : String -> Html Action
viewName name =
  span [] [ text ("Helming: " ++ name) ]
  
viewHealth : Helming -> Html Action
viewHealth helming =
  span [] [
    text ("Health: "
    ++ String.fromInt helming.health ++ " / "
    ++ String.fromInt helming.maxHealth) ]
  
viewXp : Int -> Html Action
viewXp xp =
  span [] [ text ("XP: " ++ String.fromInt xp) ]
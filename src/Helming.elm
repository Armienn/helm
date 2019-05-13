module Helming exposing (..)

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

type Action
  = DoThing
  | DoOtherThing
  | DontDoThing

update : Action -> Helming -> Helming
update action model =
  case action of
    DoThing ->
      { model | xp = model.xp + 3 }
    sadf ->
      model


-- VIEW


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

viewHealth : { a | health: Int, maxHealth: Int } -> Html Action
viewHealth helming =
  span [] [
    text ("Health: "
    ++ String.fromInt helming.health ++ " / "
    ++ String.fromInt helming.maxHealth) ]
  
viewXp : Int -> Html Action
viewXp xp =
  span [] [ text ("XP: " ++ String.fromInt xp) ]

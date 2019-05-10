module Battle exposing (..)

import Beast exposing (..)
import Helming exposing (..)
import Helming.View exposing (..)
import Html exposing (..)
import Html.Events exposing (onClick)

type alias Battle =
  { hero: Helming
  , beast: Beast
  }

init : Battle
init =
  { hero = Helming.init
  , beast = Beast.init
  }

update : Action -> Battle -> Battle
update action model =
  { model | hero = Helming.update action model.hero }

view : Battle -> Html Action
view battle =
  div []
  [ viewHelming battle.hero
  , div [] [ text "asfd" ]
  , button [ onClick DoThing ] [ text "do thing" ]
  , button [ onClick DontDoThing ] [ text "dont do thing" ]
  ]
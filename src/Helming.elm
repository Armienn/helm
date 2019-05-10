module Helming exposing (..)

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
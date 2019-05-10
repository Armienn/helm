module Beast exposing (..)

type alias Beast = 
  { name : String
  , maxHealth : Int
  , health : Int
  }

init : Beast
init =
  { name = "Wyrm"
  , maxHealth = 200
  , health = 200
  }
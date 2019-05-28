module Fighting exposing (healthAfterAttack)


type alias Fighter a =
    { a
        | health : Int
        , maxHealth : Int
        , strength : Int
        , defense : Int
    }


healthAfterAttack : Int -> Fighter a -> Fighter b -> Int
healthAfterAttack power attacker defender =
    addWithLimit defender.maxHealth defender.health <|
        modifiedPower power attacker defender


modifiedPower : Int -> Fighter a -> Fighter b -> Int
modifiedPower power attacker defender =
    round (toFloat power * (toFloat attacker.strength / toFloat defender.defense))


addWithLimit : Int -> Int -> Int -> Int
addWithLimit maximum base change =
    max (min (base + change) maximum) 0

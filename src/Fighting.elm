module Fighting exposing (attackDamage)


type alias Fighter a =
    { a
        | health : Int
        , maxHealth : Int
        , strength : Int
        , defense : Int
    }

attackDamage : Int -> Fighter a -> Fighter b -> Int
attackDamage power attacker defender =
    defender.health - healthAfterAttack power attacker defender

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

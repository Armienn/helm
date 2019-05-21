module Beast exposing (Beast, beastDecoder, viewBeast)

import CommonViews exposing (..)
import Html exposing (..)
import Json.Decode exposing (Decoder, at, int, string)


type alias Beast =
    { name : String
    , maxHealth : Int
    , health : Int
    }


viewBeast : Beast -> Html msg
viewBeast beast =
    div []
        [ viewName "Beast" beast.name
        , separator
        , viewHealth beast
        ]


beastDecoder : Decoder Beast
beastDecoder =
    Json.Decode.map3 Beast
        (at [ "species", "name" ] nameString)
        (at [ "stats", "5", "base_stat" ] int)
        (at [ "stats", "5", "base_stat" ] int)


nameString =
    Json.Decode.map transformName string


transformName : String -> String
transformName name =
    name
        |> listify
        |> groupConsecutive isSameLetterType
        |> List.map mangleLetterGroup
        |> List.map String.fromList
        |> String.join " "


listify : String -> List Char
listify name =
    List.filter (\c -> List.member c letters) (String.toList name)


letters =
    vocals ++ consonants


vocals =
    String.toList "aeyuio"


consonants =
    String.toList "qwrtpsdfghjklzxcvbnm"


isSameLetterType a b =
    isVocal a == isVocal b


isVocal char =
    List.member char vocals


mangleLetterGroup chars =
    chars


groupConsecutive : (a -> a -> Bool) -> List a -> List (List a)
groupConsecutive comparator list =
    groupConsecutiveHelp comparator [] list


groupConsecutiveHelp comparator resultSoFar list =
    case ( resultSoFar, list ) of
        ( (head :: innerTail) :: tail, first :: rest ) ->
            if comparator head first then
                groupConsecutiveHelp comparator ((first :: head :: innerTail) :: tail) rest

            else
                groupConsecutiveHelp comparator ([ first ] :: resultSoFar) rest

        ( _, first :: rest ) ->
            groupConsecutiveHelp comparator [ [ first ] ] rest

        _ ->
            List.reverse (List.map List.reverse resultSoFar)
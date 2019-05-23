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
        |> List.map (mangleLetterGroup name)
        |> List.map String.fromList
        |> String.join ""
        |> capitalise


listify : String -> List Char
listify name =
    List.filter (\c -> List.member c letters) (String.toList name)

capitalise: String -> String
capitalise text =
    case String.uncons text of
        Just (first, rest) ->
            String.cons (Char.toUpper first) rest
        _ ->
            text


letters =
    vocals ++ consonants


vocals =
    String.toList "eaiuyo"


consonants =
    String.toList "tpkqdbgcfzmxwsrvljhn"


firstVocal =
    'a'


firstConsonants =
    't'


isSameLetterType a b =
    isVocal a == isVocal b


isVocal char =
    List.member char vocals


mangleLetterGroup nameSeed chars =
    case chars of
        first :: _ ->
            if isVocal first then
                mangleVocals nameSeed chars

            else
                mangleConsonants nameSeed chars

        _ ->
            chars


mangleVocals nameSeed chars =
    case List.head chars of
        Just char ->
            [ elementAfter char firstVocal vocals ]

        _ ->
            [ firstVocal ]


mangleConsonants nameSeed chars =
    case List.head chars of
        Just char ->
            [ elementAfter char firstConsonants consonants ]

        _ ->
            [ firstConsonants ]


elementAfter element default list =
    case list of
        first :: second :: rest ->
            if first == element then
                second

            else
                elementAfter element default (second :: rest)

        _ ->
            default


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

module Main exposing (main)

import Battle
import Beast
import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Random


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


type Model
    = Loading
    | Failure
    | Battle Battle.Model


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, Random.generate NewPokemonId (Random.int 1 720) )


type Msg
    = NewPokemonId Int
    | GotBeast (Result Http.Error Beast.Beast)
    | GotBattleMsg Battle.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( NewPokemonId id, _ ) ->
            ( model, requestPokemon id )

        ( GotBeast (Ok beast), _ ) ->
            ( Battle (Battle.init beast), Cmd.none )

        ( GotBeast _, _ ) ->
            ( Failure, Cmd.none )

        ( GotBattleMsg battleMsg, Battle battle ) ->
            ( Battle (Battle.update battleMsg battle), Cmd.none )

        ( _, _ ) ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Battle battle ->
            Html.map GotBattleMsg (Battle.view battle)

        Loading ->
            div [] [ text "Loading" ]

        Failure ->
            div [] [ text "Failed to load beast" ]


requestPokemon : Int -> Cmd Msg
requestPokemon id =
    Http.get
        { url = "https://pokeapi.co/api/v2/pokemon/" ++ String.fromInt id
        , expect = Http.expectJson GotBeast Beast.beastDecoder
        }

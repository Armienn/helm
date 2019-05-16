module Main exposing (main)

import Battle
import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Http
import Random
import Json.Decode exposing (Decoder, field, string)


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
    | Success Battle.Battle


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, Random.generate NewPokemonId (Random.int 1 720) )


type Msg
    = GotPokemon (Result Http.Error String)
    | GotBattleMsg Battle.Msg
    | NewPokemonId Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( GotPokemon (Ok result), _ ) ->
            ( Success (Battle.init result), Cmd.none )

        ( GotPokemon _, _ ) ->
            ( Failure, Cmd.none )

        ( GotBattleMsg battleMsg, Success battle ) ->
            ( Success (Battle.update battleMsg battle), Cmd.none )

        ( NewPokemonId id, _ ) ->
            ( model, requestPokemon id )

        ( _, _ ) ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        Success battle ->
            Html.map GotBattleMsg (Battle.view battle)

        Loading ->
            div [] [ text "Loading" ]

        Failure ->
            div [] [ text "Failed to load beast" ]


requestPokemon : Int -> Cmd Msg
requestPokemon id =
    Http.get
        { url = "https://pokeapi.co/api/v2/pokemon/" ++ String.fromInt id
        , expect = Http.expectJson GotPokemon pokemonDecoder
        }


pokemonDecoder : Decoder String
pokemonDecoder =
    field "species" (field "name" string)

module Main exposing (main)

import Battle exposing (Msg(..))
import Beast
import Browser
import ChooseOpponent exposing (Msg(..))
import Helming
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
    | ChooseOpponent ChooseOpponent.Model
    | Battle Battle.Model


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, Random.generate NewPokemonIds (randomPokemonIds 3) )


type Msg
    = NewPokemonIds (List Int)
    | GotBeast (List Int) (List Beast.Beast) (Result Http.Error Beast.Beast)
    | GotChoiceMsg ChooseOpponent.Msg
    | GotBattleMsg Battle.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model ) of
        ( NewPokemonIds ids, _ ) ->
            ( model, requestPokemon ids [] )

        ( GotBeast [] beasts (Ok beast), Battle battle ) ->
            ( ChooseOpponent { beasts = beast :: beasts, hero = battle.hero }, Cmd.none )

        ( GotBeast [] beasts (Ok beast), _ ) ->
            ( ChooseOpponent { beasts = beast :: beasts, hero = Helming.init }, Cmd.none )

        ( GotBeast ids beasts (Ok beast), m ) ->
            ( m, requestPokemon ids (beast :: beasts) )

        ( GotBeast _ _ _, _ ) ->
            ( Failure, Cmd.none )

        ( GotChoiceMsg (Choose beast), ChooseOpponent choiceModel ) ->
            ( Battle { beast = beast, hero = choiceModel.hero }, Cmd.none )

        ( GotBattleMsg battleMsg, Battle battle ) ->
            case battleMsg of
                Run ->
                    ( Battle battle, Random.generate NewPokemonIds (randomPokemonIds 3) )

                _ ->
                    ( Battle (Battle.update battleMsg battle), Cmd.none )

        ( _, _ ) ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        ChooseOpponent opponents ->
            Html.map GotChoiceMsg (ChooseOpponent.view opponents)

        Battle battle ->
            Html.map GotBattleMsg (Battle.view battle)

        Loading ->
            div [] [ text "Loading" ]

        Failure ->
            div [] [ text "Failed to load beasts" ]


requestPokemon : List Int -> List Beast.Beast -> Cmd Msg
requestPokemon ids loadedBeasts =
    case ids of
        first :: rest ->
            Http.get
                { url = "https://pokeapi.co/api/v2/pokemon/" ++ String.fromInt first
                , expect = Http.expectJson (GotBeast rest loadedBeasts) Beast.beastDecoder
                }

        _ ->
            Cmd.none


numberOfPokemon =
    800


randomPokemonIds : Int -> Random.Generator (List Int)
randomPokemonIds count =
    Random.list count (Random.int 1 numberOfPokemon)

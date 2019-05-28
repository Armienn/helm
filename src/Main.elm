module Main exposing (main)

import Battle exposing (Model(..), Msg(..))
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
    = Loading Helming.Helming
    | Failure
    | ChooseOpponent ChooseOpponent.Model
    | Battle Battle.Model


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading Helming.init, Random.generate NewPokemonIds (randomPokemonIds 3) )


type Msg
    = NewPokemonIds (List Int)
    | GotBeast (List Int) (List Beast.Beast) (Result Http.Error Beast.Beast)
    | GotChoiceMsg ChooseOpponent.Msg
    | GotBattleMsg Battle.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        Loading m ->
            updateLoading msg m

        ChooseOpponent m ->
            updateChooseOpponent msg m

        Battle m ->
            updateBattle msg m

        _ ->
            ( model, Cmd.none )


updateLoading : Msg -> Helming.Helming -> ( Model, Cmd Msg )
updateLoading msg helming =
    case msg of
        NewPokemonIds ids ->
            ( Loading helming, requestPokemon ids [] )

        GotBeast [] beasts (Ok beast) ->
            ( ChooseOpponent { beasts = beast :: beasts, hero = helming }, Cmd.none )

        GotBeast ids beasts (Ok beast) ->
            ( Loading helming, requestPokemon ids (beast :: beasts) )

        GotBeast _ _ _ ->
            ( Failure, Cmd.none )

        _ ->
            ( Loading helming, Cmd.none )


updateBattle : Msg -> Battle.Model -> ( Model, Cmd Msg )
updateBattle msg battle =
    case msg of
        GotBattleMsg battleMsg ->
            let
                newState =
                    Battle.update battleMsg battle
            in
            case newState of
                Finished helming ->
                    ( Loading helming, Random.generate NewPokemonIds (randomPokemonIds 3) )

                _ ->
                    ( Battle newState, Cmd.none )

        _ ->
            ( Battle battle, Cmd.none )


updateChooseOpponent : Msg -> ChooseOpponent.Model -> ( Model, Cmd Msg )
updateChooseOpponent msg model =
    case msg of
        GotChoiceMsg (Choose beast) ->
            ( Battle (Battle.Fight model.hero beast), Cmd.none )

        _ ->
            ( ChooseOpponent model, Cmd.none )


view : Model -> Html Msg
view model =
    case model of
        ChooseOpponent opponents ->
            Html.map GotChoiceMsg (ChooseOpponent.view opponents)

        Battle battle ->
            Html.map GotBattleMsg (Battle.view battle)

        Loading _ ->
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

module Update exposing(..)

import Messages exposing(Msg(..))
import Models exposing(Model)
import Material

import Navigation
import Routing exposing(Route(..), parseLocation)

changeUrlCommand : Model -> Route -> Cmd Msg
changeUrlCommand model route =
  case route of
    HomeRoute ->
      Cmd.none
    FoodRoute ->
      Cmd.none
    IntroRoute ->
      Cmd.none
    _ ->
      Cmd.none

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Weight weight ->
      let
        input = model.input
        newInput = { input | weight = Result.withDefault 70 ( String.toFloat ( weight ) ) }
      in
        ( { model | input = newInput }, Cmd.none)

    WeightFatRate rate ->
      let
        input = model.input
        newInput = { input | weight_fat_rate = Result.withDefault 70 ( String.toFloat ( rate ) ) }
      in
        ( { model | input = newInput }, Cmd.none)

    TrainingTime time ->
      let
        input = model.input
        newInput = { input | training_time = Result.withDefault 70 ( String.toFloat ( time ) ) }
      in
        ( { model | input = newInput }, Cmd.none)

    Submit ->
      ( model, Cmd.none )

    Mdl msg_ ->
      Material.update Mdl msg_ model

    NewUrl url ->
      model ! [ Navigation.newUrl url ]

    OnLocationChange location ->
      let
        newRoute =
          parseLocation location
      in
        ( { model | route = newRoute }, changeUrlCommand model newRoute )
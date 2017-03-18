module Update exposing(..)

import Messages exposing(Msg(..))
import Models exposing(Model)
import Material

import Navigation
import Routing exposing(Route(..), parseLocation)
import Config exposing(invalidValue)

changeUrlCommand : Model -> Route -> Cmd Msg
changeUrlCommand model route =
  case route of
    HomeRoute ->
      Cmd.none
    InfoCollectionRoute ->
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
        inputValues = model.inputValues
        newInputValues = { inputValues | weight = Just ( Result.withDefault invalidValue ( String.toFloat ( weight ) ) ) }
      in
        ( { model | inputValues = newInputValues }, Cmd.none)

    WeightFatRate rate ->
      let
        inputValues = model.inputValues
        newInputValues = { inputValues | weight_fat_rate = Just ( Result.withDefault invalidValue ( String.toFloat ( rate ) ) ) }
      in
        ( { model | inputValues = newInputValues }, Cmd.none)

    TrainingTime time ->
      let
        inputValues = model.inputValues
        newInputValues = { inputValues | training_time = Just ( Result.withDefault invalidValue ( String.toFloat ( time ) ) ) }
      in
        ( { model | inputValues = newInputValues }, Cmd.none)

    Submit ->
      ( model, Cmd.none )

    Mdl msg_ ->
      Material.update Mdl msg_ model

    SelectTab num ->
      ( { model | selectedTab = num }, Cmd.none )

    NewUrl url ->
      model ! [ Navigation.newUrl url ]

    OnLocationChange location ->
      let
        newRoute =
          parseLocation location
      in
        ( { model | route = newRoute }, changeUrlCommand model newRoute )
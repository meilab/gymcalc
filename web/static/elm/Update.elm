module Update exposing(..)

import Messages exposing(Msg(..))
import Models exposing(Model, InputValues, FundamentalValues, MetabolismValues, NutritionValue)
import Material

import Navigation
import Routing exposing(Route(..), parseLocation, tabsUrls, urlTabs)
import Config exposing(invalidValue)
import Array exposing(Array)
import Dict exposing(Dict)

changeUrlCommand : Model -> Route -> Cmd Msg
changeUrlCommand model route =
  case route of
    HomeRoute ->
      let isInfoCollectFinished =
            model.inputValues.weight /= Nothing
            && model.inputValues.weight_fat_rate /= Nothing
            && model.inputValues.training_time /= Nothing
      in
        case isInfoCollectFinished of
          True ->
            Cmd.none
          False ->
            Navigation.newUrl ( model.url.src_url ++ "/infocollection")

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

    SelectNutritionTab num ->
      ( { model | selectedNutritionTab = num }, Cmd.none )

    SelectMenuTab num ->
      let
        url =
          Array.get num ( tabsUrls model.url.src_url )
          |> Maybe.withDefault model.url.src_url
      in
        ( { model | selectedMenuTab = num }, Navigation.newUrl url )

    NewUrl url ->
      model ! [ Navigation.newUrl url ]

    OnLocationChange location ->
      let
        newRoute =
          parseLocation location model.url.src_url

        newSelectedMenuTab =
          Dict.get location.pathname ( urlTabs model.url.src_url )
          |> Maybe.withDefault -1
      in
        ( { model | route = newRoute, selectedMenuTab = newSelectedMenuTab }, changeUrlCommand model newRoute )

    TriggerCalc ->
      let
        newFundamental = calcFundamental model.inputValues
        newMetabolism = calcMetabolism model.inputValues newFundamental.weight_in_pound newFundamental.thin_weight_in_pound
        newHighDayNutrition = calcNutrition newMetabolism.total 0.1625 0.0625 0.011111111 350 150 20
        newLowDayNutrition = calcNutrition newMetabolism.total 0.0375 0.0875 0.055555556 80 180 120
      in
        ( { model | fundamental = newFundamental
                    , metabolism = newMetabolism
                    , highDayNutrition = newHighDayNutrition
                    , lowDayNutrition = newLowDayNutrition
          }
        , Navigation.newUrl model.url.src_url
        )



calcFundamental : InputValues -> FundamentalValues
calcFundamental inputValue =
  let
    weight_in_pound = 
      case inputValue.weight of
        Just numWeight ->
          numWeight * 2.2
        Nothing ->
          0

    fat_in_pound =
      case inputValue.weight_fat_rate of
        Just numFatRat ->
          weight_in_pound * numFatRat
        Nothing ->
          0

    thin_weight_in_pound = weight_in_pound - fat_in_pound
  in    
    { weight_in_pound = weight_in_pound
    , fat_in_pound = fat_in_pound
    , thin_weight_in_pound = thin_weight_in_pound
    }

calcMetabolism : InputValues -> Float -> Float -> MetabolismValues
calcMetabolism inputValue weight_in_pound thin_weight_in_pound=
  let
    training =
      case inputValue.training_time of
        Just training_time ->
          ( weight_in_pound / 2.2 ) * 0.086 * training_time
        Nothing ->
          0

    fundamental = thin_weight_in_pound * 12.5
  in
    { fundamental = fundamental
    , training = training
    , total = fundamental + training
    }

calcNutrition : Float -> Float -> Float -> Float  -> Int -> Int -> Int -> List NutritionValue
calcNutrition totalMetabolism carboFactor proteinFactor fatFactor actualCarbohydrate actualProtein actualFat =
    [ { material = "碳水化物"
      , quantity = round ( totalMetabolism * carboFactor )
      , actualQuantity = actualCarbohydrate
      }
    , { material = "蛋白质"
      , quantity = round ( totalMetabolism * proteinFactor )
      , actualQuantity = actualProtein
      }
    , { material = "脂肪"
      , quantity = round ( totalMetabolism * fatFactor )
      , actualQuantity = actualFat
      }
  ]


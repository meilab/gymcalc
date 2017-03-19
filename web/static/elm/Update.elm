module Update exposing(..)

import Messages exposing(Msg(..))
import Models exposing(Model, InputValues, FundamentalValues, MetabolismValues, HighDayNutrition, LowDayNutrition)
import Material

import Navigation
import Routing exposing(Route(..), parseLocation)
import Config exposing(invalidValue, src_url)

changeUrlCommand : Model -> Route -> Cmd Msg
changeUrlCommand model route =
  case route of
    HomeRoute ->
      let isInfoCollectFinished =
            model.inputValues.weight /= Nothing
            || model.inputValues.weight_fat_rate /= Nothing
            || model.inputValues.training_time /= Nothing
      in
        case isInfoCollectFinished of
          True ->
            Cmd.none
          False ->
            Navigation.newUrl ( src_url ++ "/infocollection")

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

    TriggerCalc ->
      let
        newFundamental = calcFundamental model.inputValues
        newMetabolism = calcMetabolism model.inputValues newFundamental.weight_in_pound newFundamental.thin_weight_in_pound
        newHighDayNutrition = calcHighDayNutrition newMetabolism.total
        newLowDayNutrition = calcLowDayNutrition newMetabolism.total
      in
        ( { model | fundamental = newFundamental
                    , metabolism = newMetabolism
                    , highDayNutrition = newHighDayNutrition
                    , lowDayNutrition = newLowDayNutrition
          }
        , Navigation.newUrl src_url
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

calcHighDayNutrition : Float -> HighDayNutrition
calcHighDayNutrition totalMetabolism =
    [ { material = "碳水化物"
      , quantity = totalMetabolism * 0.65 / 4
      }
    , { material = "蛋白质"
      , quantity = totalMetabolism * 0.25 / 4
      }
    , { material = "脂肪"
      , quantity = totalMetabolism * 0.1 / 9
      }
  ]

calcLowDayNutrition : Float -> LowDayNutrition
calcLowDayNutrition totalMetabolism =
  [ { material = "碳水化物"
    , quantity = totalMetabolism * 0.15 / 4
    }
  , { material = "蛋白质"
    , quantity = totalMetabolism * 0.35 / 4
    }
  , { material = "脂肪"
    , quantity = totalMetabolism * 0.5 / 9
    }
  ]

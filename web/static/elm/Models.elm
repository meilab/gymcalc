module Models exposing(..)

import Material
import Routing exposing(Route)
import Maybe exposing(Maybe)

type alias FundamentalValues =
  { weight_in_pound : Float
  , fat_in_pound : Float
  , thin_weight_in_pound : Float
  }

type alias MetabolismValues =
  { fundamental : Float
  , training : Float
  , total : Float
  }

type alias NutritionValue =
  { material : String
  , quantity : Int
  , actualQuantity : Int
  }

type alias HighDayNutrition = List NutritionValue

type alias LowDayNutrition = List NutritionValue

nutritionConstructor : List NutritionValue
nutritionConstructor =
  [ { material = "碳水化物"
    , quantity = 76
    , actualQuantity = 80
    }
  , { material = "蛋白质"
    , quantity = 177
    , actualQuantity = 180
    }
  , { material = "脂肪"
    , quantity = 112
    , actualQuantity = 120
    }
  ]

type alias InputFood =
  { name : String
  , quantity : Maybe Float
  }

type alias InputValues =
  { weight : Maybe Float
  , weight_fat_rate : Maybe Float
  , training_time : Maybe Float
  , foods : List InputFood
  }

type alias Model =
  { mdl : Material.Model
  , selectedTab : Int
  , route : Routing.Route
  , inputValues : InputValues
  , fundamental : FundamentalValues
  , metabolism : MetabolismValues
  , highDayNutrition : HighDayNutrition
  , lowDayNutrition : LowDayNutrition
  }

initialModel : Route -> Model
initialModel route =
    { mdl = Material.model
    , selectedTab = 0
    , route = route
    , inputValues = InputValues Nothing Nothing Nothing []
    , fundamental = FundamentalValues 0 0 0
    , metabolism = MetabolismValues 0 0 0
    , highDayNutrition = nutritionConstructor
    , lowDayNutrition = nutritionConstructor
    }

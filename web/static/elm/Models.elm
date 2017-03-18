module Models exposing(Model, initialModel)

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

type alias InputValues =
  { weight : Maybe Float
  , weight_fat_rate : Maybe Float
  , training_time : Maybe Float
  }

type alias Model =
  { mdl : Material.Model
  , selectedTab : Int
  , route : Routing.Route
  , inputValues : InputValues
  , fundamental : FundamentalValues
  , metabolism : MetabolismValues
  }

initialModel : Route -> Model
initialModel route =
    { mdl = Material.model
    , selectedTab = 0
    , route = route
    , inputValues = InputValues Nothing Nothing Nothing
    , fundamental = FundamentalValues 0 0 0
    , metabolism = MetabolismValues 0 0 0
    }

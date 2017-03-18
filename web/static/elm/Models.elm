module Models exposing(Model, initialModel)

import Material
import Routing exposing(Route)

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
  { weight : Float
  , weight_fat_rate : Float
  , training_time : Float
  }

type alias Model =
  { mdl : Material.Model
  , route : Routing.Route
  , input : InputValues
  , fundamental : FundamentalValues
  , metabolism : MetabolismValues
  }

initialModel : Route -> Model
initialModel route =
    { mdl = Material.model
    , route = route
    , input = InputValues 0 0 0
    , fundamental = FundamentalValues 0 0 0
    , metabolism = MetabolismValues 0 0 0
    }

module Messages exposing(..)

import Material
import Navigation exposing(Location)

type Msg
  = Weight String
  | WeightFatRate String
  | TrainingTime String
  | Submit
  | Mdl (Material.Msg Msg)
  | SelectTab Int
  | NewUrl String
  | OnLocationChange Location
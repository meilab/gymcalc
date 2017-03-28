module Data exposing(..)

-- This is per gram
type alias FoodInfo =
  { name : String
  , protein : Float
  , fat : Float
  , carbohydrate : Float
  , note : String
  , defaultQuantity : Int
  }

foodCollection : List FoodInfo
foodCollection =
  [ { name = "煮鸡蛋"
    , protein = 0.121
    , fat = 0.105
    , carbohydrate = 0.021
    , note = "51g/个"
    , defaultQuantity = 51
    }
  , { name = "蛋白"
    , protein = 0.116
    , fat = 0.001
    , carbohydrate = 0.031
    , note = "31g/个"
    , defaultQuantity = 31
    }
  , { name = "烤鸡胸"
    , protein = 0.182
    , fat = 0.047
    , carbohydrate = 0.024
    , note = ""
    , defaultQuantity = 100
    }
  , { name = "牛肉"
    , protein = 0.162
    , fat = 0.028
    , carbohydrate = 0.023
    , note = ""
    , defaultQuantity = 100
    }
  , { name = "米饭"
    , protein = 0.026
    , fat = 0.003
    , carbohydrate = 0.762
    , note = ""
    , defaultQuantity = 135
    }
  ]
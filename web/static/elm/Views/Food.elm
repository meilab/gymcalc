module Views.Food exposing(..)

import Data exposing(..)

import Html exposing (..)
import Html.Attributes exposing(..)
import Messages exposing (Msg(..))
import Models exposing (Model, NutritionValue)
import Markdown
import Material.Layout as Layout
import Material.Options as Options exposing (css, cs, when)
import Material.Icon as Icon
import Material.Textfield as Textfield
import Material.List as Lists
import Material.Color as Color
import Material.Scheme
import Material.Button as Button
import Material.Tabs as Tabs
import Material.Table as Table

foodList : Html Msg
foodList  =
  Table.table
  [ css "display" "flex"
  , css "flex-direction" "column"
  , css "align-items" "center"
  ]
  [ Table.thead []
    [ Table.tr []
      [ Table.th [] [ text "食物" ]
      , Table.th [] [ text "蛋白质" ]
      , Table.th [] [ text "脂肪" ]
      , Table.th [] [ text "碳水" ]
      , Table.th [] [ text "Tips" ]
      ]
    ]
  , Table.tbody []
      ( foodCollection |> List.map ( \item ->
        Table.tr []
          [ Table.td [] [ text item.name ]
          , Table.td [ Table.numeric ] [ text ( toString item.protein ) ]
          , Table.td [ Table.numeric ] [ text ( toString item.fat ) ]
          , Table.td [ Table.numeric ] [ text ( toString item.carbohydrate ) ]
          , Table.td [ Table.numeric ] [ text item.note ]
          ]
        )
      )
  ]
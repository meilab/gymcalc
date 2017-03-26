module Views.Food exposing(..)

import Data exposing(foodCollection, FoodInfo)

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
import Material.Card as Card
import Material.Grid as Grid exposing (grid, size, cell, Device(..))
import Views.Helpers exposing(..)

foodAsCards : Html Msg
foodAsCards =
  foodCollection
    |> List.map (\elem -> smallCell [ foodCard elem ])
    |> grid []

foodCard : FoodInfo -> Html Msg
foodCard foodInfo =
  Card.view
    [ css "width" "100%"
    , css "margin" "2rem"
    -- , Color.background (Color.color Color.BlueGrey Color.S400)
    , css "background-color" "white"
    , Options.onClick ( SendCmds token exhibitionId deviceEndpointId scene.actions )
    ]
    [ Card.title
      [ css "display" "flex"
      , css "align-content" "flex-start"
      , css "flex-direction" "column"
      , css "align-items" "center"
      , css "justify-content" "space-between"
      ]
      [ Options.styled Html.img
        [ Options.attribute <| src "/images/exhibition/ctrl.png"
        , css "width" "80px"
        , css "height" "80px"
        ]
        []
    --   , Options.styled Html.div
    --     []
        -- [ Card.head
        --     -- [ white
        --     -- , Options.scrim 0.75
        --     -- , css "padding" "16px"
        --     -- -- Restore default padding inside scrim
        --     -- , css "width" "100%"
        --     -- ]
        --     -- [ text scene.name ]
        -- ]
      , Card.subhead 
        [ css "color" "black" ]
        [ text scene.name  ]
      ]
    --   , Card.text [][ text exhibition.address ]
    ]

foodList : Html Msg
foodList =
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
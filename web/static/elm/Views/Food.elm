module Views.Food exposing(..)

import Data exposing(foodCollection, FoodInfo)

import Html exposing (..)
import Html.Attributes exposing(..)
import Messages exposing (Msg(..))
import Models exposing (Model, NutritionValue, SelectedFoods)
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
import Helpers exposing(..)
import Material.Typography as Typography

foodAsCards : Model -> Html Msg
foodAsCards model =
  foodCollection
    |> List.map (\elem -> smallCell [ foodCard model elem ])
    |> grid []

foodCard : Model -> FoodInfo -> Html Msg
foodCard model foodInfo =
  Card.view
    [ css "width" "100%"
    -- , css "margin" "2rem"
    -- , Color.background (Color.color Color.BlueGrey Color.S400)
    -- , css "background-color" "white"
    , Color.background (Color.color Color.LightBlue Color.S400)
    -- , Options.onClick ( SendCmds token exhibitionId deviceEndpointId scene.actions )
    ]
    [ Card.title
      [ css "display" "flex"
      , css "align-content" "flex-start"
      , css "flex-direction" "column"
      , css "align-items" "center"
      , css "justify-content" "space-between"
      ]
      [ Card.head
        [ white
        -- , Options.scrim 0.75
        -- , css "padding" "16px"
        -- Restore default padding inside scrim
        -- , css "width" "100%"
        ]
        [ text foodInfo.name ]
      , Card.subhead 
        [ css "color" "black" ]
        [ text ( "蛋白质: " ++ toString( foodInfo.protein ) )  ]
      , Card.subhead 
        [ css "color" "black" ]
        [ text ( "脂肪: " ++ toString( foodInfo.fat ) )  ]
      , Card.subhead 
        [ css "color" "black" ]
        [ text ( "碳水化物: " ++ toString( foodInfo.carbohydrate ) )  ]
      ]
      , Card.text [][ text foodInfo.note ]
      , Card.actions
        [ Card.border, css "vertical-align" "center", css "text-align" "right", white ]
        [ Options.span [ Typography.caption, Typography.contrast 0.87 ] [ text ( toString foodInfo.defaultQuantity ) ]
        , Button.render Mdl
          [ 8, 1 ]
          model.mdl
          [ Button.icon
          , Button.ripple
          , Options.onClick ( AddFood foodInfo.name foodInfo.defaultQuantity )
          ]
          [ Icon.i "add"
          -- , Icon.i "favorite_border"
          ]
        ]
    ]

selectedFoodList : List SelectedFoods -> Html Msg
selectedFoodList selectedFood =
  Table.table
  [ css "display" "flex"
  , css "flex-direction" "column"
  , css "align-items" "center"
  ]
  [ Table.thead []
    [ Table.tr []
      [ Table.th [] [ text "食物" ]
      , Table.th [] [ text "克" ]
      , Table.th [] [ text "删除" ]
      ]
    ]
  , Table.tbody []
      ( selectedFood |> List.map ( \(name, quantity) ->
        Table.tr []
          [ Table.td [] [ text name ]
          , Table.td [ Table.numeric ] [ text ( toString quantity ) ]
          , Table.td [ Table.numeric ] [ Icon.i "favorite_border" ]
          ]
        )
      )
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
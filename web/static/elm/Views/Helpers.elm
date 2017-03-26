module Views.Helpers exposing (..)

import Html exposing (Html, text, span)
import Material.Layout as Layout
-- import Routing exposing (Route(..))
import Messages exposing (Msg)
import Material.Options as Options exposing (Style, css, cs, when)
import Material.Color as Color
import Material.Grid as Grid exposing (grid, size, cell, Device(..))

defaultHeader : String -> List (Html Msg)
defaultHeader headerText =
  [ Layout.row
    rowStyle
    [ Layout.title titleStyle [ text headerText]
    ]
  ]

defaultHeaderWithNavigation : String -> List (Html Msg) -> List (Html Msg)
defaultHeaderWithNavigation headerText navigation =
  [ Layout.row
    rowStyle
    [ Layout.title titleStyle [ text headerText]
    , Layout.spacer
    , Layout.navigation []
        navigation
    ]
  ]

titleStyle : List (Options.Property c m)
titleStyle =
  [ css "display" "flex"
  , css "flex-direction" "row"
  , css "justify-content" "space-around"
  ]

rowStyle : List (Options.Property c m)
rowStyle =
  [ Color.background <| Color.color Color.Teal Color.S500
  , Color.text <| Color.color Color.Grey Color.S900
  ]

white : Options.Property a b
white =
    Color.text Color.white

cellStyle : List (Style a)
cellStyle =
    [ css "text-sizing" "border-box"
    -- , css "background-color" "#BDBDBD"
    -- , css "height" (toString h ++ "px")
    -- , css "padding-left" "8px"
    -- , css "padding-top" "4px"
    , css "color" "white"
    ]

bigCell : List (Html a) -> Grid.Cell a 
bigCell =
  itemCell [ size All 4, size Desktop 6 ]

smallCell : List (Html a) -> Grid.Cell a 
smallCell =
  itemCell [ size All 2, size Desktop 3 ]


itemCell :  List (Style a) -> List (Html a) -> Grid.Cell a 
itemCell styling =
  cell <| List.concat [ cellStyle, styling ]
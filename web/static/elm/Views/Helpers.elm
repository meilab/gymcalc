module Views.Helpers exposing (defaultHeader, defaultHeaderWithNavigation)

import Html exposing (Html, text, span)
import Material.Layout as Layout
-- import Routing exposing (Route(..))
import Messages exposing (Msg)
import Material.Options as Options exposing (css, cs, when)
import Material.Color as Color

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
  [ Color.background <| Color.color Color.Grey Color.S100
  , Color.text <| Color.color Color.Grey Color.S900
  ]
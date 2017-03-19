module Views exposing (..)

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
import Routing exposing(Route(..))
import Config exposing(invalidValue)

import Views.Food exposing(foodList)
import Views.Helpers exposing(defaultHeader)


styles : String
styles =
    """
   .demo-options .mdl-checkbox__box-outline {
      border-color: rgba(255, 255, 255, 0.89);
    }

   .mdl-layout__drawer {
      border: none !important;
   }

   .mdl-layout__drawer .mdl-navigation__link:hover {
      background-color: #00BCD4 !important;
      color: #37474F !important;
    }
   """

view : Model -> Html Msg
view model =
  Material.Scheme.top <|
    Layout.render Mdl
      model.mdl
      [ Layout.fixedHeader
      , Layout.fixedDrawer
      , Options.css "display" "flex !important"
      , Options.css "flex-direction" "row"
      , Options.css "align-items" "center"
      ]
      { header = viewHeader model
      , drawer = [ drawerHeader model, viewDrawer model ]
      , tabs = ([], [])
      , main =
        [ viewBody model ]
      }

viewHeader : Model -> List (Html Msg)
viewHeader model =
  case model.route of
    HomeRoute ->
      defaultHeader "营养建议"
    InfoCollectionRoute ->
      defaultHeader "请输入锻炼指标"
    FoodRoute ->
      defaultHeader "营养元素(单位: 克／克)"
    IntroRoute ->
      defaultHeader "三分练七分吃"
    NotFoundRoute ->
      defaultHeader "找不到您要的网站"

type alias MenuItem =
  { text: String
  , iconName : String
  , route : Route
  }

menuItem : List MenuItem
menuItem =
  [ { text = "计算结果", iconName = "apps", route = HomeRoute }
  , { text = "数据输入", iconName = "list", route = InfoCollectionRoute }
  , { text = "健康饮食", iconName = "dashboard", route = FoodRoute }
  , { text = "产品简介", iconName = "dashboard", route = IntroRoute }
  ]


viewDrawerMenuItem : Model -> MenuItem -> Html Msg
viewDrawerMenuItem model menuItem =
  let
    isCurrentLocation =
      model.route == menuItem.route

    onClickCmd =
      case ( isCurrentLocation, menuItem.route ) of
        ( False, route ) ->
          route |> Routing.urlFor |> NewUrl |> Options.onClick

        _ ->
          Options.nop
  in
    Layout.link
      [ onClickCmd
      , when isCurrentLocation (Color.background <| Color.color Color.BlueGrey Color.S600)
      , Options.css "color" "rgba(255, 255, 255, 0.56)"
      , Options.css "font-weight" "500"
      ]
      [ 
        Icon.view menuItem.iconName
        [ Color.text <| Color.color Color.BlueGrey Color.S500
        , Options.css "margin-right" "32px"
        ]
      , text menuItem.text
      ]


viewDrawer : Model -> Html Msg
viewDrawer model =
  Layout.navigation
    [ Color.background <| Color.color Color.BlueGrey Color.S800
    , Color.text <| Color.color Color.BlueGrey Color.S50
    , Options.css "flex-grow" "1"
    ]
  <|
    ( List.map (viewDrawerMenuItem model) menuItem )

drawerHeader : Model -> Html Msg
drawerHeader model =
  Options.styled Html.header
    [ css "display" "flex"
    , css "box-sizing" "border-box"
    , css "justify-content" "flex-end"
    , css "padding" "16px"
    , css "height" "151px"
    , css "flex-direction" "column"
    , cs "demo-header"
    , Color.background <| Color.color Color.BlueGrey Color.S900
    , Color.text <| Color.color Color.BlueGrey Color.S50
    ]
    [ Options.styled Html.img
        [ Options.attribute <| src "images/elm.png"
        , css "width" "48px"
        , css "height" "48px"
        , css "border-radius" "24px"
        ]
        []
      , Options.styled Html.div
        [ css "display" "flex"
        , css "flex-direction" "row"
        , css "align-items" "center"
        , css "width" "100%"
        , css "position" "relative"
        ]
        [ Html.span [][ text "Come On!"]]
    ]


viewBody : Model -> Html Msg
viewBody model =
  case model.route of
    HomeRoute ->
      homeView model
    InfoCollectionRoute ->
      infoCollectionView model
    FoodRoute ->
      foodList
    IntroRoute ->
      introView
    NotFoundRoute ->
      notFoundView


homeView : Model -> Html Msg
homeView model =
  Tabs.render Mdl [0] model.mdl
  [ Tabs.ripple
  , Tabs.onSelectTab SelectTab
  , Tabs.activeTab model.selectedTab
  ]
  [ Tabs.label
      [ Options.center ]
      [ Icon.i "info_outline"
      , Options.span [ css "width" "4px" ] []
      , text "高碳日营养"
      ]
  , Tabs.label
      [ Options.center ]
      [ Icon.i "code"
      , Options.span [ css "width" "4px" ] []
      , text "低碳日营养"
      ]
  ]
  [ case model.selectedTab of
      0 -> nutriList model.highDayNutrition
      _ -> nutriList model.lowDayNutrition
  ]


nutriList : List NutritionValue -> Html Msg
nutriList nutritionList =
  Table.table
  [ css "display" "flex"
  , css "flex-direction" "column"
  , css "align-items" "center"
  ]
  [ Table.thead []
    [ Table.tr []
      [ Table.th [] [ text "营养元素" ]
      , Table.th [] [ text "数量" ]
      , Table.th [] [ text "单位" ]
      ]
    ]
  , Table.tbody []
      ( nutritionList |> List.map ( \item ->
        Table.tr []
          [ Table.td [] [ text item.material ]
          , Table.td [ Table.numeric ] [ text ( toString item.quantity ) ]
          , Table.td [ Table.numeric ] [ text "克" ]
          ]
        )
      )
  ]


infoCollectionView : Model -> Html Msg
infoCollectionView model =
  Lists.ul
    [ css "display" "flex"
    , css "flex-direction" "column"
    , css "align-items" "center"
    ]
    [ Lists.li []
      [ Lists.content []
        [ Lists.icon "inbox" []
        , Textfield.render Mdl [1] model.mdl
          [ Textfield.label ( inputLabel "请输入体重(公斤): 例如 75" "公斤" model.inputValues.weight )
          , Options.onInput Weight
          , Textfield.floatingLabel
          , Textfield.text_
          , Textfield.error ("请输入有效数字: 例如 75")
            |> Options.when ( valueValidation model.inputValues.weight  3 200)
          ]
          []
        ]
      ]
    , Lists.li []
      [ Lists.content []
        [ Lists.icon "send" []
        , Textfield.render Mdl [2] model.mdl
          [ Textfield.label ( inputLabel "请输入体脂率: 例如 0.23" " :体脂率" model.inputValues.weight_fat_rate )
          , Options.onInput WeightFatRate
          , Textfield.floatingLabel
          , Textfield.text_
          , Textfield.error ("请输入有效数字: 例如 0.23")
            |> Options.when ( valueValidation model.inputValues.weight_fat_rate 0.1 0.7)
          ]
          []
        ]
      ]
    , Lists.li []
      [ Lists.content []
        [ Lists.icon "time" []
        , Textfield.render Mdl [3] model.mdl
          [ Textfield.label ( inputLabel "请输入训练时长: 例如 90" " 分钟训练时间" model.inputValues.training_time )
          , Options.onInput TrainingTime
          , Textfield.floatingLabel
          , Textfield.text_
          , Textfield.error ("请输入有效数字: 例如 90")
            |> Options.when ( valueValidation model.inputValues.training_time 1 1440)
          ]
          []
        ]
      ]
      , Lists.li []
        [ Lists.content []
          [ Lists.icon "time" []
          , Button.render Mdl [4] model.mdl
            [ Button.raised
            , Button.colored
            , Options.onClick TriggerCalc
            ]
            [ text "计算所需营养"]
          ]
        ]
    ]


valueValidation : Maybe Float -> Float -> Float -> Bool
valueValidation maybeNum minValue maxValue =
  case maybeNum of
    Just num ->
      num == invalidValue
    Nothing ->
      False


inputLabel : String -> String -> Maybe Float -> String
inputLabel defaultMesssage append inputNum =
  case inputNum of
    Just num ->
      if ( num == invalidValue ) then
        "请输入有效数字"
      else
         toString num ++ append
    Nothing ->
      defaultMesssage

introView : Html Msg
introView =
  Markdown.toHtml [] markdown

markdown: String
markdown = """
# 三分练七分吃

[Markdown](http://daringfireball.net/projects/markdown/) lets you
write content in a really natural way.

  * You can have lists, like this one
"""

notFoundView : Html Msg
notFoundView =
  div []
    [ text "没有找到您要的网址" ]


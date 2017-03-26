module Routing exposing(..)

import Navigation exposing (Location)
import UrlParser exposing (..)
import Maybe exposing(Maybe)
import Html exposing(Html, text)
import Array exposing(Array)
import Dict exposing(Dict)

type Route
  = HomeRoute
  | InfoCollectionRoute
  | FoodRoute
  | IntroRoute
  | NotFoundRoute

parseAppend : String -> Parser a a -> Parser a a
parseAppend src_url item =
  src_url
  |> String.dropLeft 1
  |> String.split "/"
  |> List.map ( s )
  |> List.reverse
  |> List.foldl ( </> )( item )

matchers : String -> Parser (Route -> a) a
matchers src_url =
  oneOf
    [ map HomeRoute ( parseAppend src_url top ) 
    , map InfoCollectionRoute ( parseAppend src_url ( s "infocollection" ) )
    , map FoodRoute ( parseAppend src_url ( s "food" ) )
    , map IntroRoute ( parseAppend src_url ( s "intro" ) )
    ]

parseLocation : Location -> String -> Route
parseLocation location src_url =
  case ( parsePath ( matchers src_url ) location ) of
    Just route ->
      route
    Nothing ->
      NotFoundRoute

urlFor : String -> Route -> String
urlFor src_url route =
  case route of
    HomeRoute ->
      src_url
    InfoCollectionRoute ->
      src_url ++ "/infocollection"
    FoodRoute ->
      src_url ++ "/food"
    IntroRoute ->
      src_url ++ "/intro"
    NotFoundRoute ->
      src_url

routingItem : String -> List ( String, String, Route, String )
routingItem src_url =
  [ ( "计算结果", "apps", HomeRoute, src_url )
  , ( "数据输入", "list", InfoCollectionRoute, src_url ++ "/infocollection" )
  , ( "健康饮食", "dashboard", FoodRoute, src_url ++ "/food" )
  , ( "产品简介", "dashboard", IntroRoute, src_url ++ "/intro" )
  ]

tabsTitles : String -> List (Html a)
tabsTitles src_url =
  routingItem src_url
  |> List.map (\(title, _, _, _) -> (text title))

tabsUrls : String -> Array String
tabsUrls src_url =
  routingItem src_url
  |> List.map ( \(_, _, _, url) -> url )
  |> Array.fromList

urlTabs : String -> Dict String Int
urlTabs src_url =
    routingItem src_url
    |> List.indexedMap (\idx (_, _, _, url) -> ( url, idx ))
    |> Dict.fromList
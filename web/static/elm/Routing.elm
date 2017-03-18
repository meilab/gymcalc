module Routing exposing(..)

import Navigation exposing (Location)
import UrlParser exposing (..)
import Config exposing(src_url)
import Maybe exposing(Maybe)

type Route
  = HomeRoute
  | InfoCollectionRoute
  | FoodRoute
  | IntroRoute
  | NotFoundRoute

parseApiPath : Parser a a -> Parser a a
parseApiPath item =
  case ( parseAppend item ) of
    Just result ->
      result
    Nothing ->
      item

parseAppend : Parser a a -> Maybe ( Parser a a )
parseAppend item =
  src_url
  |> String.split "/"
  |> List.tail
  |> Maybe.map( List.map ( s ) )
  |> Maybe.map( List.reverse )
  |> Maybe.map( List.foldl ( </> )( item ) )

matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ map HomeRoute ( parseApiPath top ) 
    , map InfoCollectionRoute ( parseApiPath ( s "infocollection" ) )
    , map FoodRoute ( parseApiPath ( s "food" ) )
    , map IntroRoute ( parseApiPath ( s "intro" ) )
    ]

parseLocation : Location -> Route
parseLocation location =
  case ( parsePath matchers location ) of
    Just route ->
      route
    Nothing ->
      NotFoundRoute

urlFor : Route -> String
urlFor route =
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

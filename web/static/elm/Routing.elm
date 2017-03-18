module Routing exposing(..)

import Navigation exposing (Location)
import UrlParser exposing (..)
import Config exposing(src_url)
import Maybe exposing(Maybe)

type Route
  = HomeRoute
  | FoodRoute
  | IntroRoute
  | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
  oneOf
    [ map HomeRoute top 
    , map FoodRoute ( s "food" )
    , map IntroRoute ( s "intro" )
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
    FoodRoute ->
      src_url ++ "/food"
    IntroRoute ->
      src_url ++ "/intro"
    NotFoundRoute ->
      src_url
module Main exposing (..)

import Views exposing(..)
import Models exposing(..)
import Messages exposing(Msg(..))
import Update exposing(..)
import Navigation exposing (Location)
import Routing

main : Program Never Model Msg
main =
  Navigation.program OnLocationChange
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

init : Location -> (Model, Cmd Msg)
init location =
  let
    currentRoute =
      Routing.parseLocation location

    initCommand =
            changeUrlCommand ( initialModel currentRoute ) currentRoute
  in
  ( initialModel currentRoute, initCommand )

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

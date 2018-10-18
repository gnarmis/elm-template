module Main exposing (init)

import Browser
import Browser.Navigation as Nav
import Data.Domain as Domain exposing (Domain)
import Data.GradeLevel as GradeLevel exposing (GradeLevel)
import Data.Mission as Mission exposing (Mission)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import HttpBuilder exposing (..)
import Json.Decode as Decode
import Model exposing (Model)
import Page.Mission.Main
import Page.Mission.Model exposing (emptyMissionUpdateForm)
import Page.Missions.Main
import RemoteData exposing (WebData)
import Routing exposing (Route(..))
import Update exposing (Msg(..), update)
import Url
import View exposing (view)


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { gradeLevels = RemoteData.NotAsked
      , domains = RemoteData.NotAsked
      , missions = RemoteData.NotAsked
      , route = Routing.fromUrl url
      , key = key
      , missionUpdateForm = emptyMissionUpdateForm -- TODO: move
      }
    , Cmd.batch
        -- TODO: if time, what do we do here instead?
        [ Domain.index |> HttpBuilder.send DomainsLoadingComplete
        , GradeLevel.index |> HttpBuilder.send GradeLevelsLoadingComplete
        , Mission.index |> HttpBuilder.send MissionsLoadingComplete
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = LinkClicked
        }

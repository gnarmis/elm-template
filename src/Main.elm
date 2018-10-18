module Main exposing (init)

import Browser
import Browser.Navigation as Nav
import Data.Domain as Domain exposing (Domain)
import Data.DomainId as DomainId exposing (DomainId(..))
import Data.GradeLevel as GradeLevel exposing (GradeLevel)
import Data.GradeLevelId as GradeLevelId exposing (GradeLevelId(..))
import Data.Mission as Mission exposing (Mission)
import Data.MissionId as MissionId exposing (MissionId(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import HttpBuilder exposing (..)
import Json.Decode as Decode
import Model exposing (Model)
import Page.Mission.Main
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
      , missionUpdateForm = emptyMissionUpdateForm
      }
    , Cmd.batch
        [ Domain.index |> HttpBuilder.send DomainsLoadingComplete
        , GradeLevel.index |> HttpBuilder.send GradeLevelsLoadingComplete
        , Mission.index |> HttpBuilder.send MissionsLoadingComplete
        ]
    )


emptyMissionUpdateForm =
    { id = ""
    , helpText = ""
    , active = False
    , errors = []
    }


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

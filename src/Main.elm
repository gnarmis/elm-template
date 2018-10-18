module Main exposing (init)

import Browser
import Browser.Navigation as Nav
import Data.Domain as Domain exposing (Domain)
import Data.DomainId as DomainId exposing (DomainId(..))
import Data.GradeLevel as GradeLevel exposing (GradeLevel)
import Data.GradeLevelId as GradeLevelId exposing (GradeLevelId(..))
import Data.Mission as Mission exposing (Mission)
import Data.MissionId as MissionId exposing (MissionId(..))
import HttpBuilder
import Json.Decode as Decode
import Model exposing (Model)
import RemoteData exposing (WebData)
import Route exposing (Route(..))
import Update exposing (Msg(..), update)
import Url
import View exposing (view)


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model.init url key
    , Cmd.batch
        [ Domain.index |> HttpBuilder.send DomainsLoadingComplete
        , GradeLevel.index |> HttpBuilder.send GradeLevelsLoadingComplete
        , Mission.index |> HttpBuilder.send MissionsLoadingComplete
        ]
    )



-- ( { model | active = thing }, Cmd.none )
-- Let's discuss this
-- It time, provide an example


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

module Main exposing (init)

import Browser
import Browser.Navigation as Nav
import Data.Domain as Domain exposing (Domain)
import Data.GradeLevel as GradeLevel exposing (GradeLevel)
import Data.Mission as Mission exposing (Mission)
import HttpBuilder
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


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


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

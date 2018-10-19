module Update exposing (Msg(..), update)

import Browser
import Browser.Navigation as Nav
import Data.Domain as Domain exposing (Domain)
import Data.GradeLevel as GradeLevel exposing (GradeLevel)
import Data.Mission as Mission exposing (Mission)
import Http
import Model exposing (Model)
import Page.Mission.Update
import Page.Mission.Main
import RemoteData exposing (WebData)
import Routing exposing (Route(..))
import Url


type Msg
    = LinkClicked Browser.UrlRequest
    | ChangedUrl Url.Url
    | DomainsLoadingComplete (Result Http.Error (List Domain))
    | GradeLevelsLoadingComplete (Result Http.Error (List GradeLevel))
    | MissionsLoadingComplete (Result Http.Error (List Mission))
    | PageMissionUpdates Page.Mission.Update.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DomainsLoadingComplete result ->
            ( { model | domains = RemoteData.fromResult result }, Cmd.none )

        GradeLevelsLoadingComplete result ->
            ( { model | gradeLevels = RemoteData.fromResult result }, Cmd.none )

        MissionsLoadingComplete result ->
            ( { model | missions = RemoteData.fromResult result }, Cmd.none )

        LinkClicked (Browser.Internal url) ->
            ( model, Nav.pushUrl model.key (Url.toString url) )

        LinkClicked (Browser.External href) ->
            ( model, Nav.load href )

        ChangedUrl url ->
            -- TODO: add a NotFound route!!!
            case Maybe.withDefault CurriculumRoute <| Routing.fromUrl url of
                CurriculumRoute ->
                    ( { model | route = Routing.fromUrl url }, Cmd.none )
                MissionRoute missionId ->
                    ( { model | route = Routing.fromUrl url }, Page.Mission.Main.init missionId |> Cmd.map PageMissionUpdates )

        PageMissionUpdates message ->
            let
                ( updatedModel, pageCmd ) =
                    Page.Mission.Update.update message model
            in
            ( updatedModel, pageCmd |> Cmd.map PageMissionUpdates )

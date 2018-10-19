module Update exposing (Msg(..), update)

import Browser
import Browser.Navigation as Nav
import Data.Domain as Domain exposing (Domain)
import Data.GradeLevel as GradeLevel exposing (GradeLevel)
import Data.Mission as Mission exposing (Mission)
import Data.MissionId as MissionId exposing (MissionId)
import Http
import Model exposing (..)
import RemoteData exposing (WebData)
import Route exposing (Route(..))
import Url
import Errored exposing (PageLoadError)
import Page.Mission.Main as MissionShow
import Page.Curriculum.Main as CurriculumPage
import Task


-- Update.elm contains our update code. This includes the Msg types for our view. Inside here most of our business logic lives.


type Msg
    = LinkClicked Browser.UrlRequest
    | ChangedUrl Url.Url
    | DomainsLoadingComplete (Result Http.Error (List Domain))
    | GradeLevelsLoadingComplete (Result Http.Error (List GradeLevel))
    | MissionsLoadingComplete (Result Http.Error (List Mission))
    | MissionShowPageMessage MissionShow.Msg
    | CurriculumPageMessage CurriculumPage.Msg
    | SubmitMissionUpdateForm
    | SetMissionUpdateFormHelpText String
    | SetMissionUpdateFormActive Bool


transition model toMsg task =
    ({ model | pageState = TransitioningFrom (getPage model.pageState) }
        , Task.attempt toMsg task)

routeToPageMessage route =
    case route of
        CurriculumRoute ->
            CurriculumPageMessage
        MissionRoute missionId ->
            MissionShowPageMessage

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DomainsLoadingComplete result ->
            ( { model | domains = RemoteData.fromResult result }, Cmd.none )

        GradeLevelsLoadingComplete result ->
            ( { model | gradeLevels = RemoteData.fromResult result }, Cmd.none )

        MissionsLoadingComplete result ->
            ( { model | missions = RemoteData.fromResult result }, Cmd.none )

        MissionShowPageMessage pageMsg ->
            let
                (updatedPageModel, missionPageCmd) =
                    MissionShow.update pageMsg model
            in
                ( { model | pageState = updatedPageModel }, Cmd.map MissionShowPageMessage missionPageCmd )

        -- MissionShowPageMessage MissionShowLoadingComplete (Err pageLoadError) ->
        --     -- break noisily
        --     ( { model | pageState = Loaded Blank }, Cmd.none )

        -- MissionShowPageMessage MissionShowLoadingComplete (Ok missionShowModel) ->
        --     ( { model | pageState = Loaded missionShowModel }, Cmd.none)

        LinkClicked (Browser.Internal url) ->
            ( model, Nav.pushUrl model.key (Url.toString url) )

        LinkClicked (Browser.External href) ->
            ( model, Nav.load href )

        ChangedUrl url ->
            case routeToPageMessage <| Maybe.withDefault CurriculumRoute <| Route.fromUrl url of
                CurriculumPageMessage msg1 ->
                    case msg1 of
                        _ ->
                            ( model, Cmd.none )
                MissionShowPageMessage msg2 ->
                    case msg2 of
                        MissionShow.MissionShowLoadingComplete missionId (Ok missionShowModel) ->
                            -- ({ model | pageState = TransitioningFrom (getPage model.pageState) }, Task.attempt (MissionShowLoadingComplete missionId) (MissionShow.init missionId))
                            ( { model | pageState = Loaded <| PageMission missionShowModel }, Cmd.none )
                        MissionShow.MissionShowLoadingComplete missionId (Err value) ->
                            (model, Cmd.none)

                -- MissionRoute missionId ->
                --     transition
                -- CurriculumRoute ->
                --     ( { model | route = Route.fromUrl url }, Cmd.none )

        SubmitMissionUpdateForm ->
            ( model, Cmd.none )

        SetMissionUpdateFormHelpText _ ->
            ( model, Cmd.none )

        SetMissionUpdateFormActive isActive ->
            let
                form =
                    model.missionUpdateForm

                updatedForm =
                    { form | active = isActive }
            in
            ( { model | missionUpdateForm = updatedForm }, Cmd.none )

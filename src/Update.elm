module Update exposing (Msg(..), update)

import Browser
import Data.Domain as Domain exposing (Domain)
import Data.GradeLevel as GradeLevel exposing (GradeLevel)
import Data.Mission as Mission exposing (Mission)
import Http
import Model exposing (Model)
import Url
import RemoteData exposing (WebData)
import Routing
import Browser.Navigation as Nav


type Msg
    = LinkClicked Browser.UrlRequest
    | ChangedUrl Url.Url
    | DomainsLoadingComplete (Result Http.Error (List Domain))
    | GradeLevelsLoadingComplete (Result Http.Error (List GradeLevel))
    | MissionsLoadingComplete (Result Http.Error (List Mission))
    | SubmitMissionUpdateForm
    | SetMissionUpdateFormHelpText String
    | SetMissionUpdateFormActive Bool


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
            ( { model | route = Routing.fromUrl url }, Cmd.none )

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

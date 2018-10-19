module Page.Mission.Update exposing (Msg(..), update)

import Data.Mission as Mission exposing (Mission)
import Data.MissionId as MissionId exposing (MissionId(..))
import Http
import HttpBuilder
import Model exposing (Model)
import Page.Mission.Model
import RemoteData exposing (WebData)


type Msg
    = SubmitMissionUpdateForm
    | SetMissionUpdateFormHelpText String
    | SetMissionUpdateFormActive Bool
    | MissionUpdateComplete (Result Http.Error Mission)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ({ missionUpdateForm } as model) =
    case msg of
        SubmitMissionUpdateForm ->
            let
                missionId =
                    MissionId.fromString model.missionUpdateForm.id
            in
            ( model
            , Mission.update missionId (Page.Mission.Model.formEncode model.missionUpdateForm)
                |> HttpBuilder.send MissionUpdateComplete
            )

        SetMissionUpdateFormHelpText text ->
            ( { model | missionUpdateForm = { missionUpdateForm | helpText = text } }, Cmd.none )

        SetMissionUpdateFormActive isActive ->
            ( { model | missionUpdateForm = { missionUpdateForm | active = isActive } }, Cmd.none )

        MissionUpdateComplete (Err err) ->
            ( { model | missionUpdateForm = { missionUpdateForm | errors = Debug.toString err :: missionUpdateForm.errors } }, Cmd.none )

        MissionUpdateComplete (Ok mission) ->
            ( model, Cmd.none )



-- update the one reference
-- ( { model | missions = RemoteData.fromResult result }, Cmd.none )

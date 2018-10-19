module Page.Mission.Main exposing (Model, Msg(..), init, update, view)

import Data.Mission as Mission exposing (Mission)
import Data.MissionId as MissionId exposing (MissionId)
import Errored exposing (PageLoadError)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import HttpBuilder
import RemoteData exposing (WebData)
import Route exposing (Route(..))
import Task exposing (Task)


type alias Model =
    { mission : Mission
    }


type Msg
    = MissionShowLoadingComplete MissionId (Result PageLoadError Model)


init : MissionId -> Task PageLoadError Model
init missionId =
    let
        loadMission =
            Mission.show missionId
                |> HttpBuilder.toRequest
                |> Http.toTask

        handleLoadError _ =
            Errored.pageLoadError "Mission could not be loaded."
    in
    Task.map Model loadMission
        |> Task.mapError handleLoadError


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MissionShowLoadingComplete missionId (Ok missionModel) ->
            ( missionModel, Cmd.none)
        MissionShowLoadingComplete missionId (Err value) ->
            ( model, Cmd.none )

view : Model -> Html Msg
view { mission } =
    div []
        [ div []
            [ h1 []
                [ text "Mission" ]
            , p []
                [ text <| "mission_id: " ++ MissionId.toString mission.id ]
            , p []
                [ text <| "help_text: " ++ mission.helpText ]
            , p []
                [ text <| "active: " ++ Debug.toString mission.active ]
            ]

        -- , Html.form [ onSubmit SubmitMissionUpdateForm ]
        --     [ input [ name "id", type_ "hidden", value <| MissionId.toString mission.id ]
        --         []
        --     , textarea [ name "help_text", onInput SetMissionUpdateFormHelpText ]
        --         [ text mission.helpText ]
        --     , input [ name "active", type_ "checkbox", value "true", checked mission.active, onCheck SetMissionUpdateFormActive ]
        --         []
        --     , button [] [ text "submit" ]
        --     ]
        ]



-- oldview : Model -> MissionId -> Html Msg
-- oldview model missionId =
--     let
--         findMission missions =
--             missions
--                 |> List.filter (\m -> m.id == missionId)
--                 |> List.head
--     in
--     case model.mission of
--         RemoteData.NotAsked ->
--             text "YOU FAIL"
--         RemoteData.Loading ->
--             text "Loading..."
--         RemoteData.Failure err ->
--             text (Debug.toString err)
--         RemoteData.Success missions ->
--             case findMission missions of
--                 Just mission ->
--                     div []
--                         [ div []
--                             [ h1 []
--                                 [ text "Mission" ]
--                             , p []
--                                 [ text <| "mission_id: " ++ MissionId.toString mission.id ]
--                             , p []
--                                 [ text <| "help_text: " ++ mission.helpText ]
--                             , p []
--                                 [ text <| "active: " ++ Debug.toString mission.active ]
--                             ]
--                         , Html.form [ onSubmit SubmitMissionUpdateForm ]
--                             [ input [ name "id", type_ "hidden", value <| MissionId.toString mission.id ]
--                                 []
--                             , textarea [ name "help_text", onInput SetMissionUpdateFormHelpText ]
--                                 [ text mission.helpText ]
--                             , input [ name "active", type_ "checkbox", value "true", checked mission.active, onCheck SetMissionUpdateFormActive ]
--                                 []
--                             , button [] [ text "submit" ]
--                             ]
--                         ]
--                 Nothing ->
--                     div [] [ text "Mission missing!" ]

module Page.Mission.Main exposing (view)

import Data.Domain as Domain exposing (Domain)
import Data.GradeLevel as GradeLevel exposing (GradeLevel)
import Data.Mission as Mission exposing (Mission)
import Data.MissionId as MissionId exposing (MissionId(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model)
import RemoteData exposing (WebData)
import Routing exposing (Route(..))
import Update exposing (Msg(..))


view : Model -> MissionId -> Html Msg
view model missionId =
    let
        findMission missions =
            missions
                |> List.filter (\m -> m.id == missionId)
                |> List.head
    in
    case model.missions of
        RemoteData.NotAsked ->
            text "YOU FAIL"

        RemoteData.Loading ->
            text "Loading..."

        RemoteData.Failure err ->
            text (Debug.toString err)

        RemoteData.Success missions ->
            case findMission missions of
                Just mission ->
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
                        , Html.form [ onSubmit SubmitMissionUpdateForm ]
                            [ input [ name "id", type_ "hidden", value <| MissionId.toString mission.id ]
                                []
                            , textarea [ name "help_text", onInput SetMissionUpdateFormHelpText ]
                                [ text mission.helpText ]
                            , input [ name "active", type_ "checkbox", value "true", checked mission.active, onCheck SetMissionUpdateFormActive ]
                                []
                            , button [] [ text "submit" ]
                            ]
                        ]

                Nothing ->
                    div [] [ text "Mission missing!" ]

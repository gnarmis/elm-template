module View exposing (view)

import Browser
import Html exposing (..)
import Model exposing (Model)
import Page.Mission.Main exposing (..)
import Page.Missions.Main exposing (..)
import Routing exposing (Route(..))
import Update exposing (Msg(..))


view : Model -> Browser.Document Msg
view model =
    { title = "Test App"
    , body = renderRoute model
    }


renderRoute : Model -> List (Html Update.Msg)
renderRoute model =
    case model.route of
        Just CurriculumRoute ->
            [ Page.Missions.Main.view model
            ]

        Just (MissionRoute missionId) ->
            [ Page.Mission.Main.view model.missionPageModel missionId |> Html.map PageMissionUpdates ]

        Nothing ->
            [ h2 [] [ text "Error!, no route found" ] ]

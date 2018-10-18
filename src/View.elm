module View exposing (view)

-- fix?

import Browser
import Data.Domain as Domain exposing (Domain)
import Data.DomainId as DomainId exposing (DomainId(..))
import Data.GradeLevel as GradeLevel exposing (GradeLevel)
import Data.GradeLevelId as GradeLevelId exposing (GradeLevelId(..))
import Data.Mission as Mission exposing (Mission)
import Data.MissionId as MissionId exposing (MissionId(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import HttpBuilder exposing (..)
import Model exposing (Model)
import Page.Curriculum.Main as CurriculumPage
import Page.Mission.Main as MissionPage
import RemoteData exposing (WebData)
import Route exposing (Route(..))
import Update exposing (..)


-- type Page
--     = PageCurriculum CurriculumPage.Model
--     | PageMission MissionPage.Model


-- type PageState
--     = Loaded Page
--     | TransitioningFrom Page


-- type alias Model =
--     { session : Session
--     , pageState : PageState
--     }


-- Inside View.elm, we define the view for our model and set up any event handlers we need.


view : Model -> Browser.Document Msg
view model =
    { title = "Test App"
    , body = renderRoute model
    }


renderRoute : Model -> List (Html Msg)
renderRoute model =
    case model.route of
        Just CurriculumRoute ->
            [ CurriculumPage.view model
            ]

        Just (MissionRoute missionId) ->
            [ MissionPage.view model ]

        Nothing ->
            [ h2 [] [ text "Error!, no route found" ] ]

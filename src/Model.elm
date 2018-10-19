module Model exposing (Model)

import Browser.Navigation as Nav
import Data.Domain as Domain exposing (Domain)
import Data.GradeLevel as GradeLevel exposing (GradeLevel)
import Data.Mission as Mission exposing (Mission)
import Page.Mission.Model exposing (MissionUpdateForm)
import RemoteData exposing (WebData)
import Routing exposing (Route(..))


type alias Model =
    { domains : WebData (List Domain)
    , gradeLevels : WebData (List GradeLevel)
    , missions : WebData (List Mission)
    , route : Maybe Route
    , key : Nav.Key
    , missionUpdateForm : MissionUpdateForm
    }

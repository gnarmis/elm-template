module Model exposing (..)

import RemoteData exposing (WebData)
import Data.GradeLevel as GradeLevel exposing (GradeLevel)
import Data.Domain as Domain exposing (Domain)
import Browser.Navigation as Nav
import Data.Mission as Mission exposing (Mission)
import Routing exposing (Route(..))

type alias Model =
    { domains : WebData (List Domain)
    , gradeLevels : WebData (List GradeLevel)
    , missions : WebData (List Mission)
    , route : Maybe Route
    , key : Nav.Key
    , missionUpdateForm : MissionFormModel
    }


type alias MissionFormModel =
    { id : String
    , helpText : String
    , active : Bool
    , errors : List String
    }

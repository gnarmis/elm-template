module Model exposing (Model, init)

import Browser.Navigation as Nav
import Data.Domain as Domain exposing (Domain)
import Data.GradeLevel as GradeLevel exposing (GradeLevel)
import Data.Mission as Mission exposing (Mission)
import RemoteData exposing (WebData)
import Route exposing (Route(..))
import Url


-- Inside Model.elm, we contain the actual model for the view state of our program. Note that we generally don't include non-view state inside here, preferring to instead generalize things away from the view where possible. For example, we might have a record with a list of assignments in our Model file, but the assignment type itself would be in a module called Data.Assignment.


type alias Model =
    { domains : WebData (List Domain)
    , gradeLevels : WebData (List GradeLevel)
    , missions : WebData (List Mission)
    , route : Maybe Route
    , key : Nav.Key
    , missionUpdateForm : MissionFormModel
    }


init : Url.Url -> Nav.Key -> Model
init url key =
    { gradeLevels = RemoteData.NotAsked
    , domains = RemoteData.NotAsked
    , missions = RemoteData.NotAsked
    , route = Route.fromUrl url
    , key = key
    , missionUpdateForm = emptyMissionUpdateForm
    }



-- FIXME -- where should this stuff below this line go?


type alias MissionFormModel =
    { id : String
    , helpText : String
    , active : Bool
    , errors : List String
    }


emptyMissionUpdateForm =
    { id = ""
    , helpText = ""
    , active = False
    , errors = []
    }

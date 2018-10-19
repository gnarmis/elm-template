module Page.Mission.Model exposing (Model, MissionUpdateForm, formEncode, initMissionUpdateForm, initModel)

import Data.Mission exposing (Mission)
import Data.MissionId exposing (MissionId)
import Json.Encode as Encode


type alias Model =
    { mission : Mission
    , missionUpdateForm : MissionUpdateForm
    , errors : List String
    }

type alias MissionUpdateForm =
    { helpText : String
    , active : Bool
    , errors : List String
    }


initMissionUpdateForm : Mission -> MissionUpdateForm
initMissionUpdateForm mission =
    { helpText = mission.helpText
    , active = mission.active
    , errors = []
    }

initModel : Mission -> Model
initModel mission =
    { mission = mission
    , missionUpdateForm = initMissionUpdateForm mission
    , errors = []
    }


formEncode : MissionUpdateForm -> Encode.Value
formEncode missionForm =
    Encode.object
        [ ( "active", Encode.bool missionForm.active )
        , ( "help_text", Encode.string missionForm.helpText )
        ]

module Page.Mission.Model exposing (MissionUpdateForm, formEncode, initMissionUpdateForm)

import Data.Mission exposing (Mission)
import Data.MissionId exposing (MissionId)
import Json.Encode as Encode


type alias MissionUpdateForm =
    { id : MissionId
    , helpText : String
    , active : Bool
    , errors : List String
    }


initMissionUpdateForm : Mission -> MissionUpdateForm
initMissionUpdateForm mission =
    { id = mission.id
    , helpText = mission.helpText
    , active = mission.active
    , errors = []
    }


formEncode : MissionUpdateForm -> Encode.Value
formEncode missionForm =
    Encode.object
        [ ( "active", Encode.bool missionForm.active )
        , ( "help_text", Encode.string missionForm.helpText )
        ]

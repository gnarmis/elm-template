module Page.Mission.Model exposing (MissionFormModel, emptyMissionUpdateForm, formEncode)

import Json.Encode as Encode

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


formEncode : MissionFormModel -> Encode.Value
formEncode missionForm =
    Encode.object
        [ ( "id", Encode.string missionForm.id )
        , ( "active", Encode.bool missionForm.active )
        , ( "help_text", Encode.string missionForm.helpText )
        ]

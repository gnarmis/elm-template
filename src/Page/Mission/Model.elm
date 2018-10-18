module Page.Mission.Model exposing (MissionFormModel, emptyMissionUpdateForm)


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

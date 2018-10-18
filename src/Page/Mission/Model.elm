module Page.Mission.Model exposing (MissionFormModel)

type alias MissionFormModel =
    { id : String
    , helpText : String
    , active : Bool
    , errors : List String
    }

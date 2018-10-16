module GradeLevel exposing (GradeLevel, decoder)

import Json.Decode as Decode exposing (Decoder)


type GradeLevelId
    = GradeLevelId Int


type alias GradeLevel =
    { id : GradeLevelId
    , code : String
    , description : String
    }


decoder : Decoder GradeLevel
decoder =
    Decode.map3 GradeLevel
        (Decode.field "id" (Decode.int |> Decode.map GradeLevelId))
        (Decode.field "code" Decode.string)
        (Decode.field "description" Decode.string)

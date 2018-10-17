module GradeLevel exposing (GradeLevel, GradeLevelId(..), decoder, fetchAll, unwrapGradeLevelId)

import Http
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


unwrapGradeLevelId : GradeLevelId -> Int
unwrapGradeLevelId (GradeLevelId id) =
    id


fetchAll =
    Http.get "//localhost:3000/grade_levels" (Decode.list decoder)
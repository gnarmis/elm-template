module Mission exposing (Mission, MissionId(..), decoder, fetchAll, unwrapId)

import Domain exposing (DomainId(..))
import GradeLevel exposing (GradeLevelId(..))
import Http
import Json.Decode as Decode exposing (Decoder)


type MissionId
    = MissionId Int


type alias Mission =
    { id : MissionId
    , gradeLevelId : GradeLevelId
    , domainId : DomainId
    , activeQuestCount : Int
    , inactiveQuestCount : Int
    , helpText : Maybe String
    , active : Bool
    }


decoder : Decoder Mission
decoder =
    Decode.map7 Mission
        (Decode.field "id" (Decode.int |> Decode.map MissionId))
        (Decode.field "grade_level_id" (Decode.int |> Decode.map GradeLevelId))
        (Decode.field "domain_id" (Decode.int |> Decode.map DomainId))
        (Decode.field "active_quest_count" Decode.int)
        (Decode.field "inactive_quest_count" Decode.int)
        (Decode.field "help_text" (Decode.nullable Decode.string))
        (Decode.field "active" Decode.bool)


unwrapId : MissionId -> Int
unwrapId (MissionId id) =
    id


fetchAll =
    Http.get "//localhost:3000/missions" (Decode.list decoder)

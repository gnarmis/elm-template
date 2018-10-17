module Mission exposing (Mission, MissionId(..), decoder, fetchAll, unwrapId, updateMission)

import Domain exposing (DomainId(..))
import GradeLevel exposing (GradeLevelId(..))
import HttpBuilder
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Json.Encode.Extra as EncodeExtra


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

encoder : Mission -> Encode.Value
encoder mission =
    Encode.object
        [("id", Encode.int (unwrapId mission.id))
        , ("active", Encode.bool mission.active)
        , ("help_text", EncodeExtra.maybe Encode.string mission.helpText )]

unwrapId : MissionId -> Int
unwrapId (MissionId id) =
    id


fetchAll =
    HttpBuilder.get "//localhost:3000/missions"
        |> HttpBuilder.withExpectJson (Decode.list decoder)

updateMission mission =
    HttpBuilder.patch ("//localhost:3000/missions/" ++ (unwrapId mission.id |> String.fromInt))
        |> HttpBuilder.withJsonBody (encoder mission)
        |> HttpBuilder.withExpectJson decoder

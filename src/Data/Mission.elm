module Data.Mission exposing (Mission, decoder, index)

import Data.DomainId as DomainId exposing (DomainId(..))
import Data.GradeLevelId as GradeLevelId exposing (GradeLevelId(..))
import Data.MissionId as MissionId exposing (MissionId(..))
import Http
import HttpBuilder exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)


type alias Mission =
    { id : MissionId
    , gradeLevelId : GradeLevelId
    , domainId : DomainId
    , activeQuestCount : Int
    , inactiveQuestCount : Int
    , helpText : String
    , active : Bool
    }


decoder : Decoder Mission
decoder =
    Decode.succeed Mission
        |> required "id" MissionId.decoder
        |> required "grade_level_id" GradeLevelId.decoder
        |> required "domain_id" DomainId.decoder
        |> required "active_quest_count" Decode.int
        |> required "inactive_quest_count" Decode.int
        |> optional "help_text" Decode.string ""
        |> required "active" Decode.bool


index =
    HttpBuilder.get "http://localhost:3000/missions"
        |> HttpBuilder.withExpectJson (Decode.list decoder)


show id =
    HttpBuilder.get ("http://localhost:3000/missions?id=" ++ MissionId.toString id)
        |> HttpBuilder.withExpectJson decoder

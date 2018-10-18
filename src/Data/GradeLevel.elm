module Data.GradeLevel exposing (GradeLevel, decoder, index)

import Data.GradeLevelId as GradeLevelId exposing (GradeLevelId(..))
import Http
import HttpBuilder exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)


type alias GradeLevel =
    { id : GradeLevelId
    , code : String
    , description : String
    }


decoder : Decoder GradeLevel
decoder =
    Decode.succeed GradeLevel
        |> required "id" GradeLevelId.decoder
        |> required "code" Decode.string
        |> required "description" Decode.string


index =
    HttpBuilder.get "http://localhost:3000/grade_levels"
        |> HttpBuilder.withExpectJson (Decode.list decoder)

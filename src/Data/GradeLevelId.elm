module Data.GradeLevelId exposing (GradeLevelId(..), decoder, encode, toString, urlParser)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Url.Parser as Parser exposing (Parser)



-- TYPES


type GradeLevelId
    = GradeLevelId Int



-- CREATE


urlParser : Parser (GradeLevelId -> a) a
urlParser =
    Parser.map GradeLevelId Parser.int


decoder : Decoder GradeLevelId
decoder =
    Decode.map GradeLevelId Decode.int


encode : GradeLevelId -> Value
encode (GradeLevelId gradeLevelId) =
    Encode.int gradeLevelId



-- TRANSFORM


toString : GradeLevelId -> String
toString (GradeLevelId int) =
    String.fromInt int
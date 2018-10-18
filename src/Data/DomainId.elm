module Data.DomainId exposing (DomainId(..), decoder, encode, toString, urlParser)

import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode exposing (Value)
import Url.Parser as Parser exposing (Parser)



-- TYPES


type DomainId
    = DomainId Int



-- CREATE


urlParser : Parser (DomainId -> a) a
urlParser =
    Parser.map DomainId Parser.int


decoder : Decoder DomainId
decoder =
    Decode.map DomainId Decode.int


encode : DomainId -> Value
encode (DomainId domainId) =
    Encode.int domainId



-- TRANSFORM


toString : DomainId -> String
toString (DomainId int) =
    String.fromInt int
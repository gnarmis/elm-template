module Data.Domain exposing (Domain, decoder, index)

import Data.DomainId as DomainId exposing (DomainId(..))
import Http
import HttpBuilder exposing (..)
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (hardcoded, optional, required)


type alias Domain =
    { id : DomainId
    , code : String
    , description : String
    }


decoder : Decoder Domain
decoder =
    Decode.succeed Domain
        |> required "id" DomainId.decoder
        |> required "code" Decode.string
        |> required "description" Decode.string


index =
    HttpBuilder.get "http://localhost:3000/domains"
        |> HttpBuilder.withExpectJson (Decode.list decoder)

module Domain exposing (Domain, DomainId(..), decoder, fetchAll, unwrapDomainId)

import Http
import Json.Decode as Decode exposing (Decoder)


type DomainId
    = DomainId Int


type alias Domain =
    { id : DomainId
    , code : String
    , description : String
    }


decoder : Decoder Domain
decoder =
    Decode.map3 Domain
        (Decode.field "id" (Decode.int |> Decode.map DomainId))
        (Decode.field "code" Decode.string)
        (Decode.field "description" Decode.string)


unwrapDomainId : DomainId -> Int
unwrapDomainId (DomainId id) =
    id


fetchAll =
    Http.get "//localhost:3000/domains" (Decode.list decoder)

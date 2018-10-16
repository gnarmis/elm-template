module Domain exposing (Domain, decoder, fetchAll, unwrapId)

import HttpHelper
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


unwrapId : DomainId -> Int
unwrapId (DomainId id) =
    id


fetchAll =
    HttpHelper.get (Decode.list decoder) "/domains"

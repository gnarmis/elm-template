module HttpHelper exposing (get, put)

import Http
import Json.Decode exposing (Decoder)


serverBase =
    "//localhost:3000"


makeRequest : String -> Decoder a -> String -> Http.Body -> Http.Request a
makeRequest verb decoder url body =
    Http.request
        { method = verb
        , headers = []
        , url = serverBase ++ url
        , body = body
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }


get : Decoder a -> String -> Http.Request a
get decoder url =
    makeRequest "GET" decoder url Http.emptyBody


post =
    makeRequest "POST"


put =
    makeRequest "PUT"


delete =
    makeRequest "DELETE"

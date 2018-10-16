module Main exposing (Model)

-- start the following are needed for fetching and decoding the data
-- https://github.com/lukewestby/elm-http-builder
-- import Http
-- import HttpBuilder exposing (..)
-- import Json.Decode as Decode
-- import Json.Encode as Encode
-- end

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import HttpBuilder exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Url


type alias Model =
    {}


type Msg
    = LinkClicked Browser.UrlRequest
    | ChangedUrl Url.Url
    | Funsies Result


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( Model, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Test App"
    , body = [ text "Test Body" ]
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- Missions --


type alias Mission =
    { id : Int
    , domainId : Int
    , gradeLevelId : Int
    }

-- decoders have to be in the same order as the model properties
-- https://package.elm-lang.org/packages/elm-lang/core/5.1.1/Json-Decode#map2

missionDecoder : Decode.Decoder Mission
missionDecoder =
    Decode.map3 Mission
        (Decode.field "id" Decode.int)
        (Decode.field "domain_id" Decode.int)
        (Decode.field "grade_level_id" Decode.int)

-- handleRequestComplete : Result Http.Error (List String) -> Msg
-- handleRequestComplete result =
--     Funsies result
    -- something here

getMissions : String -> Cmd Msg
getMissions =
    HttpBuilder.get "http://localhost:3000/missions"
        |> HttpBuilder.withExpectJson missionDecoder
        |> Http.send Funsies

-- MAIN


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = ChangedUrl
        , onUrlRequest = LinkClicked
        }

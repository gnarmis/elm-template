module Main exposing (Domain, GradeLevel, Mission, Model, Msg(..), domainDecoder, getDomains, getGradeLevels, getMissions, gradeLevelDecoder, init, main, missionDecoder, subscriptions, update, view)

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
    { missions : List Mission
    , gradeLevels : List GradeLevel
    , domains : List Domain
    , errors : List String
    }



-- BEGIN MISSIONS MODEL


type alias Mission =
    { id : Int
    , domainId : Int
    , gradeLevelId : Int
    , helpText : String
    , active : Bool
    }



-- decoders have to be in the same order as the model properties
-- https://package.elm-lang.org/packages/elm-lang/core/5.1.1/Json-Decode#map2


missionDecoder : Decode.Decoder Mission
missionDecoder =
    Decode.map5 Mission
        (Decode.field "id" Decode.int)
        (Decode.field "domain_id" Decode.int)
        (Decode.field "grade_level_id" Decode.int)
        (Decode.field "help_text" Decode.string)
        (Decode.field "active" Decode.bool)


getMissions : Cmd Msg
getMissions =
    HttpBuilder.get "http://localhost:3000/missions"
        |> HttpBuilder.withExpectJson (Decode.list missionDecoder)
        |> HttpBuilder.send MissionsLoaded



-- END MISSIONS MODEL
-- BEGIN GRADELEVELS MODEL


type alias GradeLevel =
    { id : Int
    , code : String
    , description : String
    }



-- decoders have to be in the same order as the model properties
-- https://package.elm-lang.org/packages/elm-lang/core/5.1.1/Json-Decode#map2


gradeLevelDecoder : Decode.Decoder GradeLevel
gradeLevelDecoder =
    Decode.map3 GradeLevel
        (Decode.field "id" Decode.int)
        (Decode.field "code" Decode.string)
        (Decode.field "description" Decode.string)


getGradeLevels : Cmd Msg
getGradeLevels =
    HttpBuilder.get "http://localhost:3000/grade_levels"
        |> HttpBuilder.withExpectJson (Decode.list gradeLevelDecoder)
        |> HttpBuilder.send GradeLevelsLoaded



-- END GRADELEVELS MODEL
-- BEGIN DOMAINS MODEL


type alias Domain =
    { id : Int
    , code : String
    , description : String
    }



-- decoders have to be in the same order as the model properties
-- https://package.elm-lang.org/packages/elm-lang/core/5.1.1/Json-Decode#map2


domainDecoder : Decode.Decoder Domain
domainDecoder =
    Decode.map3 Domain
        (Decode.field "id" Decode.int)
        (Decode.field "code" Decode.string)
        (Decode.field "description" Decode.string)


getDomains : Cmd Msg
getDomains =
    HttpBuilder.get "http://localhost:3000/domains"
        |> HttpBuilder.withExpectJson (Decode.list domainDecoder)
        |> HttpBuilder.send DomainsLoaded



-- END GRADELEVELS MODEL


{-| with elm 19, onUrlChange and onUrlRequest are required to be handled (see Browser.application)
-}
type Msg
    = LinkClicked Browser.UrlRequest
    | ChangedUrl Url.Url
    | MissionsLoaded (Result Http.Error (List Mission))
    | GradeLevelsLoaded (Result Http.Error (List GradeLevel))
    | DomainsLoaded (Result Http.Error (List Domain))


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    --     ( Model [] [], Cmd.none )  <- here, Model is a constructor of the Model-like records defined above
    ( { missions = [], gradeLevels = [], domains = [], errors = [] }, Cmd.batch [ getMissions, getGradeLevels, getDomains ] )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MissionsLoaded (Err result) ->
            ( { model | errors = [ "missions woopsie" ] }, Cmd.none )

        MissionsLoaded (Ok value) ->
            ( { model | missions = value }, Cmd.none )

        GradeLevelsLoaded (Err result) ->
            ( { model | errors = [ "grade levels woopsie" ] }, Cmd.none )

        GradeLevelsLoaded (Ok value) ->
            ( { model | gradeLevels = value }, Cmd.none )

        DomainsLoaded (Err result) ->
            ( { model | errors = [ "domain woopsie" ] }, Cmd.none )

        DomainsLoaded (Ok value) ->
            ( { model | domains = value }, Cmd.none )

        -- you need to handle your messages, all of em!
        _ ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    let
        toListItem : { a | id : Int } -> Html msg
        toListItem item =
            li [] [ Html.text (String.fromInt item.id) ]

        missionsList : Html msg
        missionsList =
            ul [] (List.map toListItem model.missions)

        gradeLevelsList : Html msg
        gradeLevelsList =
            ul [] (List.map toListItem model.gradeLevels)

        domainsList : Html msg
        domainsList =
            ul [] (List.map toListItem model.domains)
    in
    { title = "Test App"
    , body = [ missionsList, gradeLevelsList, domainsList ]
    }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



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

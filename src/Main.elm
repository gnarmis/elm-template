module Main exposing (Model)

import Browser
import Browser.Navigation as Nav
import Debug
import Domain exposing (Domain)
import GradeLevel exposing (GradeLevel)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import HttpHelper
import Json.Decode as Decode
import Url


type alias Model =
    { domains : List Domain
    , gradeLevels : List GradeLevel
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | ChangedUrl Url.Url
    | DomainsCompleted (Result Http.Error (List Domain))
    | GradeLevelsCompleted (Result Http.Error (List GradeLevel))


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { gradeLevels = [], domains = [] }
    , Cmd.batch
        [ HttpHelper.get (Decode.list Domain.decoder) "//localhost:3000/domains" |> Http.send DomainsCompleted
        , HttpHelper.get (Decode.list GradeLevel.decoder) "//localhost:3000/grade_levels" |> Http.send GradeLevelsCompleted
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DomainsCompleted result ->
            case result of
                Ok domains ->
                    ( { model | domains = domains }, Cmd.none )

                Err err ->
                    let
                        _ =
                            Debug.log "Domains foobar" err
                    in
                    ( model, Cmd.none )

        GradeLevelsCompleted result ->
            case result of
                Ok gradeLevels ->
                    ( { model | gradeLevels = gradeLevels }, Cmd.none )

                Err err ->
                    let
                        _ =
                            Debug.log "Grade level foobar" err
                    in
                    ( model, Cmd.none )

        LinkClicked _ ->
            ( model, Cmd.none )

        ChangedUrl _ ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Test App"
    , body =
        [ div [] (model.domains |> List.map renderDomain)
        , div [] (model.gradeLevels |> List.map renderGradeLevel)
        ]
    }



-- TODO: delete when rendering real things


renderDomain : Domain -> Html nop
renderDomain domain =
    p []
        [ renderPair "ID" (Domain.unwrapId domain.id |> String.fromInt)
        , renderPair "Code" domain.code
        , renderPair "Description" domain.description
        ]


renderGradeLevel : GradeLevel -> Html nop
renderGradeLevel gradeLevel =
    p []
        [ renderPair "ID" (GradeLevel.unwrapId gradeLevel.id |> String.fromInt)
        , renderPair "Code" gradeLevel.code
        , renderPair "Description" gradeLevel.description
        ]


renderPair : String -> String -> Html nop
renderPair title body =
    div []
        [ strong [] [ text title ]
        , span [] [ text (" " ++ body) ]
        ]


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

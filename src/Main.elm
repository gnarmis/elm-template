module Main exposing (Model)

import Browser
import Browser.Navigation as Nav
import Debug
import GradeLevel exposing (GradeLevel)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import HttpHelper
import Json.Decode as Decode
import Url


type alias Model =
    { gradeLevels : List GradeLevel }


type Msg
    = LinkClicked Browser.UrlRequest
    | ChangedUrl Url.Url
    | GradeLevelCompleted (Result Http.Error (List GradeLevel))


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { gradeLevels = [] }
    , HttpHelper.get (Decode.list GradeLevel.decoder) "//localhost:3000/grade_levels"
        |> Http.send GradeLevelCompleted
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GradeLevelCompleted result ->
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
    , body = model.gradeLevels |> List.map renderGradeLevel
    }



-- TODO: delete when rendering real things


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

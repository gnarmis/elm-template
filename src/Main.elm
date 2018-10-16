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
import Mission exposing (Mission)
import Url


type alias Model =
    { domains : List Domain
    , gradeLevels : List GradeLevel
    , missions : List Mission
    }


type Msg
    = LinkClicked Browser.UrlRequest
    | ChangedUrl Url.Url
    | DomainsCompleted (Result Http.Error (List Domain))
    | GradeLevelsCompleted (Result Http.Error (List GradeLevel))
    | MissionsCompleted (Result Http.Error (List Mission))


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    ( { gradeLevels = [], domains = [], missions = [] }
    , Cmd.batch
        [ Domain.fetchAll |> Http.send DomainsCompleted
        , GradeLevel.fetchAll |> Http.send GradeLevelsCompleted
        , Mission.fetchAll |> Http.send MissionsCompleted
        ]
    )


dataFromResultOrDefault : Result Http.Error data -> data -> data
dataFromResultOrDefault result default =
    case result of
        Ok data ->
            data

        Err err ->
            let
                _ =
                    Debug.log "Domains foobar" err
            in
            default


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DomainsCompleted result ->
            ( { model | domains = dataFromResultOrDefault result model.domains }, Cmd.none )

        GradeLevelsCompleted result ->
            ( { model | gradeLevels = dataFromResultOrDefault result model.gradeLevels }, Cmd.none )

        MissionsCompleted result ->
            ( { model | missions = dataFromResultOrDefault result model.missions }, Cmd.none )

        LinkClicked _ ->
            ( model, Cmd.none )

        ChangedUrl _ ->
            ( model, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Test App"
    , body =
        [ renderTable model
        ]
    }


renderTable : Model -> Html msg
renderTable { domains, gradeLevels, missions } =
    let
        renderHeader =
            tr []
                (th [] []
                    :: (gradeLevels
                            |> List.map
                                (\gradeLevel ->
                                    th [] [ text gradeLevel.code ]
                                )
                       )
                )

        renderBody =
            domains
                |> List.map
                    (\domain ->
                        tr []
                            (th [] [ text domain.code ]
                                :: (gradeLevels |> List.map (renderCell domain))
                            )
                    )

        renderCell : Domain -> GradeLevel -> Html msg
        renderCell domain gradeLevel =
            let
                cellMissions =
                    missions |> List.filter (\m -> m.domainId == domain.id && m.gradeLevelId == gradeLevel.id)
            in
            td []
                (cellMissions |> List.map renderMission)

        renderMission : Mission -> Html msg
        renderMission mission =
            text
                (String.fromInt mission.activeQuestCount
                    ++ "/"
                    ++ String.fromInt mission.inactiveQuestCount
                )
    in
    table [] (renderHeader :: renderBody)


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

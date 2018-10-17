module Main exposing (Model)

import Browser
import Browser.Navigation as Nav
import Debug
import Domain exposing (Domain)
import GradeLevel exposing (GradeLevel)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Mission exposing (Mission, MissionId, unwrapId)
import Routing exposing (Route(..))
import Url


type alias Model =
    { domains : RemoteData Http.Error (List Domain)
    , gradeLevels : RemoteData Http.Error (List GradeLevel)
    , missions : RemoteData Http.Error (List Mission)
    , route : Maybe Route

    -- session key that's initialized on init and then saved
    , navSessionKey : Nav.Key
    }


{-| down the road, could import package directly -- but this is already based on
the blog post, so it matches
-}
type RemoteData e a
    = NotAsked
    | Loading
    | Failure e
    | Success a


type Msg
    = LinkClicked Browser.UrlRequest
    | ChangedUrl Url.Url
    | DomainsCompleted (Result Http.Error (List Domain))
    | GradeLevelsCompleted (Result Http.Error (List GradeLevel))
    | MissionsCompleted (Result Http.Error (List Mission))
    | MissionActiveCheckboxChecked Bool


fromResult : Result e a -> RemoteData e a
fromResult result =
    case result of
        Ok value ->
            Success value

        Err err ->
            Failure err


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navSessionKey =
    ( { gradeLevels = NotAsked, domains = NotAsked, missions = NotAsked, route = Routing.fromUrl url, navSessionKey = navSessionKey }
    , Cmd.batch
        [ Domain.fetchAll |> Http.send DomainsCompleted
        , GradeLevel.fetchAll |> Http.send GradeLevelsCompleted
        , Mission.fetchAll |> Http.send MissionsCompleted
        ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        DomainsCompleted result ->
            ( { model | domains = fromResult result }, Cmd.none )

        GradeLevelsCompleted result ->
            ( { model | gradeLevels = fromResult result }, Cmd.none )

        MissionsCompleted result ->
            ( { model | missions = fromResult result }, Cmd.none )

        MissionActiveCheckboxChecked bool ->
            ( model, Cmd.none )

        LinkClicked (Browser.Internal url) ->
            ( model, Nav.pushUrl model.navSessionKey (Url.toString url) )

        LinkClicked (Browser.External href) ->
            ( model, Nav.load href )

        ChangedUrl url ->
            ( { model | route = Routing.fromUrl url }, Cmd.none )


view : Model -> Browser.Document Msg
view model =
    { title = "Test App"
    , body = renderRoute model
    }


renderRoute : Model -> List (Html Msg)
renderRoute model =
    case model.route of
        Just CurriculumRoute ->
            [ renderCurriculum model
            ]

        Just (MissionRoute missionId) ->
            [ renderMission model missionId ]

        Nothing ->
            [ h2 [] [ text "Error!, no route found" ] ]


renderMission : Model -> MissionId -> Html Msg
renderMission model missionId =
    let
        findMission missions =
            missions
                |> List.filter (\m -> m.id == missionId)
                |> List.head
    in
    case model.missions of
        NotAsked ->
            text "YOU FAIL"

        Loading ->
            text "Loading..."

        Failure err ->
            text (Debug.toString err)

        Success missions ->
            case findMission missions of
                Just aMission ->
                    div [] [renderMissionUpdateForm aMission]

                Nothing ->
                    div [] [ text "Mission missing!" ]


renderMissionUpdateForm mission =
    Html.form []
        [ p [] [ text "Mission ID", Mission.unwrapId mission.id |> String.fromInt |> text ]
        , p []
            [ text "Active?"
            , input [ type_ "checkbox", checked mission.active, onCheck MissionActiveCheckboxChecked ] []
            ]
        ]


renderCurriculum : Model -> Html msg
renderCurriculum model =
    let
        renderHeader gradeLevels =
            tr []
                (th [] []
                    :: (gradeLevels
                            |> List.map
                                (\gradeLevel ->
                                    th [] [ text gradeLevel.code ]
                                )
                       )
                )

        renderBody domains gradeLevels missions =
            domains
                |> List.map
                    (\domain ->
                        tr []
                            (th [] [ text domain.code ]
                                :: (gradeLevels |> List.map (\gradeLevel -> renderCell domain gradeLevel missions))
                            )
                    )

        renderCell : Domain -> GradeLevel -> List Mission -> Html msg
        renderCell domain gradeLevel missions =
            let
                match mission =
                    mission.domainId == domain.id && mission.gradeLevelId == gradeLevel.id
            in
            td []
                (missions
                    |> List.filter match
                    |> List.map renderMissionCell
                )

        renderMissionCell : Mission -> Html msg
        renderMissionCell mission =
            Routing.link (MissionRoute mission.id)
                []
                [ text
                    (String.fromInt mission.activeQuestCount
                        ++ "/"
                        ++ String.fromInt mission.inactiveQuestCount
                    )
                ]
    in
    case ( model.missions, model.gradeLevels, model.domains ) of
        ( Success missions, Success gradeLevels, Success domains ) ->
            table [] (renderHeader gradeLevels :: renderBody domains gradeLevels missions)

        _ ->
            -- TODO: handle error vs loading
            text "Data missing!"


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

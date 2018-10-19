module Page.Curriculum.Main exposing (Model, Msg(..), view)

import Data.Domain exposing (Domain)
import Data.GradeLevel exposing (GradeLevel)
import Data.Mission exposing (Mission)
import Html exposing (..)
import RemoteData exposing (WebData)
import Route exposing (Route(..))


type Msg
    = NoOp



-- page level model...


type alias Model =
    { gradeLevels : List GradeLevel
    , domains : List Domain
    , missions : List Mission
    }



-- what should go here?
-- need to be able to render the curriculum in a table/matrix format


view : Html msg
view =
    text "temporarily blank curriculum page"



-- let
--     renderHeader gradeLevels =
--         tr []
--             (th [] []
--                 :: (gradeLevels
--                         |> List.map
--                             (\gradeLevel ->
--                                 th [] [ text gradeLevel.code ]
--                             )
--                    )
--             )
--     renderBody domains gradeLevels missions =
--         domains
--             |> List.map
--                 (\domain ->
--                     tr []
--                         (th [] [ text domain.code ]
--                             :: (gradeLevels |> List.map (\gradeLevel -> renderCell domain gradeLevel missions))
--                         )
--                 )
--     renderCell : Domain -> GradeLevel -> List Mission -> Html Msg
--     renderCell domain gradeLevel missions =
--         let
--             match mission =
--                 mission.domainId == domain.id && mission.gradeLevelId == gradeLevel.id
--         in
--         td []
--             (missions
--                 |> List.filter match
--                 |> List.map renderMissionCell
--             )
--     renderMissionCell : Mission -> Html msg
--     renderMissionCell mission =
--         Route.link (MissionRoute mission.id)
--             []
--             [ text
--                 (String.fromInt mission.activeQuestCount
--                     ++ "/"
--                     ++ String.fromInt mission.inactiveQuestCount
--                 )
--             ]
-- in
-- case ( model.missions, model.gradeLevels, model.domains ) of
--     ( RemoteData.Success missions, RemoteData.Success gradeLevels, RemoteData.Success domains ) ->
--         table [] (renderHeader gradeLevels :: renderBody domains gradeLevels missions)
--     _ ->
--         -- TODO: handle error vs loading
--         text "Data missing!"

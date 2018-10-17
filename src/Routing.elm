module Routing exposing (Route(..), fromUrl, link)

import Html exposing (Html)
import Html.Attributes
import Mission exposing (MissionId(..))
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser, oneOf, s, string)


type Route
    = CurriculumRoute
    | MissionRoute MissionId


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map CurriculumRoute Parser.top
        , Parser.map MissionRoute (s "missions" </> Parser.custom "MISSIONS" (\str -> String.toInt str |> Maybe.map MissionId))
        ]


fromUrl : Url -> Maybe Route
fromUrl url =
    -- The RealWorld spec treats the fragment like a path.
    -- This makes it *literally* the path, so we can proceed
    -- with parsing as if it had been a normal path all along.
    -- { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
    url |> Parser.parse parser


toUrlPath : Route -> String
toUrlPath route =
    case route of
        CurriculumRoute ->
            "/"

        MissionRoute missionId ->
            "/missions/" ++ (Mission.unwrapId missionId |> String.fromInt)


link : Route -> List (Html.Attribute msg) -> List (Html msg) -> Html msg
link route attrs elements =
    Html.a (Html.Attributes.href (toUrlPath route) :: attrs) elements

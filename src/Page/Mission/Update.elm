module Page.Mission.Update exposing (Msg(..), update)

import Model exposing (Model)


type Msg
    = SubmitMissionUpdateForm
    | SetMissionUpdateFormHelpText String
    | SetMissionUpdateFormActive Bool


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        SubmitMissionUpdateForm ->
            ( model, Cmd.none )

        SetMissionUpdateFormHelpText _ ->
            ( model, Cmd.none )

        SetMissionUpdateFormActive isActive ->
            let
                form =
                    model.missionUpdateForm

                updatedForm =
                    { form | active = isActive }
            in
            ( { model | missionUpdateForm = updatedForm }, Cmd.none )

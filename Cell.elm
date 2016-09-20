module Cell exposing (Msg, Model, update, view, CellValue(..), CellStatus(..))

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (succeed)


type CellValue
    = Mine
    | Number Int


type CellStatus
    = Covered
    | Opened
    | Marked


type alias Cell =
    { value : CellValue
    , status : CellStatus
    , raised : Bool
    }


type alias Model =
    Cell


type Msg
    = Open
    | ToggleMark
    | Raise
    | Drop
    | NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        Open ->
            { model | status = Opened }

        ToggleMark ->
            { model
                | status =
                    if model.status == Marked then
                        Covered
                    else
                        Marked
            }

        Raise ->
            { model
                | raised = True
            }

        Drop ->
            { model
                | raised = False
            }

        NoOp ->
            model


styles =
    let
        size =
            "48px"

        common' =
            [ ( "width", size ), ( "height", size ), ("background", "#FFFFFF"), ("cursor", "pointer")]
    in
        { common = common'
        , marked = ( "background", "red" ) :: common'
        }


view : Model -> Html Msg
view model =
    let shadowStyle = if model.raised then
      ( "box-shadow", "0 14px 28px rgba(0,0,0,0.25), 0 10px 10px rgba(0,0,0,0.22)" )
      else
        ( "box-shadow", "0 1px 3px rgba(0,0,0,0.12), 0 1px 2px rgba(0,0,0,0.24)" )
        in
    case model.status of
        Covered ->
            td [ style (shadowStyle :: styles.common), onMouseEnter Raise, onMouseLeave Drop, onClick Open, (onWithOptions "contextmenu" { defaultOptions | preventDefault = True } (succeed ToggleMark)) ] []

        Opened ->
            td [ style (shadowStyle :: styles.common), (onWithOptions "contextmenu" { defaultOptions | preventDefault = True } (succeed NoOp)) ] []

        Marked ->
            td [ style (shadowStyle :: styles.marked), onMouseEnter Raise, onMouseLeave Drop, (onWithOptions "contextmenu" { defaultOptions | preventDefault = True } (succeed ToggleMark)) ] []

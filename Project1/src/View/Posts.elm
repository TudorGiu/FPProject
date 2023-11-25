module View.Posts exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (href)
import Html.Events
import Model exposing (Msg(..))
import Model.Post exposing (Post)
import Model.PostsConfig exposing (Change(..), PostsConfig, SortBy(..), filterPosts, sortFromString, sortOptions, sortToCompareFn, sortToString)
import Time
import Util.Time
import Html.Attributes exposing (colspan)
import Html.Attributes exposing (accept)
import Html.Attributes exposing (class)
import Html.Attributes exposing (id)
import Html exposing (hr)


{-| Show posts as a HTML [table](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/table)

Relevant local functions:

  - Util.Time.formatDate
  - Util.Time.formatTime
  - Util.Time.formatDuration (once implemented)
  - Util.Time.durationBetween (once implemented)

Relevant library functions:

  - [Html.table](https://package.elm-lang.org/packages/elm/html/latest/Html#table)
  - [Html.tr](https://package.elm-lang.org/packages/elm/html/latest/Html#tr)
  - [Html.th](https://package.elm-lang.org/packages/elm/html/latest/Html#th)
  - [Html.td](https://package.elm-lang.org/packages/elm/html/latest/Html#td)

-}
postTable : PostsConfig -> Time.Posix -> List Post -> Html Msg
postTable _ _ postList =     
  div [] [
    Html.table [] [
      Html.thead [] [  
          Html.th [] [text "score"]
          , Html.th [] [text "title"]
          , Html.th [] [text "url"]
          , Html.th [] [text "time"]
          , Html.th [] [text "type_"]
        ]
      ],
      Html.tbody []
        (List.map (\x-> 
          Html.tr [] [
            Html.td [class "post-score"] [text <| String.fromInt x.score]
            , Html.td [class "post-title"] [text x.title]
            , Html.td [class "post-url"] [text <| Maybe.withDefault "nothing" x.url]
            , Html.td [class "post-time"] [text <| Util.Time.formatTime Time.utc x.time]
            , Html.td [class "post-type"] [text x.type_]
          ]
        ) postList)
  ]
    

{-| Show the configuration options for the posts table

Relevant functions:

  - [Html.select](https://package.elm-lang.org/packages/elm/html/latest/Html#select)
  - [Html.option](https://package.elm-lang.org/packages/elm/html/latest/Html#option)
  - [Html.input](https://package.elm-lang.org/packages/elm/html/latest/Html#input)
  - [Html.Attributes.type\_](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#type_)
  - [Html.Attributes.checked](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#checked)
  - [Html.Attributes.selected](https://package.elm-lang.org/packages/elm/html/latest/Html-Attributes#selected)
  - [Html.Events.onCheck](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#onCheck)
  - [Html.Events.onInput](https://package.elm-lang.org/packages/elm/html/latest/Html-Events#onInput)

-}
postsConfigView : PostsConfig -> Html Msg
postsConfigView _ =
  div [] [
    Html.select [id "select-posts-per-page"] [
      Html.option [] [text <| String.fromInt 10]
      , Html.option [] [text <| String.fromInt 25]
      , Html.option [] [text <| String.fromInt 50]
    ]
    , 
    Html.select [id "select-sort-by"] [
      Html.option [] [text "score"]
      , Html.option [] [text "title,"]
      , Html.option [] [text "date posted"]
      , Html.option [] [text "unsorted"]
    ]
    ,
    Html.input [id "checkbox-show-job-posts", Html.Attributes.type_ "checkbox"] []
    , 
    Html.input [id "checkbox-show-text-only-posts", Html.Attributes.type_ "checkbox"] []
  ]


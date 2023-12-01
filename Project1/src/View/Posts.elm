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
postTable config presentTime postList =
    div []
        [ Html.table []
            [ Html.thead []
                [ Html.tr []
                    [ Html.th [] [ text "Score" ]
                    , Html.th [] [ text "Title" ]
                    , Html.th [] [ text "Link" ]
                    , Html.th [] [ text "Posted" ]
                    , Html.th [] [ text "Type" ]
                    ]
                ]
            , Html.tbody []
                (List.map
                    (\post ->
                        Html.tr []
                            [ Html.td [class "post-score"] [ text <| String.fromInt post.score ]
                            , Html.td [class "post-title"] [ text post.title ]
                            , Html.td [class "post-url"] [ text <| Maybe.withDefault "Nothing" post.url ]
                            , Html.td [class "post-time"]
                                [ text <| (Util.Time.formatTime Time.utc post.time)
                                    ++ " ("
                                    ++ (Util.Time.formatDuration (Maybe.withDefault (Util.Time.Duration 0 0 0 0) (Util.Time.durationBetween post.time presentTime)))
                                    ++ ")"
                                ]
                            , Html.td [class "post-type"] [ text post.type_ ]
                            ]
                    )
                    (List.sortWith (sortToCompareFn config.sortBy) <| List.take config.postsToShow <| filterPosts config postList)
                )
            ]
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
postsConfigView config =
    div []
        [ div []
            [ Html.label [] [ text "How many posts to display: " ]
            , Html.select
                [ id "select-posts-per-page"
                , Html.Events.onInput (ConfigChanged << ChangePostsToShow << Maybe.withDefault 10 << String.toInt)
                ]
                [ Html.option [Html.Attributes.value "10", Html.Attributes.selected (config.postsToShow == 10)] [ text <| String.fromInt 10 ]
                , Html.option [Html.Attributes.value "25", Html.Attributes.selected (config.postsToShow == 25)] [ text <| String.fromInt 25 ]
                , Html.option [Html.Attributes.value "50", Html.Attributes.selected (config.postsToShow == 50)] [ text <| String.fromInt 50 ]
                ]
            ]
        , div []
            [ Html.label [] [ text "Sort by: " ]
            , Html.select
                [ id "select-sort-by"
                , Html.Events.onInput (ConfigChanged << ChangeSortBy << Maybe.withDefault None << sortFromString)
                ]
                [ Html.option [Html.Attributes.value "Score", Html.Attributes.selected (config.sortBy == Score)] [ text "Score" ]
                , Html.option [Html.Attributes.value "Title", Html.Attributes.selected (config.sortBy == Title)] [ text "Title" ]
                , Html.option [Html.Attributes.value "Posted", Html.Attributes.selected (config.sortBy == Posted)] [ text "Date Posted" ]
                , Html.option [Html.Attributes.value "None", Html.Attributes.selected (config.sortBy == None)] [ text "None" ]
                ]
            ]
        , div []
            [ Html.label []
                [ text "Show job posts"
                , Html.input
                    [ id "checkbox-show-job-posts"
                    , Html.Attributes.type_ "checkbox"
                    , Html.Attributes.checked config.showJobs
                    , Html.Events.onCheck (ConfigChanged << ChangeShowJobs)
                    ]
                    []
                ]
            ]
        , div []
            [ Html.label []
                [ text "Show text only posts"
                , Html.input
                    [ id "checkbox-show-text-only-posts"
                    , Html.Attributes.type_ "checkbox"
                    , Html.Attributes.checked config.showTextOnly
                    , Html.Events.onCheck (ConfigChanged << ChangeShowTextOnly)
                    ]
                    []
                ]
            ]
        ]

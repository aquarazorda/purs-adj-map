module App.Elements.Checkbox where

import Prelude
import App.Langs (getLang)
import App.Shared (Props, css, toggleClass)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Type.Proxy (Proxy(..))

_checkbox = Proxy :: Proxy "checkbox"

data Handler
  = HandleCheckbox Output

data Action
  = Initialize
  | Toggle

type State
  = { checked :: Boolean
    , yes :: String
    , no :: String
    | Input
    }

type Input
  = ( title :: String
    , props :: Record Props
    )

data Output
  = Changed Boolean

checkbox :: forall query m. MonadAff m => H.Component query (Record Input) Output m
checkbox =
  H.mkComponent
    { initialState
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { handleAction = handleAction
              , initialize = Just Initialize
              }
    }
  where
  initialState :: Record Input -> State
  initialState { title, props } =
    { checked: false, yes: "_lang_button_yes", no: "_lang_button_no", title: title, props: props
    }

render :: forall m. State -> H.ComponentHTML Action () m
render { title, yes, no, checked } =
  HH.div [ css "_s_flex _s_flex-a-center _s_flex-j-end _s_col-6" ]
    [ HH.span [ css "_s_color-primary-8 _s_label _s_label-sm _s_mr-2" ]
        [ HH.text title
        ]
    , HH.div
        [ css "_s_flex"
        , HE.onClick \_ -> Toggle
        ]
        [ HH.label [ css "_s_flex _s_flex-a-center" ]
            [ HH.div [ css "_s_flex _s_flex-a-center _s_flex-j-between _s_size-w-px--16 _s_size-h-px--8 _s_position-relative _s_cursor-pointer" ]
                [ HH.span [ css "_s_color-bg-primary-6 _s_label _s_size-w-px--8 _s_size-h-px--8 _s_flex-j-center _s_b-radius-full _s_z-1" ]
                    [ HH.text yes
                    ]
                , HH.span [ css "_s_color-bg-primary-6 _s_label _s_size-w-px--8 _s_size-h-px--8 _s_flex-j-center _s_b-radius-full _s_z-1" ]
                    [ HH.text no
                    ]
                , HH.span [ css "_s_color-bg-primary-6 _s_position-absolute _s_position-l-px--4 _s_size-h-px--8 _s_size-w-px--8 _s_z-0" ] []
                , HH.span
                    [ toggleClass
                        "_s_color-bg-primary-2 _s_position-l-px--8"
                        "_s_color-bg-primary-3 _s_size-w-px--8 _s_size-h-px--8 _s_position-absolute _s_position-l-px--0 _s_transition-0--3 _s_b-radius-full _s_z-1 _s_flex _s_flex-a-center _s_flex-j-center"
                        checked
                    ]
                    [ HH.span [ css "_s_icon _s_adj-check" ] []
                    ]
                ]
            ]
        ]
    ]

handleAction :: forall m. MonadAff m => Action -> H.HalogenM State Action () Output m Unit
handleAction = case _ of
  Initialize -> do
    state <- H.get
    title <- H.liftAff $ getLang state.props state.title
    yes <- H.liftAff $ getLang state.props state.yes
    no <- H.liftAff $ getLang state.props state.no
    H.modify_ _ { title = title, yes = yes, no = no }
  Toggle -> do
    { checked } <- H.get
    H.raise $ Changed $ not checked
    H.modify_ _ { checked = not checked }

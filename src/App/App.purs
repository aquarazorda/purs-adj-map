module App where

import Prelude
import App.Elements.Branches as Branches
import App.Elements.Checkbox as Checkbox
import App.Elements.Dropdown as Dropdown
import App.Elements.Map as Map
import App.Shared (Props, css)
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Foreign (Foreign)
import Halogen as H
import Halogen.HTML as HH

type State
  = { branches :: Array Branches.BranchData
    , filtered :: Maybe (Array Branches.BranchData)
    , cities :: Dropdown.RawOptions
    , props :: Record Props
    , alwaysOpen :: Branches.AlwaysOpen
    , activeBranch :: Maybe Int
    , activeCity :: Branches.CityId
    , company_id :: Branches.CompanyId
    }

type Slots
  = ( dropdown :: forall q. H.Slot q Dropdown.Output Unit
    , checkbox :: forall q. H.Slot q Checkbox.Output Unit
    , map :: forall q. H.Slot q Map.Output Unit
    , branches :: forall q. H.Slot q Branches.Output Unit
    )

type Params
  = ( appData :: Array Foreign
    , props :: Record Props
    )

type Input
  = { additionalData ::
        { cities :: Foreign
        , company_id :: Foreign
        }
    | Params
    }

data Action
  = HandleDropdown Dropdown.Output
  | HandleCheckbox Checkbox.Output
  | HandleMap Map.Output
  | HandleBranches Branches.Output

foreign import generateState :: forall a. Input -> (a -> Maybe a) -> Maybe a -> State

component :: forall query output m. MonadAff m => H.Component query Input output m
component =
  H.mkComponent
    { initialState
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { handleAction = handleAction
              }
    }

initialState :: Input -> State
initialState input = generateState input Just Nothing

render :: forall m. MonadAff m => State -> H.ComponentHTML Action Slots m
render { props, cities, branches, filtered, activeBranch, activeCity, company_id, alwaysOpen } = do
  HH.div [ css "_cs_for _s_color-bg-primary-7 _s_p-1" ]
    [ HH.div [ css "_s_flex _s_p-2" ]
        [ HH.slot Dropdown._dropdown unit Dropdown.dropdown
            { props: props, options: cities, title: "_lang_reg_city"
            }
            HandleDropdown
        , HH.slot Checkbox._checkbox unit Checkbox.checkbox
            { title: "_lang_verify_24_7", props: props
            }
            HandleCheckbox
        ]
    , HH.div [ css "_s_size-w-percent--25" ]
        [ HH.div [ css "_s_flex _s_p-4 _s_size-h-px--70" ]
            $ case filtered of
                Just brs ->
                  [ HH.slot Map._map unit Map.map
                      { active: activeBranch, branches: brs, props: props
                      }
                      HandleMap
                  ]
                Nothing -> [ HH.text "Loading Branches!" ]
        ]
    , HH.slot Branches._branches unit Branches.branches'
        { branches: branches
        , activeBranch: activeBranch
        , activeCity: activeCity
        , alwaysOpen: alwaysOpen
        , props: props
        , company_id: company_id
        }
        HandleBranches
    ]

handleAction :: forall output m. MonadAff m => Action -> H.HalogenM State Action Slots output m Unit
handleAction = case _ of
  HandleDropdown output -> case output of
    Dropdown.Changed id -> H.modify_ _ { activeCity = id }
  HandleCheckbox output -> case output of
    Checkbox.Changed alwaysOpen -> H.modify_ _ { alwaysOpen = alwaysOpen }
  HandleMap output -> case output of
    Map.Changed id -> H.modify_ _ { activeBranch = Just id }
  HandleBranches output -> case output of
    Branches.Changed id -> H.modify_ _ { activeBranch = Just id }
    Branches.Filtered items -> H.modify_ _ { filtered = Just items }

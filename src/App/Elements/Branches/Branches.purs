module App.Elements.Branches where

import Prelude
import App.Langs as L
import App.Shared (Props, css, toggleClass)
import Data.Array (filter)
import Data.Maybe (Maybe(..))
import Data.Traversable (sequence)
import Effect.Aff (Aff)
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Type.Proxy (Proxy(..))

_branches = Proxy :: Proxy "branches"

type CityId
  = Int

type BranchId
  = Int

type AlwaysOpen
  = Boolean

type CompanyId
  = Maybe Int

type BranchData
  = { id :: BranchId
    , byTags ::
        { city :: CityId
        , alwaysOpen :: AlwaysOpen
        }
    , location ::
        { lat :: Number
        , lng :: Number
        }
    , allowedPayments :: Maybe (Array String)
    , company_id :: CompanyId
    }

type State
  = { elements :: forall a. Array (HH.HTML a Action)
    | Input
    }

data Action
  = Initialize
  | Choose BranchId
  | Receive (Record Input)

type Input
  = ( branches :: Array BranchData
    , activeBranch :: Maybe BranchId
    , activeCity :: CityId
    , alwaysOpen :: AlwaysOpen
    , company_id :: CompanyId
    , props :: Record Props
    )

data Output
  = Changed BranchId
  | Filtered (Array BranchData)

branches' :: forall query m. MonadAff m => H.Component query (Record Input) Output m
branches' =
  H.mkComponent
    { initialState: generateState
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { initialize = Just Initialize
              , handleAction = handleAction
              , receive = Just <<< Receive
              }
    }

generateState :: Record Input -> State
generateState { branches, activeCity, activeBranch, alwaysOpen, company_id, props } =
  { branches: filterBranches activeCity alwaysOpen company_id branches
  , elements: []
  , activeBranch: activeBranch
  , activeCity: activeCity
  , alwaysOpen: alwaysOpen
  , props: props
  , company_id: company_id
  }

render :: forall m. State -> H.ComponentHTML Action () m
render state =
  HH.div
    [ css "_s_flex _s_flex-a-start _s_flex-wrap _s_overflow-x-scroll _s_pl-2 _s_pr-1 _s_scroll-red _s_scroll-sm _s_size-h-px--69" ]
    state.elements

handleAction :: forall m. MonadAff m => Action -> H.HalogenM State Action () Output m Unit
handleAction = case _ of
  Initialize -> do
    { activeCity, alwaysOpen, branches, props, company_id } <- H.get
    let
      filtered = filterBranches activeCity alwaysOpen company_id branches
    H.raise $ Filtered filtered
    elems <- H.liftAff $ getBranchList filtered Nothing props
    H.modify_ _ { elements = elems }
  Choose id -> H.raise $ Changed id
  Receive input -> do
    state <- H.get
    let
      newState = generateState input
    case newState.branches /= state.branches of
      true -> do
        H.put $ newState
        handleAction Initialize
      false -> pure unit

filterBranches :: CityId -> AlwaysOpen -> CompanyId -> Array BranchData -> Array BranchData
filterBranches _ _ _ brs = brs

-- filter
--   ( \{ byTags, company_id } ->
--       eq ci byTags.city && eq ao byTags.alwaysOpen
--         && case coi of
--             Just _ -> eq coi company_id
--             Nothing -> true
--   )
getBranchList :: forall a. Array BranchData -> Maybe BranchId -> Record Props -> Aff (Array (HH.HTML a Action))
getBranchList xs ab ps = sequence ((\i -> drawBranch i ab ps) <$> xs)

drawBranch :: forall a. BranchData -> Maybe BranchId -> Record Props -> Aff (HH.HTML a Action)
drawBranch x ab ps =
  let
    l = L.getLang ps
  in
    do
      title <- l $ "_lang_add_title_" <> show x.id
      address <- l $ "_lang_add_address_" <> show x.id
      phone <- l $ "_lang_add_phone_" <> show x.id
      pure
        $ HH.div
            [ HE.onClick \_ -> Choose x.id
            , toggleClass "_css_branch__item--active" "_s_col-6 _s_flex _s_p-1 _s_size-h-min-px--38 w1"
                $ case ab of
                    Just a -> a == x.id
                    Nothing -> false
            ]
            [ HH.div
                [ css "_s_aitem-color-bg-primary-3 _s_b-radius-md _s_color-bg-primary-6 _s_cursor-pointer _s_flex _s_flex-d-column _s_flex-j-between _s_p-2 _s_size-w-percent--25" ]
                [ HH.div
                    [ css "_s_flex b1 _s_flex-wrap" ]
                    [ HH.div
                        [ css "_s_label _s_label-sm _s_label-t-u _s_mb-2 _s_size-w-percent--22" ]
                        [ HH.span [ css "_s_size-h-percent--25" ] [ HH.text title ]
                        ]
                    , HH.span
                        [ css "_s_aitem-color-primary-1 _s_color-primary-8 _s_label _s_label-xs _s_mb-5" ]
                        [ HH.div [ css "_s_size-h-percent--25" ] [ HH.text "24/7" ] ]
                    , HH.span
                        [ css "_s_aitem-color-primary-1 _s_color-primary-8 _s_label _s_label-xs _s_mb-5" ]
                        [ HH.span
                            [ css "_s_size-h-percent--25" ]
                            [ HH.text address ]
                        ]
                    ]
                , HH.div
                    [ css "_s_flex _s_flex-a-center b2" ]
                    [ HH.span
                        [ css "_s_adj-phone _s_aitem-color-primary-1 _s_aitem-color-rgba-bg-primary-0-0--3 _s_b-radius-full _s_color-bg-primary-4 _s_color-primary-8 _s_flex _s_flex-a-center _s_flex-j-center _s_label-xs _s_mr-2 _s_size-h-px--6 _s_size-w-px--6" ]
                        [ HH.text "" ]
                    , HH.span_ [ HH.span [ css "_s_color-primary-1" ] [ HH.text phone ] ]
                    , HH.span
                        [ css "_s_adj-location _s_aitem-color-primary-1 _s_b-primary-8 _s_b-radius-full _s_b-solid _s_bw-1 _s_color-primary-8 _s_flex _s_flex-a-center _s_flex-j-center _s_label-xs _s_ml-auto _s_size-h-px--5 _s_size-w-px--5" ]
                        [ HH.text "" ]
                    ]
                ]
            ]

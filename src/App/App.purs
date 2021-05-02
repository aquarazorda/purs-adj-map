module App where

import Prelude

import App.Branches as BR
import App.Langs as L
import App.Map as M
import Data.Maybe (Maybe(..))
import Effect.Aff.Class (class MonadAff)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

type State = {
  branches :: Maybe (Array BR.BranchData),
  langs :: Maybe L.Langs
}

data Action
  = Initialize

component :: forall query input output m. MonadAff m => H.Component query input output m
component =
  H.mkComponent
    { initialState
    , render
    , eval: H.mkEval $ H.defaultEval
        { handleAction = handleAction
        , initialize = Just Initialize
        }
    }

initialState :: forall input. input -> State
initialState _ = { langs: Nothing, branches: Nothing}

render :: forall m. State -> H.ComponentHTML Action () m
render state = do
  HH.div_ [
    HH.div [ BR.css "_s_flex _s_p-4 _s_size-h-px--70"] [
      HH.div [ HP.id "map", BR.css "_s_size-w-percent--25 _s_size-h-percent--25" ] []
    ],
    HH.div
      [ BR.css "_s_flex _s_flex-a-start _s_flex-wrap _s_overflow-x-scroll _s_pl-2 _s_pr-1 _s_scroll-red _s_scroll-sm _s_size-h-px--69" ]
      case state.branches of
        Just items  -> (\i -> BR.drawBranch i state.langs) <$> items
        Nothing     -> [ HH.text "No branches" ]
  ]

handleAction :: forall output m. MonadAff m => Action -> H.HalogenM State Action () output m Unit
handleAction = case _ of
  Initialize -> do
    branches  <- H.liftAff    BR.branches
    langs     <- H.liftAff    L.langReq
    _         <- H.liftAff $  M.initMap' branches
    H.modify_ _ { branches = branches, langs = L.getLangs langs }
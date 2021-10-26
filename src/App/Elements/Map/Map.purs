module App.Elements.Map where

import Prelude
import App.Elements.Branches (BranchData)
import App.Events (receiveMessage')
import App.Shared (Props, css)
import Control.Promise (Promise, toAffE)
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff, runAff_)
import Effect.Aff.Class (class MonadAff)
import Foreign (Foreign)
import Foreign.Object (Object, lookup)
import Halogen as H
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Type.Proxy (Proxy(..))

_map = Proxy :: Proxy "map"

type State
  = { m :: Maybe Foreign
    , script :: Maybe Foreign
    , markers :: Maybe Foreign
    | Input
    }

data Action
  = Initialize
  | DrawMarkers
  | Receive (Record Input)

--   | Activate Int
type Input
  = ( branches :: Array BranchData
    , active :: Maybe Int
    , props :: Record Props
    )

data Output
  = Changed Int

foreign import initMap :: Effect (Promise (Object Foreign))

foreign import drawMarkers :: Array BranchData -> Maybe Int -> Foreign -> Record Props -> Object Foreign

foreign import clearMarkers :: Foreign -> Effect Unit

foreign import destroy :: Foreign -> Effect Unit

map :: forall query m. MonadAff m => H.Component query (Record Input) Output m
map =
  H.mkComponent
    { initialState
    , render
    , eval:
        H.mkEval
          $ H.defaultEval
              { handleAction = handleAction
              , initialize = Just Initialize
              , receive = Just <<< Receive
              }
    }
  where
  initialState :: Record Input -> State
  initialState i = { m: Nothing, markers: Nothing, script: Nothing, active: i.active, branches: i.branches, props: i.props }

render :: forall m. State -> H.ComponentHTML Action () m
render _ = HH.div [ HP.id "map", css "_s_size-w-percent--25 _s_size-h-percent--25" ] []

initMap' :: Aff (Object Foreign)
initMap' = toAffE initMap

handleAction :: forall m. MonadAff m => Action -> H.HalogenM State Action () Output m Unit
handleAction = case _ of
  Initialize -> do
    { props } <- H.get
    m <- H.liftAff initMap'
    let
      script = lookup "script" m
    _ <-
      H.liftEffect
        $ runAff_
            ( case _ of
                Right _ -> case script of
                  Just s -> destroy s
                  Nothing -> pure unit
                Left _ -> pure unit
            )
        $ receiveMessage' props.target props.eventName "destroyed"
    H.modify_ _ { m = lookup "map" m, script = script }
    handleAction $ DrawMarkers
  DrawMarkers -> do
    { m, branches, props, active } <- H.get
    case m of
      Just m' ->
        let
          output = drawMarkers branches active m' props
        in
          H.modify_ _ { markers = lookup "markers" output, m = lookup "map" output }
      Nothing -> pure unit
  Receive input -> do
    { markers } <- H.get
    case markers of
      Just m -> H.liftEffect $ clearMarkers m
      Nothing -> pure unit
    H.modify_ _ { branches = input.branches, active = input.active }
    handleAction DrawMarkers

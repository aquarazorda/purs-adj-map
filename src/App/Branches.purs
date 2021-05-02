module App.Branches where

import Prelude

import App.Langs (Langs, lang)
import App.Reqs as REQ
import Data.Argonaut (decodeJson)
import Data.Argonaut.Core (Json)
import Data.Either (hush)
import Data.Maybe (Maybe)
import Data.String (Pattern(..))
import Data.String as String
import Effect.Aff (Aff)
import Halogen.HTML (IProp)
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP

type BranchData = {
  id :: Int,
  byTags :: {
    city :: Int,
    alwaysOpen :: Boolean
  },
  location :: {
    lat :: Number,
    lng :: Number
  },
  company_id :: Int
}

url :: String
url = "https://newstatic.adjarabet.com/static/branchesAddressListNew.json"

drawBranch :: forall a b. BranchData -> Maybe Langs -> HH.HTML a b
drawBranch x langs = 
  HH.div 
    [ css "_s_col-6 _s_flex _s_p-1 _s_size-h-min-px--38 w1" ]
    [ HH.div 
      [ css "_s_aitem-color-bg-primary-3 _s_b-radius-md _s_color-bg-primary-6 _s_cursor-pointer _s_flex _s_flex-d-column _s_flex-j-between _s_p-2 _s_size-w-percent--25" ]
      [ HH.div
        [ css "_s_flex b1 _s_flex-wrap" ]
        [ HH.div
          [ css "_s_label _s_label-sm _s_label-t-u _s_mb-2 _s_size-w-percent--22" ]
          [ HH.span [ css "_s_size-h-percent--25" ] [ lang langs $ "_lang_add_title_" <> show x.id ]
        ]
        , HH.span 
          [ css "_s_aitem-color-primary-1 _s_color-primary-8 _s_label _s_label-xs _s_mb-5" ] 
          [ HH.div [ css "_s_size-h-percent--25" ] [ HH.text "24/7"] ]
        , HH.span
          [ css "_s_aitem-color-primary-1 _s_color-primary-8 _s_label _s_label-xs _s_mb-5" ]
          [ HH.span 
            [ css "_s_size-h-percent--25" ]
            [ lang langs $ "_lang_add_address_" <> show x.id ]
          ]
        ]
      , HH.div 
          [ css "_s_flex _s_flex-a-center b2" ]
          [ HH.span
            [ css "_s_adj-phone _s_aitem-color-primary-1 _s_aitem-color-rgba-bg-primary-0-0--3 _s_b-radius-full _s_color-bg-primary-4 _s_color-primary-8 _s_flex _s_flex-a-center _s_flex-j-center _s_label-xs _s_mr-2 _s_size-h-px--6 _s_size-w-px--6"]
            [ HH.text "" ]
          , HH.span_ [ HH.span [ css "_s_color-primary-1" ] [ lang langs $ "_lang_add_phone_" <> show x.id ]]
          , HH.span
            [ css "_s_adj-location _s_aitem-color-primary-1 _s_b-primary-8 _s_b-radius-full _s_b-solid _s_bw-1 _s_color-primary-8 _s_flex _s_flex-a-center _s_flex-j-center _s_label-xs _s_ml-auto _s_size-h-px--5 _s_size-w-px--5"]
            [ HH.text "" ]
          ]
      ]
    ]

css :: forall r i. String -> IProp (class :: String | r) i
css s = HP.classes $ (\i -> HH.ClassName i) <$> String.split (Pattern " ") s

branches :: Aff (Maybe (Array BranchData))
branches = do
  j <- REQ.getAffReq url
  pure $ getBranchList j

getBranchList :: Maybe Json -> Maybe (Array BranchData)
getBranchList j = j >>= hush <$> decodeJson


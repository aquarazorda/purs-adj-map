module App.Events where

import Prelude
import App.Shared (Props)
import Control.Promise (Promise, toAffE)
import Effect (Effect)
import Effect.Aff (Aff)
import Foreign (Foreign)
import Web.HTML (HTMLElement)

foreign import getLang :: Record Props -> String -> String -> Effect (Promise String)

foreign import receiveMessage :: HTMLElement -> String -> String -> Effect (Promise Foreign)

receiveMessage' :: HTMLElement -> String -> String -> Aff Foreign
receiveMessage' p t = toAffE <<< receiveMessage p t

{-# LANGUAGE DeriveFunctor     #-}
{-# LANGUAGE OverloadedStrings #-}

module Test.Hspec.Blink1 where

import           Control.Concurrent
import           Control.Monad.Free
import qualified Data.Text              as T
import           Shelly
import           Test.Hspec             hiding (pending)
import           Test.Hspec.Core.Runner
import           Test.Hspec.Core.Spec   hiding (Pending, pending)

data BlinkActionF r = Passed r | Pending r | Failed r deriving (Functor)
type BlinkAction a = Free BlinkActionF a

passed' :: BlinkAction ()
passed' = liftF (Passed ())

pending' :: BlinkAction ()
pending' = liftF (Pending ())

failed' :: BlinkAction ()
failed' = liftF (Failed ())

blink' :: BlinkActionF (IO a) -> IO a
blink' (Passed r) = blink1Tool ["--rgb=0,255,0"] >> r
blink' (Failed r) = blink1Tool ["--rgb=255,0,0"] >> r
blink' (Pending r) = blink1Tool ["--rgb=255,165,0"] >> r

blink1Tool :: [T.Text] -> IO T.Text
blink1Tool = shelly . run "blink1-tool"

blinkIO :: BlinkAction a -> IO a
blinkIO = iterM blink'

blink1 :: Spec -> IO Summary
blink1 s = do
  blinkIO pending'
  summary <- hspecResult s
  case summaryFailures summary of
    0 -> blinkIO passed'
    _ -> blinkIO failed'
  return summary

example :: Spec
example = do
  describe "hspec" $ do
    it "runs a spec" $ do
      liftIO $ threadDelay 2000000
      1 `shouldBe` 1

{-# LANGUAGE OverloadedStrings #-}

module Test.Hspec.Blink1 where

import Shelly
import qualified Data.Text as T
import Test.Hspec hiding (pending)
import Test.Hspec.Core.Runner
import Test.Hspec.Core.Spec hiding (pending)
import Control.Concurrent

blink :: [T.Text] -> Sh T.Text
blink = verbosely . (run "blink1-tool")

failed :: Sh T.Text
failed = blink ["--rgb=255,0,0"]

pending :: Sh T.Text
pending = blink ["--rgb=255,165,0"]

passed :: Sh T.Text
passed = blink ["--rgb=0,255,0"]

blink1 :: Spec -> IO Summary
blink1 s = do
  shelly pending
  summary <- hspecResult s
  case summaryFailures summary of
    0 -> shelly passed
    _ -> shelly failed
  return summary

example :: Spec
example = do
  describe "hspec" $ do
    it "runs a spec" $ do
      liftIO $ threadDelay 2000000
      1 `shouldBe` 1

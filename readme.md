[Video](http://d.pr/v/1lhcL)

## Usage

Given a spec:

```haskell
example :: Spec
example = do
  describe "hspec" $ do
    it "runs a spec" $ do
      liftIO $ threadDelay 2000000
      1 `shouldBe` 1
```

With `blink1-tool` in your PATH (and a blink(1) device plugged into your computer ಠ_ಠ):

```haskell
blink1 example
```

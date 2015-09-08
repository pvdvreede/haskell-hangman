module GameSpec where

import Test.Hspec
import Game

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "fillInCharacter" $ do
    it "adds to the end of the guess array" $ do
      fillInCharacter (Puzzle "test" [] ['a']) 'c' `shouldBe` (Puzzle "test" [] ['c', 'a'])
    it "adds to soFar when guess is correct" $ do
      fillInCharacter (Puzzle "test" [Nothing, Nothing, Nothing, Nothing] []) 't' `shouldBe` (Puzzle "test" [Just 't', Nothing, Nothing, Just 't'] ['t'])
  describe "charGuess" $ do
    it "returns Nothing if not in word" $ do
      charGuess 'c' 'a' Nothing `shouldBe` Nothing
    it "returns the guess if in the word" $ do
      charGuess 'a' 'a' Nothing `shouldBe` Just 'a'

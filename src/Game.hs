module Game where

import Data.List (intersperse)

type WordList = [String]
data Puzzle = Puzzle String [Maybe Char] [Char] deriving Eq

instance Show Puzzle where
  show (Puzzle _ disc guessed) =
    (intersperse ' ' $ fmap renderPuzzleChar disc) ++ " Guessed so far: " ++ guessed

newPuzzle :: String -> Puzzle
newPuzzle s = Puzzle s (buildDiscovered s) []
  where buildDiscovered = fmap (const Nothing)

charInWord :: Puzzle -> Char -> Bool
charInWord (Puzzle w _ _) c = elem c w

alreadyGuessed :: Puzzle -> Char -> Bool
alreadyGuessed (Puzzle _ _ g) c = elem c g

renderPuzzleChar :: Maybe Char -> Char
renderPuzzleChar Nothing = '_'
renderPuzzleChar (Just c) = c

gameLength :: String -> Bool
gameLength wrds = l > 5 && l < 9
  where l = length wrds

fillInCharacter :: Puzzle -> Char -> Puzzle
fillInCharacter (Puzzle word soFar already) c =
    Puzzle word newSoFar (c : already)
  where newSoFar = zipWith (charGuess c) word soFar

charGuess :: Char -> Char -> Maybe Char -> Maybe Char
charGuess guess wChar gChar
  | guess == wChar = Just wChar
  | otherwise = gChar

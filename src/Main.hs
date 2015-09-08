module Main where

import Game
import Data.Char (toLower)
import Control.Monad (forever)
import Data.Maybe (isJust)
import System.Exit (exitSuccess)
import System.Random (randomRIO)

allWords :: IO WordList
allWords = do
  dict <- readFile "data/dict.txt"
  return (lines dict)

gameWords :: IO WordList
gameWords = do
  aw <- allWords
  return (filter gameLength aw)

randomWord :: WordList -> IO String
randomWord wl = do
  ri <- randomRIO (0, (length wl) - 1)
  return $ wl !! ri

randomWord' :: IO String
randomWord' = gameWords >>= randomWord

handleGuess :: Puzzle -> Char -> IO Puzzle
handleGuess puzzle guess = do
  putStrLn $ "Your guess was: " ++ [guess]
  case (charInWord puzzle guess, alreadyGuessed puzzle guess) of
    (_, True) -> do
      putStrLn "You have already tried guessing that, move on."
      return puzzle
    (True, _) -> do
      putStrLn "Well done! You made a correct guess."
      return (fillInCharacter puzzle guess)
    (False, _) -> do
      putStrLn "Bad luck, wrong guess!"
      return (fillInCharacter puzzle guess)

checkOver :: Puzzle -> IO ()
checkOver (Puzzle wrd soFar guessed)
  | (length guessed) > 7 = do
    putStrLn "Sorry, you loose."
    putStrLn $ "The word was: " ++ wrd
    exitSuccess
  | all isJust soFar = do
    putStrLn "You win! Fuck yeah!"
    exitSuccess
  | otherwise = return ()

runGame :: Puzzle -> IO ()
runGame puzzle = forever $ do
  putStrLn $ show puzzle
  checkOver puzzle
  putStrLn $ "Current puzzle is: " ++ show puzzle
  putStr "Guess a letter: "
  guess <- getLine
  case guess of
    [c] -> handleGuess puzzle c >>= runGame
    _   -> putStrLn "Use a single char dickhead."

main :: IO ()
main = do
  word <- randomWord'
  runGame $ newPuzzle (fmap toLower word)

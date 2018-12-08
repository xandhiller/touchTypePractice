# TODO:
# ✓ Timing of input -- how long did it take?
# ✓ Words per minute calculation
# ✓ If errors, how many errors?
# Letters per minute calculation
# Capture backspaces?
# ✓ Measure error?
# ✓ Log file to measure progress
# Progress chart

################################################################################
# OPEN FILES
################################################################################
words = open("words.txt", "r")
scoreFile = open("wordScores.txt", "a") 

################################################################################
# BEGIN FUNCTIONS
################################################################################
# Print paragraph to stdout
function displayParagraph(para)
  for i ∈ 1:length(para)
    typeof(para)
    printstyled(para[i], " ", bold=:bold)
  end
end

# Calculate number of words in response.
function nbCorrect(benchmark, attempt)
  count = 0
  c = 0
  a = split(attempt)
  b = benchmark
  # Need to account for b ≥ a or vice versa ⇒ indexing error
  length(a) ≥ length(b) ? c = b : c = a
  for i ∈ 1:length(c)
    if a[i] == b[i]
      count += 1
    end
  end
  return count
end 

# Calculates the number words per minute.
function wpm(rawLength, timeSecs)
  timeMins = timeSecs/60.0
  return rawLength/timeMins
end

function beginScores()
  println("\n\nSCORES: \n",
    "------------------------------------------------------------------")
end

function endScores()
  println("------------------------------------------------------------------")
end


################################################################################
# BEGIN MAIN
################################################################################
# Input for paragraph generation.
lines = readlines(words)
# Number of words to use in the game
numWords = 10
printScores = false
# Randomly sample some words
paragraph = []
for i ∈ 1:numWords
  push!(paragraph, rand(lines))
end 
# Running shell command to clear text
cmd = `clear`
run(cmd)
# Display the paragraph
printstyled("Touch-type the paragraph below [Press ENTER to begin timer]\n\n", 
            color=:yellow)
displayParagraph(paragraph)
# Take in the reponse and time it.
ready = readline() 
while ready != ""
  ready = readline()
end
printstyled("\nTimer [START].\n\n", color=:cyan)
t = @elapsed response = readline()
printstyled("\nTimer [END].\n\n", color=:cyan)
# Raw number of words input
rawWordLength = length(split(response))
score = nbCorrect(paragraph, response)
error = ((length(split(response)) - score)/float(length(split(response))))*100.0
wpm_ = wpm(rawWordLength, t)
if printScores == true
  beginScores()
  println("Number of words input is: " * string(rawWordLength) * "\n")
  # Number of correct words
  # Words per minute calculation
  println("Words per minute: " * string(wpm_)) 
  println("Error is: " * string(error) * "%" )
  endScores()
end
# Save scores
write(scoreFile, 
      string(error)*",", 
      string(wpm(score, t))*",", 
      string(rawWordLength),
     "\n")
# Close files and cat out scores to terminal. 
close(words)
close(scoreFile)

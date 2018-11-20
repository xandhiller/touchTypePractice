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
    print(para[i], " ")
  end
  println()
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
numWords = 20

# Randomly sample some words
paragraph = []
for i ∈ 1:numWords
  push!(paragraph, rand(lines))
end 

# Running shell command to clear text
cmd = `clear`
run(cmd)

# Display the paragraph
println("Type out this paragraph: \n")
displayParagraph(paragraph)

# Take in the reponse and time it.
println("\n\nCopy out the paragraph using touch-typing.\n")
println("Press ENTER to begin:\n\n")
ready = readline() 
while ready != ""
  ready = readline()
end
println("Timer has begun.\n\n")
t = @elapsed response = readline()

# Raw number of words input
rawWordLength = length(split(response))

beginScores()
println("Number of words input is: " * string(rawWordLength) * "\n")
# Number of correct words
score = nbCorrect(paragraph, response)
# Words per minute calculation
println("Words per minute: " * string(wpm(rawWordLength, t))) 
# Calculate total word error.
error = ((length(split(response)) - score)/float(length(split(response))))*100.0
println("Error is: " * string(error) * "%" )
endScores()

# Save scores
write(scoreFile, 
      string(error)*",", 
      string(wpm(score, t))*",", 
      string(rawWordLength),
     "\n")

# Close files and cat out scores to terminal. 
close(words)
close(scoreFile)

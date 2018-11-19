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
function displayNumbers(nb)
  for i ∈ 1:length(nb)
    typeof(nb)
    print(nb[i], " ")
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
  a ≥  b ? c = b : c = a

  for i ∈ 1:length(c)
    if a[i] == b[i]
      count += 1
    end
  end
  return count
end 

# Calculates the number of correct words per minute.
function wpm(scr, timeSecs)
  timeMins = timeSecs/60.0
  return scr/timeMins
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

# Number of words to use in the game
numNumbers = 20

# Randomly sample some words
numbers = []
for i ∈ 1:numNumbers
  push!(numbers, rand(1000, 9999))
end 

# Running shell command to clear text
cmd = `clear`
run(cmd)

# Display the paragraph
println("Type out this paragraph: \n")
displayNumbers(numbers)

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
println("Words per minute: " * string(wpm(score, t))) 
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

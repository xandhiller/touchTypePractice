# using Plots
#unicodeplots()
using UnicodePlots
using Logging
# logFile = "runLog.txt" # For future use
SimpleLogger(stdout, Logging.Debug)

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
  a = split(attempt)
  b = benchmark
#   display(count)
#   display(a)
#  display(b)

  for i ∈ 1:length(a)
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

words = open("words.txt", "r")
lines = readlines(words)

# Number of words to use in the game
numWords = 100
paragraph = []

# Randomly sample some words
for i ∈ 1:numWords
  push!(paragraph, rand(lines))
end 

#@info "The paragraph generated is: " display(paragraph)

# TODO:
# ✓ Timing of input -- how long did it take?
# Words per minute calculation
# If errors, how many errors?
# Letters per minute calculation
# Capture backspaces?
# Measure error?
# Log file to measure progress
# Progress chart

# Running shell command to clear text
cmd = `clear`
run(cmd)

# Display the paragraph
println("Type out this paragraph: \n")
displayParagraph(paragraph)

# Take in the reponse and time it.
println("\n\nCopy out the paragraph using touch-typing.\n")
t = @elapsed response = readline()

# Raw number of words input
rawWordLength = length(split(response))
println("Number of words input is: " * string(rawWordLength) * "\n")

# Number of correct words
score = nbCorrect(paragraph, response)
println("Accuracy score is: " * string(score) * "\n")

# Words per minute calculation
println("Words per minute: " * string(wpm(score, t)))

def removeSpaces word
	return word.split(" ").join('')
end

def anythingInCommon a1, a2
	return !(a1 & a2).empty?
end

def findWordsWithGivenNumberOfLetters words, num
	returnArray = []
	words.each do |n|
		if n.split('').length == num
			returnArray.push(n)
		end
	end
	return returnArray
end

def isAnagram str1, str2
	if str1.split('').sort == str2.split('').sort
		return true
	end
	return false
end

def check listToCheck, wordToCheck
	puts "checking"

	returnArray = []

	runner = ""
	counter = 0

	listToCheck.each do |n|
		print "#{counter} \r"
		runner = removeSpaces (n)
		if isAnagram runner, wordToCheck
			returnArray.push(n)
		end
		counter += 1
	end
	return returnArray.uniq
end

def oneWordGrams wordList, word
	newwordList = findWordsWithGivenNumberOfLetters wordList, word.length
	newwordList = check newwordList, word
	return newwordList
end

def multiWordGrams wordList, word, counter = -1 
  counter = word.length

  puts "finding permutations"
  puts wordList.length

  listOfWordCombos= wordList.permutation(counter).to_a
  gonnaCheck = []

  puts "Merging sets"

  runner = 0
  tester = ""
  listOfWordCombos.each do |n|
  	#print "#{(runner/listOfWordCombos.length)*100}\% complete. \r"
  	tester = n.join(" ")
  	print "#{runner}\r"
  	if (removeSpaces tester).length == word.length
    	gonnaCheck.push(tester)
    end
    runner +=1
  end

  return check gonnaCheck, word
end
 	
def findAnagram input
	input.downcase!
	input = input.split(' ').join('')
	puts "input is: #{input}"
	stringArray = input.downcase.split('')

	canadateWords = []

	#find all the words with anything in common with the input
	$englishWords.each do |n|
		if anythingInCommon(n.split(''), stringArray)
			canadateWords.push(n)
		end
	end

	unviableWords = []

	#remove all the words with 
	canadateWords.each do |m|
		#see if n has stuff that our word does not
		if !(m.split('') - stringArray == [])
			unviableWords.push(m)
		end
	end

	viableWords = canadateWords - unviableWords

  #puts "here"

	oneWordAnagrams = oneWordGrams viableWords, input

  #puts "here"

	multiWordAnagrams = multiWordGrams viableWords, input

	return oneWordAnagrams + multiWordAnagrams
end

lettersFile = File.open("./wiki-100k.txt")
$englishWords = lettersFile.readlines.map(&:chomp)


puts "Input string to anagram."
str = gets.chomp()

stringArray = str.downcase.split('')

$viablePhrases = []
$workingPhrase = ""

puts "Here are the possible one-word anagrams: #{findAnagram str}"

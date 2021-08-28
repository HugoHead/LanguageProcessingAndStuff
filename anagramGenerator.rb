$t0 = Time.now

trap "SIGINT" do
  puts "Ran for #{Time.now - $t0} seconds."
  exit 130
end

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

def findAllPerms list, k, maxlength = 0
  k = k-2
  #return list.combination(k).uniq.sort
  if maxlength < 1
    return list.combination(k).to_a
  end
  listsave = list 
  returnArray = []
  k.times do |n|
    print "#{n}/#{k}\r"
    list.each do |m|
      if m.length.to_i > maxlength+n+1 && n > 0
        #list = list.delete(m)
      end
    end
    returnArray += list.combination(n).to_a
    list = listsave 
  end
  return returnArray.uniq
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

def multiWordGrams wordList, word, counter = word.length-1
  wordList = wordList.uniq.sort
  puts "#{wordList.length} possible words found"

  listOfWordCombos = findAllPerms wordList, word.length, maxLength = counter
  puts "seting up sets for merging"
  gonnaCheck = []

  puts "Merging sets"

  runner = 0
  tester = ""
  listOfWordCombos.each do |n|
    tester = n.join(" ")
    print "#{runner}/#{listOfWordCombos.length} (#{runner*100/listOfWordCombos.length}\%)\r"
  	if (removeSpaces tester).length == word.length
    	gonnaCheck.push(tester)
    end
    runner +=1
  end
  return check gonnaCheck, word
end
 	
def findAnagram input
  $t0 = Time.now
	input.downcase!
  input = removeSpaces input
	puts "input is: #{input}"
	stringArray = input.downcase.split('')

	canadateWords = []

	#find all the words with anything in common with the input
	$englishWords.each do |n|
		if anythingInCommon(n.split(''), stringArray)
      if n.length <= stringArray.length
			  canadateWords.push(n)
      end
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

  return (oneWordAnagrams + multiWordAnagrams).uniq
end

lettersFile = File.open("./wiki-100k.txt")
$englishWords = lettersFile.readlines.map(&:chomp)


puts "Input string to anagram."
str = gets.chomp()

stringArray = str.downcase.split('')

$viablePhrases = []
$workingPhrase = ""

puts "Here are the possible anagrams: #{findAnagram str}"
puts "Completed in #{Time.now - $t0} seconds."

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
  k = maxlength-3
  #return list.combination(k).uniq.sort
  if maxlength < 1
    return list.combination(k).to_a
  end
  listsave = list 
  returnArray = []
  k.times do |n|
    print "#{n}/#{k}\r"
    #puts list.join("\" \"")
    list.each do |m|
      if m.length.to_i > maxlength+n+1 && n > 0
        list = list.delete(m)
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
    puts "checking list"
		print "#{counter} \r"
		runner = removeSpaces (n)
		if isAnagram runner, wordToCheck
			returnArray.push(n)
		end
		counter += 1
	end
	return returnArray.uniq
end

def doublicates string
  string = string.split("")
  dup = string.select{|element| string.count(element) > 1 }
  return dup
end

def hasDoublicates canadates, string
  start = canadates
  string = string.split("")
  if canadates.class == String
    return false
  end
  canadates.each do |n|
    if string.include? (n)
      canadates.delete(n)
      string.delete(n)
    end
  end
  if (start & canadates) == canadates
    return false
  end
  return true
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

  dubs = []
	#remove all the words with things the input does not have
	canadateWords.each do |m|
		#see if n has stuff that our word does not
    dubs = doublicates m
    if !(m.split('') - stringArray == [])
			unviableWords.push(m)
    elsif hasDoublicates dubs, input
      puts m
      unviableWords.push(m)
    end
	end

	viableWords = canadateWords - unviableWords
	oneWordAnagrams = oneWordGrams viableWords, input
	multiWordAnagrams = multiWordGrams viableWords, input

  unusedWord = viableWords - multiWordAnagrams.map {|index| index.split(" ")}.flatten
  puts unusedWord.uniq

  return (multiWordAnagrams + oneWordAnagrams)
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

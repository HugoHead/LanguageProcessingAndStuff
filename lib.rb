
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

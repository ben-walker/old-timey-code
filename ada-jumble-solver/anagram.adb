package body anagram is

    --recursively generate all permutations of a string.
    --code reference: https://stackoverflow.com/questions/7537791/understanding-recursion-to-generate-permutations
    procedure generateAnagram(jumble: in string; anagrams: out vector; currentIndex: in integer := 1) is
        jumbleCopy : string := jumble; --copy to operate on, so 'jumble' does not need to be an 'in out' param.
    begin
        if currentIndex = jumbleCopy'length then --add permutation to anagrams vector.
            anagrams.append(to_unbounded_string(jumbleCopy));
        else
            for i in currentIndex..jumbleCopy'length loop
                swap(jumbleCopy, currentIndex, i);
                generateAnagram(jumbleCopy, anagrams, currentIndex + 1); --recursive call, iterate current index.
                swap(jumbleCopy, currentIndex, i);
            end loop;
        end if;
    end generateAnagram;

    --filter anagrams to just those that appear in a lexicon.
    function findAnagram(potentialAnagrams: vector; lexicon: vector) return vector is
        anagramsIterator : cursor := potentialAnagrams.first; --vector cursor, allows iterating/element retrieving.
        validAnagrams : vector;
        currentAnagram : unbounded_string;
    begin
        while has_element(anagramsIterator) loop
            currentAnagram := element(anagramsIterator);

            --if current anagram is in the lexicon and not in the valid anagram vector,
            --add it to the valid anagram vector.
            if contains(lexicon, currentAnagram) and not contains(validAnagrams, currentAnagram) then
                validAnagrams.append(currentAnagram);
            end if;
            next(anagramsIterator);
        end loop;
        return validAnagrams;
    end findAnagram;

end anagram;

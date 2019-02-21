with ada.text_io; use ada.text_io;
with ada.io_exceptions; use ada.io_exceptions;
with ada.strings.unbounded.text_io; use ada.strings.unbounded.text_io;
with ada.strings.maps.constants; use ada.strings.maps.constants;

package body jumbleUtilities is

    --swap two characters in a string.
    procedure swap(mutate: in out string; firstIndex: in integer; secondIndex: in integer) is
        intermediate : character;
    begin
        intermediate := mutate(firstIndex);
        mutate(firstIndex) := mutate(secondIndex);
        mutate(secondIndex) := intermediate;
    end swap;

    --print all elements in a vector, separated by a new-line.
    procedure printVectorElements(container: in vector) is
        vectorIterator : cursor := container.first;
    begin
        --iterate through vector, print each element.
        while has_element(vectorIterator) loop
            put_line(element(vectorIterator));
            next(vectorIterator);
        end loop;
    end printVectorElements;

    --produce vector of words found in system dictionary.
    function buildLEXICON(dictionaryFilePath: string) return vector is
        lexicon : vector;
        dictionary : file_type;
    begin
        open(dictionary, in_file, dictionaryFilePath);
        while not end_of_file(dictionary) loop
            lexicon.append(get_line(dictionary));
        end loop;
        close(dictionary);
        return lexicon;

        exception
            when ada.io_exceptions.name_error =>
                put("Could not find system dictionary file.");
                raise ada.io_exceptions.name_error;
    end buildLEXICON;

    --get the user's word jumble.
    function inputJumble return unbounded_string is
    begin
        put("Next jumble?: ");
        return translate(get_line, lower_case_map); --return the string as lower-case.
    end inputJumble;

    --get the user selected best matching anagram.
    function inputBestMatch(anagrams: vector) return unbounded_string is
        bestMatch : unbounded_string;
    begin
        if length(anagrams) = 1 then --don't make user enter anagram if only 1 found.
            put_line("Only 1 anagram found; it's the best suit!");
            return element(anagrams.first);
        end if;

        --loop until the user enters an anagram which was actually found.
        while not contains(anagrams, bestMatch) loop
            put("Which anagram best suits the jumbled letters?: ");
            bestMatch := translate(get_line, lower_case_map);
        end loop;
        return bestMatch;
    end inputBestMatch;

    --get the final clue letter positions from user.
    function inputFinalLetterPositions return unbounded_string is
        finalLetterPositions : unbounded_string;
    begin
        --loop until the user enters a valid positions string (i.e. all characters represent integers).
        while not positionsAreValid(finalLetterPositions) loop
            put("What are the positions of the final clue letters (Ex: '134')?: ");
            finalLetterPositions := get_line;
        end loop;
        return finalLetterPositions;
    end inputFinalLetterPositions;

    --get the string representing the indexes of anagram found in finalPositions.
    function getFinalLetters(anagram: unbounded_string; finalPositions: unbounded_string) return unbounded_string is
        finalLetters : unbounded_string;
        index : integer;
        matchedLetter : string(1..1); --the current matched letter; a string one letter long.
    begin
        --loop over all final clue positions, translate that position
        --to an integer index, retrieve the letter at that index, append it
        --to the final string.
        for i in 1..length(finalPositions) loop
            index := integer'value("" & element(finalPositions, i));
            matchedLetter := "" & element(anagram, index);
            finalLetters := finalLetters & matchedLetter;
        end loop;
        return finalLetters;

        exception
            when ada.strings.index_error =>
                put("Position of final clue letter out of bounds.");
                raise ada.strings.index_error;
    end getFinalLetters;

    --ensure that the string of positions is valid (i.e. all characters represent integer).
    --return true if valid, false if invalid.
    function positionsAreValid(positions: unbounded_string) return boolean is
        position : integer;
    begin
        if length(positions) = 0 then --base case: an empty string is invalid.
            return false;
        end if;

        for i in 1..length(positions) loop
            position := integer'value("" & element(positions, i));
        end loop;
        return true; --if we successfully translate each element to integer, return true.

        exception
            when constraint_error =>
                return false; --if an exception is raised (i.e. character can't convert to integer), return false.
    end positionsAreValid;

end jumbleUtilities;

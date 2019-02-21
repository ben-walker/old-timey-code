------------------------
-- solvejumble.adb
-- Find anagrams of word jumbles in a dictionary.
--
-- Class: CIS*3190
-- Author: Ben Walker
-- Student #: 0883544
-- Date: Feb. 26/2018
------------------------

with ada.text_io; use ada.text_io;
with ada.strings.unbounded; use ada.strings.unbounded;
with ada.strings.unbounded.text_io; use ada.strings.unbounded.text_io;
with ada.containers.vectors; use ada.containers;
with anagram; use anagram;
with jumbleUtilities; use jumbleUtilities;

procedure SolveJumble is
    use stringVector;
    no_anagram : exception; --exception for when no anagrams found.

    dictionaryFilePath : constant string := "/usr/share/dict/words";
    lexicon : vector; --all strings found in dictionary.
    
    jumble : unbounded_string; --word jumble that user enters.
    masterJumble : unbounded_string; --word jumble formed from clue positions in each solved jumble.
    bestMatch : unbounded_string; --user input anagram which best matches the word jumble.
    finalLetterPositions : unbounded_string; --each character in this string is the index of the clue letter.

    rawAnagrams : vector; --all anagrams found for a jumble, not necessarily in lexicon.
    validAnagrams : vector; --all anagrams found for a jumble which also appear in lexicon.

begin
    --setup the lexicon and get the first jumble.
    lexicon := buildLEXICON(dictionaryFilePath);
    put_line("You can continue entering jumbles indefinitely, or type 'end' to solve the puzzle!");
    jumble := inputJumble;

    while jumble /= "end" loop --loop until the user chooses to stop entering jumbles.
        generateAnagram(to_string(jumble), rawAnagrams); --get all anagrams for word jumble.

        --find anagrams in lexicon, ensure at least one found.
        validAnagrams := findAnagram(rawAnagrams, lexicon);
        if length(validAnagrams) = 0 then
            raise no_anagram;
        end if;

        put_line("Anagrams found:");
        printVectorElements(validAnagrams);

        bestMatch := inputBestMatch(validAnagrams); --user enters the anagram they think is best match.
        finalLetterPositions := inputFinalLetterPositions; --user enters index of final clue letters.
        masterJumble := masterJumble & getFinalLetters(bestMatch, finalLetterPositions); new_line; --append clue letters to final jumble.

        --reset the anagrams found for this jumble, get the next jumble.
        clear(rawAnagrams);
        jumble := inputJumble;
    end loop;
    put_line("No more jumbles, moving on..."); new_line;

    --show the jumble resulting from the clue positions in the solved word jumbles,
    --and its anagrams as possible solutions.
    put_line("Your final jumble is: " & masterJumble);
    generateAnagram(to_string(masterJumble), rawAnagrams);
    validAnagrams := findAnagram(rawAnagrams, lexicon);
    if length(validAnagrams) = 0 then
        put_line("Sorry, no solutions were found :(");
        return;
    end if;

    --it's up to the user to pick the best solution.
    put_line("Possible solutions:");
    printVectorElements(validAnagrams); --show valid anagrams found for final word jumble.

    exception
        when data_error =>
            put_line("Sorry, an integer is expected.");
        when no_anagram =>
            put_line("No anagrams found; maybe you mistyped?");
end SolveJumble;

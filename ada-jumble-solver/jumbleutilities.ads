------------------------
-- jumbleutilities.ads
-- Helper functions for word jumble solver.
--
-- Class: CIS*3190
-- Author: Ben Walker
-- Student #: 0883544
-- Date: Feb. 26/2018
------------------------

with ada.strings.unbounded; use ada.strings.unbounded;
with ada.containers.vectors; use ada.containers;

package jumbleUtilities is
    package stringVector is new vectors(natural, unbounded_string);
    use stringVector;

    procedure swap(mutate: in out string; firstIndex: in integer; secondIndex: in integer);
    procedure printVectorElements(container: in vector);
    function buildLEXICON(dictionaryFilePath: string) return vector;
    function inputJumble return unbounded_string;
    function inputBestMatch(anagrams: vector) return unbounded_string;
    function inputFinalLetterPositions return unbounded_string;
    function getFinalLetters(anagram: unbounded_string; finalPositions: unbounded_string) return unbounded_string;
    
    private
        function positionsAreValid(positions: unbounded_string) return boolean;
end jumbleUtilities;

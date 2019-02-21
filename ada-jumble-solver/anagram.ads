------------------------
-- anagram.ads
-- Generate anagrams, find anagrams in lexicon.
--
-- Class: CIS*3190
-- Author: Ben Walker
-- Student #: 0883544
-- Date: Feb. 26/2018
------------------------

with ada.strings.unbounded; use ada.strings.unbounded;
with jumbleUtilities; use jumbleUtilities;

package anagram is
    use stringVector;
    
    procedure generateAnagram(jumble: in string; anagrams: out vector; currentIndex: in integer := 1);
    function findAnagram(potentialAnagrams: vector; lexicon: vector) return vector;
end anagram;

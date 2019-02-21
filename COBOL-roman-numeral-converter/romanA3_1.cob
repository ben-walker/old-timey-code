*> romanA3_1.cob
*>
*> Convert roman numerals to decimals, either
*> from user input or file IO.
*>
*> Class: CIS*3190
*> Author: Ben Walker
*> Student #: 0883544
*> Date: Mar. 21, 2018

identification division.
program-id. roman_numeral_converter.

data division.
working-storage section.
77 numeral pic x(30). *> numeral entered by user or filename
77 lower_numeral pic x(30). *> lower-case version of numeral (not filename)
77 decimal_equivalent pic s9(12). *> decimal representation of the numeral
77 numeral_status pic 9. *> 1 if illegal numeral, 0 if valid
77 file_read_status pic 9. *> 1 if file found/read, 0 otherwise
77 input_prompt pic x(54) value "Enter a roman numeral, the name of a file, or 'quit': ".

procedure division.
    display input_prompt with no advancing accept numeral

    perform until numeral = "quit"
        *> naively try to read the numeral as a file
        call "convert_numeral_file" using numeral, file_read_status

        *> if no file was found/read, convert numeral as is
        if file_read_status = 0
            *> call conversion with lower-case numeral; case no longer matters
            move function lower-case(numeral) to lower_numeral
        	call "convert_numeral" using lower_numeral, decimal_equivalent, numeral_status
            call "show_numeral_and_decimal" using numeral, decimal_equivalent, numeral_status
        end-if
        display input_prompt with no advancing accept numeral
    end-perform.

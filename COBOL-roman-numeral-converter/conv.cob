*> conv.cob
*>
*> Convert a single roman numeral to its
*> decimal equivalent, or flag if illegal.
*>
*> Class: CIS*3190
*> Author: Ben Walker
*> Student #: 0883544
*> Date: Mar. 21, 2018

identification division.
program-id. convert_numeral.

data division.
working-storage section.
77 dec pic 9(4). *> decimal equivalent of current numeral character
77 next_dec pic 9(4). *> decimal equivalent of the next numeral character
77 i pic s99. *> loop index

linkage section.
77 numeral pic x(30). *> numeral string from user
77 equivalent pic s9(12). *> equivalent decimal
77 numeral_status pic 9. *> 1 if illegal numeral, 0 if valid

procedure division using numeral, equivalent, numeral_status.
    move 0 to equivalent, numeral_status *> numeral assumed valid

    *> loop through each character in numeral string
    move 1 to i
    perform until i > length of numeral
        *> get decimal representation from current numeral character and next.
        *> order of conversion matters; at end of string, numeral(i + 1 : 1) will always be
        *> invalid. call "get-decimal" with numeral(i : 1) last so we only check
        *> if the actual final character is invalid.
        call "get_decimal" using numeral(i + 1 : 1), next_dec, numeral_status
        call "get_decimal" using numeral(i : 1), dec, numeral_status
        
        *> immediately return if invalid character found
        if numeral_status = 1
            exit perform
        end-if

        *> add current decimal representation if >= next decimal, or if it's the last character
        if dec >= next_dec or i = length of numeral
            add dec to equivalent
        else
            subtract dec from equivalent
        end-if

        add 1 to i
    end-perform.

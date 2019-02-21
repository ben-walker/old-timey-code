*> show_numeral_and_decimal.cob
*>
*> Display a roman numeral and its
*> decimal equivalent to the user.
*>
*> Class: CIS*3190
*> Author: Ben Walker
*> Student #: 0883544
*> Date: Mar. 21, 2018

identification division.
program-id. show_numeral_and_decimal.

data division.
working-storage section.
77 formatted_decimal pic z(12). *> variable for printing, no leading zeroes

linkage section.
77 numeral pic x(30). *> numeral to print, along with the...
77 decimal_equivalent pic s9(12). *> decimal to print
77 numeral_status pic 9. *> 1 if illegal numeral, 0 otherwise

procedure division using numeral, decimal_equivalent, numeral_status.
    *> only show numeral/decimal if legal numeral
    if numeral_status = 0
        move decimal_equivalent to formatted_decimal
        display formatted_decimal " :: " numeral
    else
        display "Illegal roman numeral :: " numeral
    end-if.

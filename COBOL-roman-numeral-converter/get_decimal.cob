*> get_decimal.cob
*>
*> Convert an individual roman numeral
*> character to its decimal counterpart.
*>
*> Class: CIS*3190
*> Author: Ben Walker
*> Student #: 0883544
*> Date: Mar. 21, 2018

identification division.
program-id. get_decimal.

data division.
linkage section.
77 numeral_character pic x. *> numeral character to evaluate
77 decimal_value pic 9(4). *> decimal value of numeral character
77 numeral_status pic 9. *> 1 if illegal character, 0 otherwise

procedure division using numeral_character, decimal_value, numeral_status.
    move 0 to decimal_value, numeral_status *> assume character is valid

    *> switch on numeral character, determining decimal value
    evaluate numeral_character
        when 'i'
            move 1 to decimal_value
        when 'v'
            move 5 to decimal_value
        when 'x'
            move 10 to decimal_value
        when 'l'
            move 50 to decimal_value
        when 'c'
            move 100 to decimal_value
        when 'd'
            move 500 to decimal_value
        when 'm'
            move 1000 to decimal_value
        when not ' ' *> spaces are ignored; i.e. not invalid
            move 1 to numeral_status
    end-evaluate.

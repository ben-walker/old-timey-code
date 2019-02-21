*> get_upper_limit.cob
*>
*> Get the upper prime limit from the user.
*>
*> Class: CIS*3190
*> Author: Ben Walker
*> Student #: 0883544
*> Date: Apr. 6, 2018

identification division.
program-id. get_upper_limit.

data division.
linkage section.
77 upper_limit pic 9(9).
77 return_status pic 9.

procedure division using upper_limit, return_status.
    move 0 to return_status
    display "Upper limit?: " with no advancing accept upper_limit
    
    if upper_limit < 2
    	display "The upper limit cannot be less than 2."
        move 1 to return_status
    end-if.

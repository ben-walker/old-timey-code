*> compute_sieve.cob
*>
*> Calculate whether each array index is a prime (true or false).
*>
*> Class: CIS*3190
*> Author: Ben Walker
*> Student #: 0883544
*> Date: Apr. 6, 2018

identification division.
program-id. compute_sieve.

data division.
working-storage section.
77 i pic 9(9).
77 j pic 9(9).
77 i_squared pic 9(9).

linkage section.
01 eratosthenes_sieve.
    05 sieve pic 9 occurs 2 to 100000000 depending on upper_limit value 1.
77 upper_limit pic 9(9).
77 lower_bound pic 9(9).

procedure division using lower_bound, upper_limit, eratosthenes_sieve.
    move 1 to i
    perform until i > lower_bound
        compute i_squared = i ** 2

        *> leave i as prime, mark all its multiples as not prime
        if sieve(i) = 1
            move i_squared to j
            perform until j > upper_limit
                move 0 to sieve(j)
                add i to j
            end-perform
        end-if

        add 1 to i
    end-perform.

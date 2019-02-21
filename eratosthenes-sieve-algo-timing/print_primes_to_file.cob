*> print_primes_to_file.cob
*>
*> Print all true indexes to a file.
*>
*> Class: CIS*3190
*> Author: Ben Walker
*> Student #: 0883544
*> Date: Apr. 6, 2018

identification division.
program-id. print_primes_to_file.

environment division.
input-output section.
file-control.
    select primes_file assign to "eratosthenes_cob.txt"
    organization is line sequential.

data division.
file section.
fd primes_file.
01 primes_record.
    05 prime pic 9(9).

working-storage section.
77 i pic 9(9) value 1.

linkage section.
77 file_name pic x(20).
01 eratosthenes_sieve.
    05 sieve pic 9 occurs 2 to 100000000 depending on upper_limit value 1.
77 upper_limit pic 9(9).

procedure division using file_name, eratosthenes_sieve, upper_limit.
    open output primes_file
        perform until i > upper_limit
            if sieve(i) = 1
                move i to prime
                write primes_record
            end-if

            add 1 to i
        end-perform
    close primes_file.

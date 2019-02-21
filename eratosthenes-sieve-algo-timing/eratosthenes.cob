*> eratosthenes.cob
*>
*> Perform Sieve of Eratosthenes algorithm in Cobol.
*>
*> Class: CIS*3190
*> Author: Ben Walker
*> Student #: 0883544
*> Date: Apr. 6, 2018

identification division.
program-id. eratosthenes.

data division.
working-storage section.
77 file_name pic x(20).
01 eratosthenes_sieve.
    05 sieve pic 9 occurs 2 to 100000000 depending on upper_limit value 1.
77 upper_limit pic 9(9). *> calculate all primes <= the upper_limit
77 lower_bound pic 9(9). *> square root of the upper_limit
77 return_status pic 9. *> 1 if upper_limit not valid
77 timing_mode pic 9 value 0. *> 0 print primes to file, 1 generate primes

procedure division.
	call "get_upper_limit" using upper_limit, return_status
    if return_status = 1
        goback
    end-if

	compute lower_bound rounded = upper_limit ** 0.5
    move 0 to sieve(1) *> manually set 1 to not prime
    call "compute_sieve" using lower_bound, upper_limit, eratosthenes_sieve

    if timing_mode = 0
        call "print_primes_to_file" using file_name, eratosthenes_sieve, upper_limit
    end-if.

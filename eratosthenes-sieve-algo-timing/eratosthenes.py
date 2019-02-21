#!/usr/bin/env python

# eratosthenes.py
#
# Perform Sieve of Eratosthenes algorithm in Python.
#
# Class: CIS*3190
# Author: Ben Walker
# Student #: 0883544
# Date: Apr. 6, 2018

from math import sqrt

# false: primes generated and output to file, true: primes generated
TIMING_MODE = False
FILE_NAME = 'eratosthenes_py.txt'

def get_upper_limit():
    upper_limit = input('Upper limit?: ')
    if upper_limit < 2: raise ValueError('The upper limit cannot be less than 2.')
    return upper_limit + 1

def compute_sieve(lower_bound, upper_limit, sieve):
    for i in range(lower_bound):
        if sieve[i]:
            # leave i as prime, mark all its multiples as not prime
            for j in range(i**2, upper_limit, i):
                sieve[j] = False

def print_primes_to_file(file_name, sieve):
    with open(file_name, 'w') as fp:
        # prime is sieve index, indicator is value at index (True or False)
        for prime, indicator in enumerate(sieve):
            if indicator: fp.write("%d\n" % prime)

upper_limit = get_upper_limit() # calculate all primes <= the upper_limit
lower_bound = int(sqrt(upper_limit)) # the square root of the upper_limit

sieve = [True] * upper_limit # initialize array of boolean values to True
sieve[0] = sieve[1] = False # manually set 0, 1 to False (i.e. not prime)

compute_sieve(lower_bound, upper_limit, sieve)
if TIMING_MODE == False: print_primes_to_file(FILE_NAME, sieve)

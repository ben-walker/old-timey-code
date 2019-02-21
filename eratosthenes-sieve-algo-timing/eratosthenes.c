// eratosthenes.c
//
// Perform Sieve of Eratosthenes algorithm in C.
//
// Class: CIS*3190
// Author: Ben Walker
// Student #: 0883544
// Date: Apr. 6, 2018

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <stdbool.h>
#include <string.h>

int getUpperLimit();
void computeSieve(int, int, bool **);
void printPrimesToFile(const char *, bool *, int);

int main() {
    const char *fileName = "eratosthenes_c.txt";
    const bool timingMode = false; // false: primes generated and output to file, true: primes generated

    int upperLimit; // calculate all primes <= upperLimit
    int lowerBound; // the square root of the upperLimit
    bool *sieve; // array of boolean values, length is upperLimit

    upperLimit = getUpperLimit();
    lowerBound = (int)sqrt(upperLimit);

    sieve = malloc(sizeof(bool) * upperLimit);
    if (sieve == NULL) {
        printf("Could not allocate memory for sieve.\n");
        exit(EXIT_FAILURE);
    }
    memset(sieve, true, upperLimit); // default all numbers to prime
    sieve[0] = sieve[1] = false; // manually set 0, 1 to false (i.e. not prime)

    computeSieve(lowerBound, upperLimit, &sieve);

    if (!timingMode) {
        printPrimesToFile(fileName, sieve, upperLimit);
    }

    free(sieve);
}

int getUpperLimit() {
    int limit;

    printf("Upper limit?: ");
    scanf("%d", &limit);
    if (limit < 2) {
        printf("The upper limit cannot be less than 2.\n");
        exit(EXIT_FAILURE);
    }
    return limit + 1;
}

void computeSieve(int lowerBound, int upperLimit, bool **sieve) {
    for (int i = 0; i < lowerBound; i++) {
        if ((*sieve)[i]) { // leave i as prime, mark all its multiples as not prime
            for (int j = i * i; j < upperLimit; j += i) {
                (*sieve)[j] = false;
            }
        }
    }
}

void printPrimesToFile(const char * fileName, bool * sieve, int sieveSize) {
    FILE * fp = fopen(fileName, "w");
    if (fp == NULL) {
        printf("Error opening file.\n");
        exit(EXIT_FAILURE);
    }

    for (int i = 0; i < sieveSize; i++) {
        if (sieve[i]) { // if the current array value is true, print i to file
            fprintf(fp, "%d\n", i);
        }
    }

    fclose(fp);
}

! eratosthenes.f95
!
! Perform Sieve of Eratosthenes algorithm in Fortran.
!
! Class: CIS*3190
! Author: Ben Walker
! Student #: 0883544
! Date: Apr. 6, 2018

program eratosthenes
    implicit none

    character(len = *), parameter :: fileName = "eratosthenes_f95.txt"
    ! false: primes generated and output to file, true: primes generated
    logical, parameter :: timingMode = .false. 

    ! calculate primes <= upperLimit; lowerBound is square root of upperLimit
    integer :: lowerBound, upperLimit
    integer :: i ! index for implicit loop when initializing sieve
    logical, allocatable, dimension( : ) :: sieve ! array of logical values, length is upperLimit
    integer :: getUpperLimit

    upperLimit = getUpperLimit()
    lowerBound = int(sqrt(real(upperLimit)))

    allocate(sieve(2 : upperLimit))
    sieve(2 : upperLimit) = (/ (.true., i = 2, upperLimit) /) ! default all numbers to prime

    call computeSieve(lowerBound, upperLimit, sieve)
    if (.not. timingMode) then
        call printPrimesToFile(fileName, sieve, upperLimit)
    endif
end program eratosthenes

integer function getUpperLimit()
    implicit none

    integer :: ioerror

    write (*, *) 'Upper limit?: '
    read (*, '(i10)', iostat = ioerror) getUpperLimit
    if (getUpperLimit < 2) then
        write (*, *) 'The upper limit cannot be less than 2.'
        getUpperLimit = 0
    endif
end function getUpperLimit

subroutine computeSieve(lowerBound, upperLimit, sieve)
    implicit none

    integer, intent(in) :: lowerBound, upperLimit
    logical, dimension(2 : upperLimit), intent(inout) :: sieve
    integer :: i, j

    do i = 2, lowerBound
        if (sieve(i)) then ! leave i as prime, mark all its multiples as not prime
            do j = i ** 2, upperLimit, i
                sieve(j) = .false.
            end do
        endif
    end do
end subroutine computeSieve

subroutine printPrimesToFile(fileName, sieve, upperLimit)
    implicit none

    character(len = *), intent(in) :: fileName
    integer, intent(in) :: upperLimit
    logical, dimension(2 : upperLimit), intent(in) :: sieve
    integer :: i

    open(1, file = fileName)
    do i = 2, upperLimit
        if (sieve(i)) then ! if the current array value is true, print i to file
            write (1, *) i
        endif
    end do
    close(1)
end subroutine printPrimesToFile

!
! tic-tac-toe game written in Fortran 95.
! The human player competes against a computer
! opponent.
!
! author: Ben Walker
! date: 2018/01/30
!

! 
! sets up game parameters (size of board, player
! and ai representations), calls playTicTacToe()
! to start the game.
!
program tictactoe
    implicit none

    ! local variables
    integer, parameter :: size = 3 ! size of the board
    character(len = 1), parameter :: player = 'X', ai = 'O' ! character representations of players

    ! begin tic-tac-toe
    call playTicTacToe(size, player, ai)
end program tictactoe

!
! performs the main game loop, alternating
! between player and ai turns, and checking for
! a winner.
!
subroutine playTicTacToe(size, player, ai)
    implicit none

    ! calling variables
    integer, intent(in) :: size
    character(len = 1), intent(in) :: player, ai

    ! local variables
    character(len = 1), dimension(size, size) :: tictac ! board character array
    integer :: playerMove, aiMove ! numeric (1-9) move representations
    logical :: over ! .true. game is over
    character(len = 1) :: winner ! character representation of winner ('D' for draw)

    write (*, *) 'Tic Tac Toe: Enter a number from 1-9 to play'
    write (*, *) 'You are: ', player

    call numerateBoard(tictac, size)
    call showBoard(tictac, size)
    call clearBoard(tictac, size)

    do
        ! get player's move, validate that space is unoccupied
        playerMove = getMove()
        do while (chkplay(tictac, playerMove, size) .eqv. .false.)
            write (*, *) 'Invalid move; space is occupied'
            playerMove = getMove()
        end do

        ! perform player move, show board.
        call makeMove(tictac, playerMove, player, size)
        write (*, *) 'After your move'
        call showBoard(tictac, size)

        ! check if game is over
        call chkover(tictac, over, winner)
        if (over) then
            exit
        end if

        ! perform ai move, show board.
        aiMove = pickMove(tictac, size)
        call makeMove(tictac, aiMove, ai, size)
        write (*, *) 'After my move'
        call showBoard(tictac, size)

        ! check if game is over
        call chkover(tictac, over, winner)
        if (over) then
            exit
        end if
    end do

    ! declare draw or winner
    if (winner == 'D') then
        write (*, *) 'Draw, no winner!'
    else
        write (*, *) winner, ' wins!'
    end if

    contains

    !
    ! gets the player's move, validates
    ! that it's an integer from 1-9.
    !
    integer function getMove()
        implicit none

        ! local variables
        integer :: ioerror ! not equal to zero if error reading integer

        ! validate that player's move is integer between 1 and 9,
        ! and that there's no integer read error
        getMove = 0
        do while (ioerror /= 0 .or. getMove < 1 .or. getMove > 9)
            write (*, *) 'Your move: '
            read (*, '(i10)', iostat = ioerror) getMove
        end do
    end function getMove

    !
    ! calculates the ai move.
    !
    integer function pickMove(tictac, size)
        implicit none

        ! calling variables
        integer, intent(in) :: size
        character(len = 1), intent(in), dimension(size, size) :: tictac

        ! local variables
        integer, dimension(size, size) :: tictacScores ! numeric 2D array, holds point value of each space on tictac
        integer :: row, col, total ! row/column indexers, total is the point sum of a diagonal
        integer :: emptyIndex ! index of empty square in a diagonal
        integer, dimension(3) :: diagonal ! numeric array, holds point value of diagonals from tictac

        ! seed for random_number()
        call init_random_seed()

        ! translates tictac into numeric 2D array, each square holds
        ! point value from tictac
        call translateBoardToScores(tictac, tictacScores, size)
        pickMove = 0

        ! check rows for viable ai moves
        do row = 1, size
            ! set column index equal to minimum score in each row
            col = minloc(tictacScores(row, 1:size), dim = 1)

            ! check for row sum of 8 or 2; if 8 found, return
            if (sum(tictacScores(row:row, 1:size)) == 8 .and. tictac(row, col) /= 'X') then
                ! this calculation translates row/column indexes into
                ! numeric (1-9) move
                pickMove = (row - 1) * size + col
                return
            else if (sum(tictacScores(row:row, 1:size)) == 2 .and. tictac(row, col) /= 'X') then
                pickMove = (row - 1) * size + col
            end if
        end do

        ! check columns for viable ai moves
        do col = 1, size
            row = minloc(tictacScores(1:size, col), dim = 1)
            if (sum(tictacScores(1:size, col:col)) == 8 .and. tictac(row, col) /= 'X') then
                pickMove = (row - 1) * size + col
                return
            else if (sum(tictacScores(1:size, col:col)) == 2 .and. tictac(row, col) /= 'X') then
                pickMove = (row - 1) * size + col
            end if
        end do

        ! check diagonals for viable ai moves
        diagonal = (/1, 5, 9/)
        call chkdiagonal(diagonal, tictacScores, size, total, emptyIndex)

        if (total == 8) then
            pickMove = emptyIndex
            return
        else if (total == 2) then
            pickMove = emptyIndex
        end if

        diagonal = (/3, 5, 7/)
        call chkdiagonal(diagonal, tictacScores, size, total, emptyIndex)

        if (total == 8) then
            pickMove = emptyIndex
            return
        else if (total == 2) then
            pickMove = emptyIndex
        end if

        ! if no preferred ai move has been determined,
        ! pick a random spot
        if (pickMove == 0) then
            do row = 1, size
                do col = 1, size
                    if (tictac(row, col) == ' ') then
                        pickMove = (row - 1) * size + col
                    end if
                end do
            end do
        end if
    end function pickMove

    !
    ! checks that the player's move is not in an occupied space.
    !
    logical function chkplay(tictac, move, size)
        implicit none

        ! calling variables
        integer, intent(in) :: size
        character(len = 1), intent(in), dimension(size, size) :: tictac
        integer, intent(in) :: move

        ! local variables
        integer :: row, col ! row/column indexers

        ! retrieve the row/col associated with the move index
        call getXandY(move, row, col, size)
        chkplay = tictac(row, col) == ' '
    end function chkplay
end subroutine playTicTacToe

!
! finds the sum of the diagonal spaces, and the index
! of the empty spot (if applicable).
!
subroutine chkdiagonal(diagonal, tictacScores, size, total, emptyIndex)
    implicit none

    ! calling variables
    integer, intent(in) :: size
    integer, dimension(size), intent(in) :: diagonal
    integer, dimension(size, size), intent(in) :: tictacScores
    integer, intent(out) :: total, emptyIndex

    ! local variables
    integer :: i, row, col ! i iterates through diagonal

    total = 0
    do i = 1, size
        ! get row/col coordinates, add score at index to total
        call getXandY(diagonal(i), row, col, size)
        total = total + tictacScores(row, col)

        ! if the space is empty, set emptyIndex
        if (tictacScores(row, col) == 0) then
            emptyIndex = diagonal(i)
        end if
    end do
end subroutine chkdiagonal

!
! puts each space's index on the board.
!
subroutine numerateBoard(tictac, size)
    implicit none

    ! calling variables
    integer, intent(in) :: size
    character(len = 1), intent(out), dimension(size, size) :: tictac

    ! fill the board with indexes, reshape it to a 3x3 board
    tictac = reshape((/'1', '4', '7', '2', '5', '8', '3', '6', '9'/), (/size, size/))
end subroutine numerateBoard

!
! clears all board spaces.
!
subroutine clearBoard(tictac, size)
    implicit none

    ! calling variables
    integer, intent(in) :: size
    character(len = 1), intent(out), dimension(size, size) :: tictac

    ! fill the board with blanks, reshape it to a 3x3 board
    tictac = reshape((/' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '/), (/size, size/))
end subroutine clearBoard

!
! prints out the board.
!
subroutine showBoard(tictac, size)
    implicit none

    ! calling variables
    integer, intent(in) :: size
    character(len = 1), intent(in), dimension(size, size) :: tictac

    write (*, *) tictac(1, 1), '|', tictac(1, 2), '|', tictac(1, 3)
    write (*, *) '-+-+-'
    write (*, *) tictac(2, 1), '|', tictac(2, 2), '|', tictac(2, 3)
    write (*, *) '-+-+-'
    write (*, *) tictac(3, 1), '|', tictac(3, 2), '|', tictac(3, 3)
    write (*, *)
end subroutine showBoard

!
! takes in the move index, places piece in the
! board array at that index.
!
subroutine makeMove(tictac, move, piece, size)
    implicit none

    ! calling variables
    integer, intent(in) :: size, move
    character(len = 1), intent(out), dimension(size, size) :: tictac
    character(len = 1), intent(in) :: piece

    ! local variables
    integer :: row, col ! row/column indexers

    ! get row and column of desired move,
    ! place piece if move is valid
    if (move >= 1 .and. move <= 9) then
        call getXandY(move, row, col, size)
        tictac(row, col) = piece
    end if
end subroutine makeMove

!
! gets the x and y (row and column) coordinates
! from a 1-9 move index.
!
subroutine getXandY(move, row, col, size)
    implicit none

    !calling variables
    integer, intent(in) :: move, size
    integer, intent(out) :: row, col

    ! local variables
    integer :: x, y

    ! finds the (row, col) coordinate on the board
    ! that coresponds to the index stored in move
    do x = 1, size
        do y = 1, size
            if (((x - 1) * size + y) == move) then
                row = x
                col = y
            end if
        end do
    end do
end subroutine getXandY

!
! takes in the normal tictac board, fills in tictacScores
! with the score ('X' ==  1, 'O' == 4, ' ' == 0) of each space.
!
subroutine translateBoardToScores(tictac, tictacScores, size)
    implicit none

    ! calling variables
    integer, intent(in) :: size
    character(len = 1), dimension(size, size), intent(in) :: tictac
    integer, dimension(size, size), intent(out) :: tictacScores

    ! local variables
    integer :: row, col

    do row = 1, size
        do col = 1, size
            select case (tictac(row, col))
                case ('X')
                    tictacScores(row, col) = 1
                case ('O')
                    tictacScores(row, col) = 4
                case (' ')
                    tictacScores(row, col) = 0
                case default
                    tictacScores(row, col) = 0
            end select
        end do
    end do
end subroutine translateBoardToScores

!
! checks if the game is over, finds the winner.
!
subroutine chkover(tictac, over, winner)
    implicit none

    ! calling variables
    character(len = 1), intent(in), dimension(3, 3) :: tictac
    logical, intent(out) :: over
    character(len = 1), intent(out) :: winner

    ! local variables
    character(len = 1), parameter :: blank = ' ', draw = 'D'
    integer :: row, col

    ! assume game is over at start
    over = .true.

    ! check rows for a winner
    do row = 1, 3
        if (same(tictac(row, 1), tictac(row, 2), tictac(row, 3))) then
            winner = tictac(row, 1)
            return
        end if
    end do

    ! check columns for a winner
    do col = 1, 3
        if (same(tictac(1, col), tictac(2, col), tictac(3, col))) then
            winner = tictac(1, col)
            return
        end if
    end do

    ! check diagonals for winner
    if (same(tictac(1, 1), tictac(2, 2), tictac(3, 3)) .or. same(tictac(1, 3), tictac(2, 2), tictac(3, 1))) then
        winner = tictac(2, 2)
        return
    end if

    ! no winner, see if game is a draw
    ! check each row for empty space
    do row = 1, 3
        do col = 1, 3
            if (tictac(row, col) == blank) then
                over = .false.
                return
            end if
        end do
    end do

    ! no blank found, game is a draw
    winner = draw
    
    contains

    !
    ! check if three spaces are the same.
    !
    logical function same(space1, space2, space3)
        implicit none

        ! calling variables
        character(len = 1), intent(in) :: space1, space2, space3

        ! ensure that all spaces are the same, and not empty
        same = (space1 == space2 .and. space2 == space3) .and. all((/space1, space2, space3/) /= ' ')
    end function same
end subroutine chkover

!
! code taken from:
!   https://gcc.gnu.org/onlinedocs/gcc-4.3.3/gfortran/RANDOM_005fSEED.html#RANDOM_005fSEED
!
subroutine init_random_seed()
    implicit none

    ! local variables
    integer :: i, n, clock
    integer, dimension(:), allocatable :: seed
          
    call random_seed(size = n)
    allocate(seed(n))
          
    call system_clock(count = clock)
          
    seed = clock + 37 * (/ (i - 1, i = 1, n) /)
    call random_seed(put = seed)
          
    deallocate(seed)
end subroutine init_random_seed

*> conv_file.cob
*>
*> Read a file of roman numerals, and
*> convert each.
*>
*> Class: CIS*3190
*> Author: Ben Walker
*> Student #: 0883544
*> Date: Mar. 21, 2018

identification division.
program-id. convert_numeral_file.

environment division.
input-output section.
file-control.
    *> file must have each numeral on a new line
    select numerals assign identifier
    organization is line sequential.

data division.
file section.
*> specify records from the numeral file
fd numerals.
01 numeral_record.
    05 numeral pic x(30).

working-storage section.
77 lower_numeral pic x(30). *> lower-case version of numeral
77 identifier pic x(30). *> local filename
77 decimal_equivalent pic s9(12). *> decimal equivalent of numeral found in file
77 numeral_status pic 9. *> 1 if illegal numeral, 0 if valid

linkage section.
77 file_name pic x(30). *> user input filename
77 file_read_status pic 9. *> 0 if file not found/read, 1 otherwise

procedure division using file_name, file_read_status.
    move 0 to file_read_status *> assume file not found

    *> check if file exists, to avoid reading from non-existent file
    call "CBL_CHECK_FILE_EXIST" using file_name, numeral_record
    if return-code not = 0
        goback.

    move file_name to identifier *> can't use linkage variable as file identifier; use local identifier instead
    move 1 to file_read_status *> update read status now that file has been found

    *> read all numeral records, convert and show each
    open input numerals
        perform forever
            read numerals
                at end exit perform *> only stop at end of file
            end-read

            *> convert and show numeral just as we would for normal user input
            move function lower-case(numeral) to lower_numeral
            call "convert_numeral" using lower_numeral, decimal_equivalent, numeral_status
            call "show_numeral_and_decimal" using numeral, decimal_equivalent, numeral_status
        end-perform.
    close numerals.

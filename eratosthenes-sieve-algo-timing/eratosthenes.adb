-- eratosthenes.adb
--
-- Perform Sieve of Eratosthenes algorithm in Ada.
--
-- Class: CIS*3190
-- Author: Ben Walker
-- Student #: 0883544
-- Date: Apr. 6, 2018

with ada.text_io; use ada.text_io;
with ada.integer_text_io; use ada.integer_text_io;
with ada.numerics.elementary_functions; use ada.numerics.elementary_functions;

procedure eratosthenes is
    bad_limit : exception;
    type eratosthenes_sieve is array (positive range <>) of boolean;

    file_name : constant string := "eratosthenes_ada.txt";
    timing_mode : constant boolean := false; -- false: primes generated and output to file, true: primes generated
    upper_limit : integer; -- calculate primes <= upper_limit
    lower_bound : integer; -- the square root of upper_limit

    function get_upper_limit return integer is
        upper_limit : integer;
    begin
        put("Upper limit?: ");
        get(upper_limit);
        if upper_limit < 2 then
            raise bad_limit;
        end if;
        return upper_limit;
    end get_upper_limit;

    procedure compute_sieve(lower_bound: in integer; upper_limit: in integer; sieve: in out eratosthenes_sieve) is
        unprimeIndex : integer;
    begin
        for i in 2..lower_bound loop
            if sieve(i) then
                -- leave i as prime, mark all its multiples as not prime
                unprimeIndex := i**2;
                while unprimeIndex < upper_limit + 1 loop
                    sieve(unprimeIndex) := false;
                    unprimeIndex := unprimeIndex + i;
                end loop;
            end if;
        end loop;
    end compute_sieve;

    procedure print_primes_to_file(file_name: in string; sieve: in eratosthenes_sieve) is
        primes_file : file_type;
    begin
        create(primes_file, out_file, file_name);
        for i in sieve'range loop
            if sieve(i) then -- if the current array value is true, print i to file
                put(primes_file, i);
                new_line(primes_file);
            end if;
        end loop;
        close(primes_file);
    end print_primes_to_file;

begin
    upper_limit := get_upper_limit;
    lower_bound := integer(sqrt(float(upper_limit)));

    declare
        sieve : eratosthenes_sieve(2..upper_limit);
    begin
        sieve := (others => true); -- default all values to prime
        compute_sieve(lower_bound, upper_limit, sieve);
        if not timing_mode then
            print_primes_to_file(file_name, sieve);
        end if;
    end;

    exception
        when bad_limit =>
            put_line("The upper limit cannot be less than 2.");
end eratosthenes;

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

PACKAGE main_function IS
    -- convert BCD to Seven Segment Input
    FUNCTION bcd_to_7segment (
        usr_input : STD_LOGIC_VECTOR(3 DOWNTO 0)
    ) RETURN STD_LOGIC_VECTOR;
    -- convert integer to 4 bits logic vector
    FUNCTION integer_to_4bits (
        rand_num : INTEGER RANGE 1 TO 6
    ) RETURN STD_LOGIC_VECTOR;
    --  simple hashing algorithm for method 1
    FUNCTION simple_hash(
        hash_input : STD_LOGIC_VECTOR(23 DOWNTO 0)
    ) RETURN STD_LOGIC_VECTOR;
    --  simple hashing algorithm for method 2
    FUNCTION random_simple_hash(
        hash_input : STD_LOGIC_VECTOR(7 DOWNTO 0)
    ) RETURN STD_LOGIC_VECTOR;

END PACKAGE main_function;

PACKAGE BODY main_function IS
    -- convert BCD to Seven Segment Input
    FUNCTION bcd_to_7segment (
        usr_input : STD_LOGIC_VECTOR(3 DOWNTO 0)
    )
        RETURN STD_LOGIC_VECTOR IS
        VARIABLE segment : STD_LOGIC_VECTOR(6 DOWNTO 0);
    BEGIN
        CASE(usr_input) IS
            WHEN "0000" => segment := "1000000"; -- 0
            WHEN "0001" => segment := "1111001"; -- 1
            WHEN "0010" => segment := "0100100"; -- 2
            WHEN "0011" => segment := "0110000"; -- 3
            WHEN "0100" => segment := "0011001"; -- 4
            WHEN "0101" => segment := "0010010"; -- 5
            WHEN "0110" => segment := "0000010"; -- 6
            WHEN "0111" => segment := "1111000"; -- 7
            WHEN "1000" => segment := "0000000"; -- 8
            WHEN "1001" => segment := "0010000"; -- 9
            WHEN OTHERS => segment := "1111111";
        END CASE;
        RETURN segment;
    END;

    -- convert integer to 4 bits logic vector
    FUNCTION integer_to_4bits (
        rand_num : INTEGER RANGE 1 TO 6
    )
        RETURN STD_LOGIC_VECTOR IS
        VARIABLE bit_4 : STD_LOGIC_VECTOR(3 DOWNTO 0);
    BEGIN
        CASE(rand_num) IS
            WHEN 6 => bit_4 := "0110";
            WHEN 5 => bit_4 := "0101";
            WHEN 4 => bit_4 := "0100";
            WHEN 3 => bit_4 := "0011";
            WHEN 2 => bit_4 := "0010";
            WHEN 1 => bit_4 := "0001";
            WHEN OTHERS => bit_4 := "1111";
        END CASE;
        RETURN bit_4;
    END;

    --  simple hashing algorithm for method 1
    FUNCTION simple_hash(
        hash_input : STD_LOGIC_VECTOR(23 DOWNTO 0)
    )
        RETURN STD_LOGIC_VECTOR IS
        VARIABLE hash_value : STD_LOGIC_VECTOR(31 DOWNTO 0);
    BEGIN

        hash_value(31 DOWNTO 28) := hash_input(3 DOWNTO 0) XOR "1010";
        hash_value(27 DOWNTO 24) := hash_input(7 DOWNTO 4) XOR hash_input(3 DOWNTO 0);
        hash_value(23 DOWNTO 20) := hash_input(11 DOWNTO 8) XOR "0101";
        hash_value(19 DOWNTO 16) := hash_input(15 DOWNTO 12) XOR hash_input(11 DOWNTO 8);
        hash_value(15 DOWNTO 12) := hash_input(19 DOWNTO 16) XOR "0110";
        hash_value(11 DOWNTO 8) := hash_input(23 DOWNTO 20) XOR hash_input(19 DOWNTO 16);
        hash_value(7 DOWNTO 4) := hash_input(7 DOWNTO 4) XOR "1001";
        hash_value(3 DOWNTO 0) := hash_input(19 DOWNTO 16) XOR hash_input(3 DOWNTO 0);
        RETURN hash_value;
    END FUNCTION;

    --  simple hashing algorithm for method 2
    FUNCTION random_simple_hash(
        hash_input : STD_LOGIC_VECTOR(7 DOWNTO 0)
    ) RETURN STD_LOGIC_VECTOR IS
        VARIABLE hash_value : STD_LOGIC_VECTOR(11 DOWNTO 0);
    BEGIN
        hash_value(11 DOWNTO 8) := hash_input(3 DOWNTO 0) XOR "0110";
        hash_value(7 DOWNTO 4) := hash_input(7 DOWNTO 4) XOR hash_input(3 DOWNTO 0);
        hash_value(3 DOWNTO 0) := hash_input(7 DOWNTO 4) XOR "1001";
        RETURN hash_value;
    END FUNCTION;
END PACKAGE BODY main_function;
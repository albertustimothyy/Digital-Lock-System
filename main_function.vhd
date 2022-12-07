LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

PACKAGE main_function IS
    FUNCTION bcd_to_7segment (
        usr_input : STD_LOGIC_VECTOR(3 DOWNTO 0)
    ) RETURN STD_LOGIC_VECTOR;

    FUNCTION bits_3_to_digits (
        count_disp : STD_LOGIC_VECTOR(2 DOWNTO 0)
    ) RETURN STD_LOGIC_VECTOR;

    FUNCTION integer_to_7segment (
        rand_num : INTEGER RANGE 1 TO 5
    ) RETURN STD_LOGIC_VECTOR;

END PACKAGE main_function;

PACKAGE BODY main_function IS

    FUNCTION bcd_to_7segment (
        usr_input : STD_LOGIC_VECTOR(3 DOWNTO 0))
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
            WHEN OTHERS => segment := "1000000"; -- 0
        END CASE;
        RETURN segment;
    END;
    FUNCTION bits_3_to_digits (
        count_disp : STD_LOGIC_VECTOR(2 DOWNTO 0))
        RETURN STD_LOGIC_VECTOR IS
        VARIABLE dig : STD_LOGIC_VECTOR(7 DOWNTO 0);
    BEGIN
        CASE(count_disp) IS
            WHEN "000" => dig := "01111111";
            WHEN "001" => dig := "10111111";
            WHEN "010" => dig := "11011111";
            WHEN "011" => dig := "11101111";
            WHEN "100" => dig := "11110111";
            WHEN "101" => dig := "11111011";
            WHEN "110" => dig := "11111101";
            WHEN "111" => dig := "11111110";
            WHEN OTHERS => dig := "11111111";
        END CASE;
        RETURN dig;
    END;
    FUNCTION integer_to_7segment (
        rand_num : INTEGER RANGE 1 TO 5)
        RETURN STD_LOGIC_VECTOR IS
        VARIABLE segment : STD_LOGIC_VECTOR(6 DOWNTO 0);
    BEGIN
        CASE(rand_num) IS
            WHEN 5 => segment := "0010010";
            WHEN 4 => segment := "0011001";
            WHEN 3 => segment := "0110000";
            WHEN 2 => segment := "0100100";
            WHEN 1 => segment := "1111001";
            WHEN OTHERS => segment := "1111111";
        END CASE;
        RETURN segment;
    END;

END PACKAGE BODY main_function;
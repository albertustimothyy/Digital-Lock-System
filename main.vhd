LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

USE work.main_function.ALL;

-- Entity
ENTITY main IS
    PORT (
        RESET_BTN, NEXT_BTN, RESET2_BTN, CLOCK : IN STD_LOGIC;
        SEVEN_SEGMENT : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
        DIGITS : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        SWITCH : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        LED : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END main;

-- Architecture
ARCHITECTURE rtl OF main IS
    -- Declaration Main State
    TYPE states IS (INIT, BUSY1, BUSY2, BUSY3, BUSY4, BUSY5, BUSY6, RESET, INIT_RANDOM, BUSY1_RANDOM, BUSY2_RANDOM, RESET_RANDOM);
    SIGNAL state : states;

    -- Declaration for Clock 
    TYPE debounce_states IS (DEBOUNCE_INIT, SHIFT_STATE);
    SIGNAL clk_slow : STD_LOGIC;
    SIGNAL debounce_state : debounce_states;
    SIGNAL debounce_signal : STD_LOGIC;
    SIGNAL count_slow : INTEGER := 0;
    SIGNAL count_shift : INTEGER := 0;
    ----- Flicker
    SIGNAL count_flk : INTEGER := 0;
    SIGNAL switch_flk : STD_LOGIC := '0';
    -----  Display Counter
    SIGNAL display_counter : STD_LOGIC_VECTOR(15 DOWNTO 0);
    ----- User Inputs Password
    SIGNAL input_pass : STD_LOGIC_VECTOR(23 DOWNTO 0);
    ----- Correct Password
    SIGNAL password : STD_LOGIC_VECTOR(23 DOWNTO 0) := "000101110000100001000101"; -- 1 7 0 8 4 5
    ----- Declaration Array of random input
    TYPE arr IS ARRAY (0 TO 1) OF INTEGER RANGE 1 TO 6;
    TYPE rand IS ARRAY (29 DOWNTO 0) OF arr;
    CONSTANT rand_array : rand := (
    (1, 2), (1, 3), (1, 4), (1, 5), (1, 6),
        (2, 1), (2, 3), (2, 4), (2, 5), (2, 6),
        (3, 1), (3, 2), (3, 4), (3, 5), (3, 6),
        (4, 1), (4, 2), (4, 3), (4, 5), (4, 6),
        (5, 1), (5, 2), (5, 3), (5, 4), (5, 6),
        (6, 1), (6, 2), (6, 3), (6, 4), (6, 5)
    );
    -- Declaration Signal for input random
    SIGNAL rand_generator : STD_LOGIC := '0';
    SIGNAL rand_i : INTEGER RANGE 0 TO 29 := 0;
    SIGNAL rand_pass_1, rand_pass_2 : INTEGER RANGE 1 TO 6;
    SIGNAL answer, random_input : STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN

    -- Clock process
    PROCESS (CLOCK) BEGIN
        IF rising_edge(CLOCK) THEN
            IF count_slow = 1500000 THEN
                clk_slow <= '1';
                count_slow <= 0;
            ELSE
                clk_slow <= '0';
                count_slow <= count_slow + 1;
            END IF;
        END IF;
    END PROCESS;

    -- Main Process
    PROCESS (clk_slow, RESET_BTN, RESET2_BTN)
    BEGIN
        IF rising_edge(clk_slow) THEN
            CASE(debounce_state) IS
                WHEN DEBOUNCE_INIT =>
                IF (NEXT_BTN = '0') THEN
                    debounce_state <= DEBOUNCE_INIT;
                ELSE
                    debounce_state <= SHIFT_STATE;
                END IF;
                debounce_signal <= '0';
                WHEN SHIFT_STATE =>
                IF (count_shift = 8) THEN
                    count_shift <= 0;
                    IF (NEXT_BTN = '1') THEN
                        debounce_signal <= '1';
                    END IF;
                    debounce_state <= DEBOUNCE_INIT;
                ELSE
                    count_shift <= count_shift + 1;
                END IF;
            END CASE;
            -- RESET_BTN to reset to INIT state (Method 1)
            IF RESET_BTN = '1' THEN
                input_pass(23 DOWNTO 0) <= (OTHERS => '0');
                state <= INIT;
                -- RESET2_BTN to reset all state and signal (Method 2)
            ELSIF RESET2_BTN = '1' THEN
                answer <= (OTHERS => '0');
                random_input <= (OTHERS => '0');
                rand_generator <= '1';
                rand_pass_1 <= rand_array(rand_i)(0);
                rand_pass_2 <= rand_array(rand_i)(1);
                state <= BUSY1_RANDOM;
                -- Receiving Input 
            ELSIF (debounce_signal = '1') THEN
                CASE(state) IS
                    -- Method 1
                    WHEN INIT =>
                    input_pass(23 DOWNTO 20) <= SWITCH(3 DOWNTO 0);
                    state <= BUSY1;
                    WHEN BUSY1 =>
                    input_pass(19 DOWNTO 16) <= SWITCH(3 DOWNTO 0);
                    state <= BUSY2;
                    WHEN BUSY2 =>
                    input_pass(15 DOWNTO 12) <= SWITCH(3 DOWNTO 0);
                    state <= BUSY3;
                    WHEN BUSY3 =>
                    input_pass(11 DOWNTO 8) <= SWITCH(3 DOWNTO 0);
                    state <= BUSY4;
                    WHEN BUSY4 =>
                    input_pass(7 DOWNTO 4) <= SWITCH(3 DOWNTO 0);
                    state <= BUSY5;
                    WHEN BUSY5 =>
                    input_pass(3 DOWNTO 0) <= SWITCH(3 DOWNTO 0);
                    state <= BUSY6;
                    WHEN BUSY6 => state <= BUSY6;
                    WHEN RESET => state <= RESET;
                    -- Method 2
                    WHEN INIT_RANDOM => state <= INIT_RANDOM;
                    WHEN BUSY1_RANDOM =>

                    CASE(rand_pass_1) IS
                        WHEN 1 => answer(7 DOWNTO 4) <= "0001";
                        WHEN 2 => answer(7 DOWNTO 4) <= "0111";
                        WHEN 3 => answer(7 DOWNTO 4) <= "0000";
                        WHEN 4 => answer(7 DOWNTO 4) <= "1000";
                        WHEN 5 => answer(7 DOWNTO 4) <= "0100";
                        WHEN 6 => answer(7 DOWNTO 4) <= "0101";
                        WHEN OTHERS => answer(7 DOWNTO 4) <= "0000";
                    END CASE;
                    -- Receive Input (Method 2)
                    random_input(7 DOWNTO 4) <= SWITCH(3 DOWNTO 0);
                    CASE(rand_pass_2) IS
                        WHEN 1 => answer(3 DOWNTO 0) <= "0001";
                        WHEN 2 => answer(3 DOWNTO 0) <= "0111";
                        WHEN 3 => answer(3 DOWNTO 0) <= "0000";
                        WHEN 4 => answer(3 DOWNTO 0) <= "1000";
                        WHEN 5 => answer(3 DOWNTO 0) <= "0100";
                        WHEN 6 => answer(3 DOWNTO 0) <= "0101";
                        WHEN OTHERS => answer(3 DOWNTO 0) <= "0000";
                    END CASE;
                    state <= BUSY2_RANDOM;
                    WHEN BUSY2_RANDOM =>
                    random_input(3 DOWNTO 0) <= SWITCH(3 DOWNTO 0);
                    state <= RESET_RANDOM;
                    WHEN RESET_RANDOM =>
                    state <= RESET_RANDOM;
                END CASE;
            END IF;
            IF state = RESET_RANDOM THEN
                rand_generator <= '0';
            END IF;
            -- Generate Random Number
            IF rand_generator = '0' THEN
                IF rand_i = 29 THEN
                    rand_i <= 1;
                ELSE
                    rand_i <= rand_i + 1;
                END IF;
            END IF;
            -- Flickering Digits
            IF (count_flk = 50) THEN
                count_flk <= 0;
                switch_flk <= NOT switch_flk;
            ELSE
                count_flk <= count_flk + 1;
            END IF;
            IF state = BUSY6 THEN
                IF switch_flk = '1' THEN
                    state <= RESET;
                END IF;
            ELSIF state = RESET THEN
                IF switch_flk = '0' THEN
                    state <= BUSY6;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    -- Clock for Displaying Output
    PROCESS (CLOCK)
    BEGIN
        IF rising_edge (CLOCK) THEN
            display_counter <= display_counter + 1;
            IF display_counter = "1110001101010000" THEN
                display_counter <= (OTHERS => '0');
            END IF;
        END IF;
    END PROCESS;

    
    -- Output Process
    Output : PROCESS (state)
        VARIABLE seg : STD_LOGIC_VECTOR(6 DOWNTO 0);
        VARIABLE dig : STD_LOGIC_VECTOR(7 DOWNTO 0);
    BEGIN

        CASE (state) IS
                -- Method 2
            WHEN INIT_RANDOM =>
                dig := "11111111";
                seg := "1111111";
                LED <= (OTHERS => '0');
            WHEN BUSY1_RANDOM =>
                dig := "01111111";
                seg := bcd_to_7segment(integer_to_4bits(rand_pass_1));
                LED <= (OTHERS => '0');
            WHEN BUSY2_RANDOM =>
                dig := "10111111";
                seg := bcd_to_7segment(integer_to_4bits(rand_pass_2));
            WHEN RESET_RANDOM =>
                -- Cheking Input 
                IF random_simple_hash(answer) = random_simple_hash(random_input) THEN
                    LED <= "1111111111111111";
                    CASE(display_counter(15 DOWNTO 14)) IS
                    WHEN "00" => dig := "11111101";
                    WHEN "01" => dig := "11111110";
                    WHEN OTHERS => dig := "11111111";
                    END CASE;
                    CASE(display_counter(15 DOWNTO 14)) IS
                    WHEN "00" => seg := "1000000";
                    WHEN "01" => seg := "0001001";
                    WHEN OTHERS => seg := "1111111";
                    END CASE;
                ELSE
                    CASE(display_counter(15 DOWNTO 14)) IS
                    WHEN "00" => dig := "11111110";
                    WHEN "01" => dig := "11111101";
                    WHEN "10" => dig := "11111011";
                    WHEN OTHERS => dig := "11111111";
                    END CASE;
                    CASE(display_counter(15 DOWNTO 14)) IS
                    WHEN "00" => seg := "0010010";
                    WHEN "01" => seg := "1000111";
                    WHEN "10" => seg := "0001110";
                    WHEN OTHERS => seg := "1111111";
                    END CASE;
                END IF;
                --- Part 2 Display ---
            WHEN INIT =>
                dig := "11111111";
                seg := "1111111";
                LED <= (OTHERS => '0');
            WHEN BUSY1 =>
                dig := "01111111";
                seg := bcd_to_7segment(input_pass(23 DOWNTO 20));
            WHEN BUSY2 =>
                CASE(display_counter(15 DOWNTO 14)) IS
                WHEN "00" => dig := "01111111";
                WHEN "01" => dig := "10111111";
                WHEN OTHERS => dig := "11111111";
                END CASE;
                CASE(display_counter(15 DOWNTO 14)) IS
                WHEN "00" => seg := bcd_to_7segment(input_pass(23 DOWNTO 20));
                WHEN "01" => seg := bcd_to_7segment(input_pass(19 DOWNTO 16));
                WHEN OTHERS => seg := "1111111";
                END CASE;
            WHEN BUSY3 =>
                CASE(display_counter(15 DOWNTO 14)) IS
                WHEN "00" => dig := "01111111";
                WHEN "01" => dig := "10111111";
                WHEN "10" => dig := "11011111";
                WHEN OTHERS => dig := "11111111";
                END CASE;
                CASE(display_counter(15 DOWNTO 14)) IS
                WHEN "00" => seg := bcd_to_7segment(input_pass(23 DOWNTO 20));
                WHEN "01" => seg := bcd_to_7segment(input_pass(19 DOWNTO 16));
                WHEN "10" => seg := bcd_to_7segment(input_pass(15 DOWNTO 12));
                WHEN OTHERS => seg := "1111111";
                END CASE;
            WHEN BUSY4 =>
                CASE(display_counter(15 DOWNTO 14)) IS
                WHEN "00" => dig := "01111111";
                WHEN "01" => dig := "10111111";
                WHEN "10" => dig := "11011111";
                WHEN "11" => dig := "11101111";
                WHEN OTHERS => dig := "11111111";
                END CASE;
                CASE(display_counter(15 DOWNTO 14)) IS
                WHEN "00" => seg := bcd_to_7segment(input_pass(23 DOWNTO 20));
                WHEN "01" => seg := bcd_to_7segment(input_pass(19 DOWNTO 16));
                WHEN "10" => seg := bcd_to_7segment(input_pass(15 DOWNTO 12));
                WHEN "11" => seg := bcd_to_7segment(input_pass(11 DOWNTO 8));
                WHEN OTHERS => seg := "1111111";
                END CASE;
            WHEN BUSY5 =>
                dig := bits_3_to_digits(display_counter(15 DOWNTO 13));
                CASE(display_counter(15 DOWNTO 13)) IS
                WHEN "000" => seg := bcd_to_7segment(input_pass(23 DOWNTO 20));
                WHEN "001" => seg := bcd_to_7segment(input_pass(19 DOWNTO 16));
                WHEN "010" => seg := bcd_to_7segment(input_pass(15 DOWNTO 12));
                WHEN "011" => seg := bcd_to_7segment(input_pass(11 DOWNTO 8));
                WHEN "100" => seg := bcd_to_7segment(input_pass(7 DOWNTO 4));
                WHEN OTHERS => seg := "1111111";
                END CASE;
            WHEN BUSY6 =>
                dig := bits_3_to_digits(display_counter(15 DOWNTO 13));
                CASE(display_counter(15 DOWNTO 13)) IS
                WHEN "000" => seg := bcd_to_7segment(input_pass(23 DOWNTO 20));
                WHEN "001" => seg := bcd_to_7segment(input_pass(19 DOWNTO 16));
                WHEN "010" => seg := bcd_to_7segment(input_pass(15 DOWNTO 12));
                WHEN "011" => seg := bcd_to_7segment(input_pass(11 DOWNTO 8));
                WHEN "100" => seg := bcd_to_7segment(input_pass(7 DOWNTO 4));
                WHEN "101" => seg := bcd_to_7segment(input_pass(3 DOWNTO 0));
                WHEN "110" => seg := "1111111";
                WHEN "111" => seg := "1111111";
                WHEN OTHERS => seg := "1111111";
                END CASE;
            WHEN RESET =>

                IF (state = RESET) AND (simple_hash(input_pass) = simple_hash(password)) THEN
                    LED <= "1111111111111111";
                    CASE(display_counter(15 DOWNTO 14)) IS
                    WHEN "00" => dig := "11111101";
                    WHEN "01" => dig := "11111110";
                    WHEN OTHERS => dig := "11111111";
                    END CASE;
                    CASE(display_counter(15 DOWNTO 14)) IS
                    WHEN "00" => seg := "1000000";
                    WHEN "01" => seg := "0001001";
                    WHEN OTHERS => seg := "1111111";
                    END CASE;
                ELSE
                    CASE(display_counter(15 DOWNTO 14)) IS
                    WHEN "00" => dig := "11111110";
                    WHEN "01" => dig := "11111101";
                    WHEN "10" => dig := "11111011";
                    WHEN OTHERS => dig := "11111111";
                    END CASE;
                    CASE(display_counter(15 DOWNTO 14)) IS
                    WHEN "00" => seg := "0010010";
                    WHEN "01" => seg := "1000111";
                    WHEN "10" => seg := "0001110";
                    WHEN OTHERS => seg := "1111111";
                    END CASE;
                END IF;
        END CASE;

        -- Output Display
        SEVEN_SEGMENT <= seg;
        DIGITS <= dig;
    END PROCESS Output;
END rtl;
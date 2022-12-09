-- Test Bench
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY main_tb IS
END main_tb;

ARCHITECTURE behavior OF main_tb IS
    -- Component Declaration
    COMPONENT main
        PORT (
            RESET_BTN, NEXT_BTN, RESET2_BTN, CLOCK : IN STD_LOGIC;
            SEVEN_SEGMENT : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            DIGITS : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            SWITCH : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            LED : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;

    -- Inputs
    SIGNAL RESET_BTN, NEXT_BTN, RESET2_BTN : STD_LOGIC := '0';
    SIGNAL SWITCH : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000";
    -- Outputs
    SIGNAL SEVEN_SEGMENT : STD_LOGIC_VECTOR(6 DOWNTO 0);
    SIGNAL DIGITS : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL LED : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL CLOCK : STD_LOGIC;
    CONSTANT clk_period : TIME := 100 ps;

BEGIN
    -- Instantiate the Unit Under Test (UUT)
    uut : main PORT MAP(
        RESET_BTN => RESET_BTN,
        NEXT_BTN => NEXT_BTN,
        RESET2_BTN => RESET2_BTN,
        CLOCK => CLOCK,
        SEVEN_SEGMENT => SEVEN_SEGMENT,
        DIGITS => DIGITS,
        SWITCH => SWITCH,
        LED => LED
    );

    -- Clock process
    CLOCK_PROC : PROCESS
    BEGIN
        CLOCK <= '0';
        WAIT FOR clk_period/2;
        CLOCK <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Stimulus process
    STIM_PROC : PROCESS
    BEGIN
        WAIT FOR clk_period;
        -------------------------------
        -- Method 1
        -------------------------------

        -------------------------------
        -- Correct Password
        -------------------------------
        RESET_BTN <= '1';
        WAIT FOR clk_period;
        RESET_BTN <= '0';
        WAIT FOR clk_period;

        SWITCH <= "0001";
        NEXT_BTN <= '1';
        ASSERT (LED = "0000000000000000" AND DIGITS = "01111111" AND SEVEN_SEGMENT = "1111001")
        REPORT "Failed at input 1 (Correct)" SEVERITY warning;
        WAIT FOR clk_period * 20.5;

        SWITCH <= "0111";
        NEXT_BTN <= '1';
        ASSERT (LED = "0000000000000000" AND DIGITS = "10111111" AND SEVEN_SEGMENT = "0100100")
        REPORT "Failed at input 2 (Correct)" SEVERITY warning;
        WAIT FOR clk_period * 10;

        SWITCH <= "0000";
        NEXT_BTN <= '1';
        ASSERT (LED = "0000000000000000" AND DIGITS = "11011111" AND SEVEN_SEGMENT = "0110000")
        REPORT "Failed at input 3 (Correct)" SEVERITY warning;
        WAIT FOR clk_period * 10;

        SWITCH <= "1000";
        NEXT_BTN <= '1';
        ASSERT (LED = "0000000000000000" AND DIGITS = "11101111" AND SEVEN_SEGMENT = "0011001")
        REPORT "Failed at input 4 (Correct)" SEVERITY warning;
        WAIT FOR clk_period * 10;

        SWITCH <= "0100";
        NEXT_BTN <= '1';
        ASSERT (LED = "0000000000000000" AND DIGITS = "11110111" AND SEVEN_SEGMENT = "0010010")
        REPORT "Failed at input 5 (Correct)" SEVERITY warning;
        WAIT FOR clk_period * 10;

        SWITCH <= "0101";
        NEXT_BTN <= '1';
        ASSERT (LED = "0000000000000000" AND DIGITS = "11111011" AND SEVEN_SEGMENT = "0000010")
        REPORT "Failed at input 6 (Correct)" SEVERITY warning;
        WAIT FOR clk_period;

        ASSERT (LED = "0000000000000000" AND DIGITS = "11111110" AND SEVEN_SEGMENT = "1000000")
        REPORT "Wrong Password" SEVERITY warning;
        WAIT FOR clk_period * 4;

        -------------------------------
        -- Wrong Password
        -------------------------------
        RESET_BTN <= '1';
        WAIT FOR clk_period;
        RESET_BTN <= '0';
        WAIT FOR clk_period;

        SWITCH <= "0000";
        NEXT_BTN <= '1';
        ASSERT (LED = "0000000000000000" AND DIGITS = "01111111" AND SEVEN_SEGMENT = "1111001")
        REPORT "Failed at input 1 (Wrong)" SEVERITY warning;
        WAIT FOR clk_period * 13;

        SWITCH <= "0101";
        NEXT_BTN <= '1';
        ASSERT (LED = "0000000000000000" AND DIGITS = "10111111" AND SEVEN_SEGMENT = "0100100")
        REPORT "Failed at input 2 (Wrong)" SEVERITY warning;
        WAIT FOR clk_period * 10;

        SWITCH <= "0101";
        NEXT_BTN <= '1';
        ASSERT (LED = "0000000000000000" AND DIGITS = "11011111" AND SEVEN_SEGMENT = "0110000")
        REPORT "Failed at input 3 (Wrong)" SEVERITY warning;
        WAIT FOR clk_period * 10;

        SWITCH <= "0011";
        NEXT_BTN <= '1';
        ASSERT (LED = "0000000000000000" AND DIGITS = "11101111" AND SEVEN_SEGMENT = "0011001")
        REPORT "Failed at input 4 (Wrong)" SEVERITY warning;
        WAIT FOR clk_period * 10;
        SWITCH <= "0100";
        NEXT_BTN <= '1';
        ASSERT (LED = "0000000000000000" AND DIGITS = "11110111" AND SEVEN_SEGMENT = "0010010")
        REPORT "Failed at input 5 (Wrong)" SEVERITY warning;
        WAIT FOR clk_period * 10;

        SWITCH <= "0101";
        NEXT_BTN <= '1';
        ASSERT (LED = "0000000000000000" AND DIGITS = "11111011" AND SEVEN_SEGMENT = "0000010")
        REPORT "Failed at input 6 (Wrong)" SEVERITY warning;
        WAIT FOR clk_period;

        ASSERT (LED = "0000000000000000" AND DIGITS = "11111110" AND SEVEN_SEGMENT = "1000000")
        REPORT "Wrong Password" SEVERITY warning;
        WAIT FOR clk_period * 4;

        -------------------------------
        -- Method 2 (Wrong)
        -------------------------------
        RESET2_BTN <= '1';
        WAIT FOR clk_period;
        RESET2_BTN <= '0';
        WAIT FOR clk_period;

        SWITCH <= "0001";
        NEXT_BTN <= '1';
        ASSERT (LED = "0000000000000000" AND DIGITS = "01111111")
        REPORT "Failed at input 1" SEVERITY warning;
        WAIT FOR clk_period * 12;

        SWITCH <= "0111";
        NEXT_BTN <= '1';
        ASSERT (LED = "0000000000000000" AND DIGITS = "10111111")
        REPORT "Failed at input 2" SEVERITY warning;

        ASSERT (LED = "0000000000000000" AND DIGITS = "11111110" AND SEVEN_SEGMENT = "1000000")
        REPORT "Wrong Password" SEVERITY warning;
        WAIT FOR clk_period * 4;

        WAIT;
    END PROCESS;
END;
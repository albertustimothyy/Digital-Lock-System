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
    CONSTANT clk_period : TIME := 5 ns;

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

        -- Initialize inputs here

        WAIT FOR clk_period;

        -- Add stimulus here

        WAIT;
    END PROCESS;

    RESET_PROC : PROCESS
    BEGIN
        -- Method 1
        RESET_BTN <= '1';
        WAIT FOR clk_period;
        RESET_BTN <= '0';
        WAIT FOR clk_period;

        SWITCH <= "0101";
        NEXT_BTN <= '1';
        WAIT FOR clk_period;
        SWITCH <= "0110";
        NEXT_BTN <= '1';
        WAIT FOR clk_period;
        SWITCH <= "1100";
        NEXT_BTN <= '1';
        WAIT FOR clk_period;
        SWITCH <= "0011";
        NEXT_BTN <= '1';
        WAIT FOR clk_period;
        SWITCH <= "0111";
        NEXT_BTN <= '1';
        WAIT FOR clk_period;
        SWITCH <= "1001";
        NEXT_BTN <= '1';
        WAIT FOR clk_period;

        ASSERT (LED = "0000000000000000" AND DIGITS = "11111110" AND SEVEN_SEGMENT = "0010010")
        REPORT "Wrong Password";
        WAIT FOR clk_period;
        -- Method 2
        WAIT;
    END PROCESS;
END;
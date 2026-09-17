-- ALU_32bit_tb.vhd
-- Self-checking testbench for 32-bit ALU (asserts expected results)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_32bit_tb is
end ALU_32bit_tb;

architecture Behavioral of ALU_32bit_tb is
    
    component ALU_32bit
        Port (
            A           : in  STD_LOGIC_VECTOR(31 downto 0);
            B           : in  STD_LOGIC_VECTOR(31 downto 0);
            ALU_Control : in  STD_LOGIC_VECTOR(2 downto 0);
            ALU_Result  : out STD_LOGIC_VECTOR(31 downto 0);
            Zero        : out STD_LOGIC
        );
    end component;
    
    -- Testbench signals
    signal A           : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal B           : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ALU_Control : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal ALU_Result  : STD_LOGIC_VECTOR(31 downto 0);
    signal Zero        : STD_LOGIC;
    
begin
    UUT: ALU_32bit port map (
        A => A,
        B => B,
        ALU_Control => ALU_Control,
        ALU_Result => ALU_Result,
        Zero => Zero
    );
    
    -- Test process
    process
    begin
        -- Test 1: Addition (2500 + 25000 = 27500 = 0x6B8C)
        A <= x"000009C4";
        B <= x"000061A8";
        ALU_Control <= "000";
        wait for 20 ns;
        assert ALU_Result = x"00006B8C"
            report "ALU ADD failed: expected 0x00006B8C, got 0x" &
                   integer'image(to_integer(unsigned(ALU_Result)))
            severity failure;
        assert Zero = '0'
            report "ALU ADD failed: Zero flag should be '0'"
            severity failure;
        
        -- Test 2: Subtraction (540250 - 37800 = 502450 = 0x7AAB2)
        A <= x"00083E5A";
        B <= x"000093A8";
        ALU_Control <= "001";
        wait for 20 ns;
        assert ALU_Result = x"0007AAB2"
            report "ALU SUB failed: expected 0x0007AAB2, got 0x" &
                   integer'image(to_integer(unsigned(ALU_Result)))
            severity failure;
        
        -- Test 3: AND (0x0000D2C5 AND 0x00007530 = 0x00005020)
        A <= x"0000D2C5";
        B <= x"00007530";
        ALU_Control <= "010";
        wait for 20 ns;
        assert ALU_Result = x"00005020"
            report "ALU AND failed: expected 0x00005020, got 0x" &
                   integer'image(to_integer(unsigned(ALU_Result)))
            severity failure;
        
        -- Test 4: OR (0x000B63E1 OR 0x000CEA81 = 0x000FEBE1)
        A <= x"000B63E1";
        B <= x"000CEA81";
        ALU_Control <= "011";
        wait for 20 ns;
        assert ALU_Result = x"000FEBE1"
            report "ALU OR failed: expected 0x000FEBE1, got 0x" &
                   integer'image(to_integer(unsigned(ALU_Result)))
            severity failure;
        
        -- Test 5: SLT (58847537 < 72464383 = 1)
        A <= x"0381FEB1";
        B <= x"0451B0BF";
        ALU_Control <= "100";
        wait for 20 ns;
        assert ALU_Result = x"00000001"
            report "ALU SLT failed: expected 0x00000001, got 0x" &
                   integer'image(to_integer(unsigned(ALU_Result)))
            severity failure;
        assert Zero = '0'
            report "ALU SLT failed: Zero flag should be '0'"
            severity failure;
        
        -- Test 6: Zero flag (x - x = 0)
        A <= x"00000007";
        B <= x"00000007";
        ALU_Control <= "001";
        wait for 20 ns;
        assert ALU_Result = x"00000000"
            report "ALU SUB failed: expected 0x00000000, got 0x" &
                   integer'image(to_integer(unsigned(ALU_Result)))
            severity failure;
        assert Zero = '1'
            report "ALU SUB failed: Zero flag should be '1'"
            severity failure;
        
        -- Stop simulation
        report "ALU Testbench completed successfully - all assertions passed!" severity note;
        wait;
    end process;
    
end Behavioral;

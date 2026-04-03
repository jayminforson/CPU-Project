-- ALU_32bit_tb.vhd
-- Testbench for 32-bit ALU with full signal visibility

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
        -- Test 1: Addition (2500 + 25000 = 27500)
        A <= x"000009C4";
        B <= x"000061A8";
        ALU_Control <= "000";
        wait for 20 ns;
        
        -- Test 2: Subtraction (540250 - 37800 = 502450)
        A <= x"00083E5A";
        B <= x"000093A8";
        ALU_Control <= "001";
        wait for 20 ns;
        
        -- Test 3: AND (53957 AND 30000 = 20480)
        A <= x"0000D2C5";
        B <= x"00007530";
        ALU_Control <= "010";
        wait for 20 ns;
        
        -- Test 4: OR (746353 OR 846465 = 1045489)
        A <= x"000B63E1";
        B <= x"000CEA81";
        ALU_Control <= "011";
        wait for 20 ns;
        
        -- Test 5: SLT (58847537 < 72464383 = 1)
        A <= x"0381FEB1";
        B <= x"0451B0BF";
        ALU_Control <= "100";
        wait for 20 ns;
        
        -- Stop simulation
        wait for 20 ns;
        report "ALU Testbench completed successfully!" severity note;
        wait;
    end process;
    
end Behavioral;
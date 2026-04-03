-- Instruction_Memory_tb.vhd
-- Testbench for Instruction Memory with full signal visibility

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Memory_tb is
end Instruction_Memory_tb;

architecture Behavioral of Instruction_Memory_tb is
    component Instruction_Memory
        Port (
            pc          : in  STD_LOGIC_VECTOR(31 downto 0);
            instruction : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    signal pc          : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal instruction : STD_LOGIC_VECTOR(31 downto 0);
    
begin
    UUT: Instruction_Memory port map (
        pc => pc,
        instruction => instruction
    );
    
    process
    begin
        -- Read instruction at Address 0
        pc <= x"00000000";
        wait for 10 ns;
        
        -- Read instruction at Address 2 (pc = 8)
        pc <= x"00000008";
        wait for 10 ns;
        
        -- Read instruction at Address 4 (pc = 16)
        pc <= x"00000010";
        wait for 10 ns;
        
        -- Read instruction at Address 6 (pc = 24)
        pc <= x"00000018";
        wait for 10 ns;
        
        -- Read invalid address
        pc <= x"00000100";
        wait for 10 ns;
        
        -- Stop simulation
        wait for 10 ns;
        report "Instruction Memory Testbench completed!" severity note;
        wait;
    end process;
    
end Behavioral;
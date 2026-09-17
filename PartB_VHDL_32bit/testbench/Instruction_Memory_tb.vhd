-- Instruction_Memory_tb.vhd
-- Self-checking testbench for Instruction Memory (asserts expected results)

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
        -- Read instruction at Address 0 (byte address 0x00): add $t0, $t1, $t2
        pc <= x"00000000";
        wait for 10 ns;
        assert instruction = x"012A4020"
            report "Instruction Memory failed: PC=0x00 expected 0x012A4020, got 0x" &
                   integer'image(to_integer(unsigned(instruction)))
            severity failure;
        
        -- Read instruction at Address 2 (byte address 0x08): sub $t2, $t2, $t3
        pc <= x"00000008";
        wait for 10 ns;
        assert instruction = x"014B5022"
            report "Instruction Memory failed: PC=0x08 expected 0x014B5022, got 0x" &
                   integer'image(to_integer(unsigned(instruction)))
            severity failure;
        
        -- Read instruction at Address 4 (byte address 0x10): and $t1, $t2, $t0
        pc <= x"00000010";
        wait for 10 ns;
        assert instruction = x"01484824"
            report "Instruction Memory failed: PC=0x10 expected 0x01484824, got 0x" &
                   integer'image(to_integer(unsigned(instruction)))
            severity failure;
        
        -- Read instruction at Address 6 (byte address 0x18): or $t2, $t3, $t1
        pc <= x"00000018";
        wait for 10 ns;
        assert instruction = x"01695025"
            report "Instruction Memory failed: PC=0x18 expected 0x01695025, got 0x" &
                   integer'image(to_integer(unsigned(instruction)))
            severity failure;
        
        -- Out-of-range PCs must return zero, not wrap around
        -- PC=0x40 -> word index 16 (first location beyond the 16-word memory)
        pc <= x"00000040";
        wait for 10 ns;
        assert instruction = x"00000000"
            report "Instruction Memory failed: PC=0x40 is out of range, expected 0x00000000, got 0x" &
                   integer'image(to_integer(unsigned(instruction)))
            severity failure;
        
        -- PC=0x100 -> word index 64 (well beyond memory)
        pc <= x"00000100";
        wait for 10 ns;
        assert instruction = x"00000000"
            report "Instruction Memory failed: PC=0x100 is out of range, expected 0x00000000, got 0x" &
                   integer'image(to_integer(unsigned(instruction)))
            severity failure;
        
        -- Stop simulation
        wait for 10 ns;
        report "Instruction Memory Testbench completed successfully - all assertions passed!" severity note;
        wait;
    end process;
    
end Behavioral;

-- Instruction_Memory.vhd
-- 32-bit Instruction Memory for MIPS Processor
-- Final Project - Task 4

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Memory is
    Port (
        pc          : in  STD_LOGIC_VECTOR(31 downto 0);  -- Program Counter
        instruction : out STD_LOGIC_VECTOR(31 downto 0)   -- Fetched instruction
    );
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is
    -- Instruction memory array (16 locations, each 32 bits)
    type mem_array is array (0 to 15) of STD_LOGIC_VECTOR(31 downto 0);
    
    -- Initialize memory with instructions from Task 4
    signal mem : mem_array := (
        -- Address 0: add $t0, $t1, $t2
        -- MIPS format: opcode=0, rs=9($t1), rt=10($t2), rd=8($t0), funct=32
        0 => x"012A4020",  -- add $t0, $t1, $t2
        
        -- Address 2: sub $t2, $t2, $t3  
        -- sub $t2, $t2, $t3: opcode=0, rs=10($t2), rt=11($t3), rd=10($t2), funct=34
        2 => x"014B5022",  -- sub $t2, $t2, $t3
        
        -- Address 4: and $t1, $t2, $t0
        -- and $t1, $t2, $t0: opcode=0, rs=10($t2), rt=8($t0), rd=9($t1), funct=36
        4 => x"01484824",  -- and $t1, $t2, $t0
        
        -- Address 6: or $t2, $t3, $t1
        -- or $t2, $t3, $t1: opcode=0, rs=11($t3), rt=9($t1), rd=10($t2), funct=37
        6 => x"01695025",  -- or $t2, $t3, $t1
        
        -- All other addresses default to 0
        others => x"00000000"
    );
    
begin
    -- Instruction fetch based on PC
    -- Word index = PC / 4 = pc(31 downto 2), since instructions are 4 bytes each
    process(pc)
        variable addr_index : integer;
    begin
        -- Convert the full word-aligned PC to an index
        addr_index := to_integer(unsigned(pc(31 downto 2)));
        
        -- Check if address is within bounds (16 words)
        if addr_index < 16 then
            instruction <= mem(addr_index);
        else
            instruction <= x"00000000";  -- No instruction beyond memory
        end if;
    end process;
    
end Behavioral;
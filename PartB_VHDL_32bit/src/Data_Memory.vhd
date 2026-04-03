-- Data_Memory.vhd
-- 32-bit Data Memory for MIPS Processor
-- Final Project - Task 1b

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data_Memory is
    Port (
        clk             : in  STD_LOGIC;
        mem_access_addr : in  STD_LOGIC_VECTOR(31 downto 0);
        mem_write_data  : in  STD_LOGIC_VECTOR(31 downto 0);
        mem_write_en    : in  STD_LOGIC;
        mem_read        : in  STD_LOGIC;
        mem_read_data   : out STD_LOGIC_VECTOR(31 downto 0)
    );
end Data_Memory;

architecture Behavioral of Data_Memory is
    type mem_array is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    signal RAM : mem_array := (others => (others => '0'));
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if mem_write_en = '1' then
                RAM(to_integer(unsigned(mem_access_addr(7 downto 0)))) <= mem_write_data;
            end if;
        end if;
    end process;
    
    -- Read (asynchronous)
    mem_read_data <= RAM(to_integer(unsigned(mem_access_addr(7 downto 0)))) when mem_read = '1' else x"00000000";
    
end Behavioral;
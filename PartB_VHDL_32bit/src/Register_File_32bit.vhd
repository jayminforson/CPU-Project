-- Register_File_32bit.vhd
-- 8 registers, 32-bit each for MIPS Processor

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File_32bit is
    Port (
        clk             : in  STD_LOGIC;
        rst             : in  STD_LOGIC;
        reg_write_en    : in  STD_LOGIC;
        reg_write_dest  : in  STD_LOGIC_VECTOR(2 downto 0);
        reg_write_data  : in  STD_LOGIC_VECTOR(31 downto 0);
        reg_read_addr_1 : in  STD_LOGIC_VECTOR(2 downto 0);
        reg_read_addr_2 : in  STD_LOGIC_VECTOR(2 downto 0);
        reg_read_data_1 : out STD_LOGIC_VECTOR(31 downto 0);
        reg_read_data_2 : out STD_LOGIC_VECTOR(31 downto 0)
    );
end Register_File_32bit;

architecture Behavioral of Register_File_32bit is
    type reg_array is array (0 to 7) of STD_LOGIC_VECTOR(31 downto 0);
    signal registers : reg_array := (others => (others => '0'));
begin
    -- Write process
    process(clk, rst)
    begin
        if rst = '1' then
            -- Reset all registers to 0
            registers <= (others => (others => '0'));
        elsif rising_edge(clk) then
            if reg_write_en = '1' then
                registers(to_integer(unsigned(reg_write_dest))) <= reg_write_data;
            end if;
        end if;
    end process;
    
    -- Read ports (register 0 always reads 0)
    reg_read_data_1 <= x"00000000" when reg_read_addr_1 = "000" else
                       registers(to_integer(unsigned(reg_read_addr_1)));
    reg_read_data_2 <= x"00000000" when reg_read_addr_2 = "000" else
                       registers(to_integer(unsigned(reg_read_addr_2)));
    
end Behavioral;
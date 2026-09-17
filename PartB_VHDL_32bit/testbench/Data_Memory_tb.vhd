-- Data_Memory_tb.vhd
-- Self-checking testbench for Data Memory (asserts expected results)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Data_Memory_tb is
end Data_Memory_tb;

architecture Behavioral of Data_Memory_tb is
    component Data_Memory
        Port (
            clk             : in  STD_LOGIC;
            mem_access_addr : in  STD_LOGIC_VECTOR(31 downto 0);
            mem_write_data  : in  STD_LOGIC_VECTOR(31 downto 0);
            mem_write_en    : in  STD_LOGIC;
            mem_read        : in  STD_LOGIC;
            mem_read_data   : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
    
    signal clk             : STD_LOGIC := '0';
    signal mem_access_addr : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal mem_write_data  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal mem_write_en    : STD_LOGIC := '0';
    signal mem_read        : STD_LOGIC := '0';
    signal mem_read_data   : STD_LOGIC_VECTOR(31 downto 0);
    
    constant clk_period : time := 10 ns;
    
begin
    UUT: Data_Memory port map (
        clk => clk,
        mem_access_addr => mem_access_addr,
        mem_write_data => mem_write_data,
        mem_write_en => mem_write_en,
        mem_read => mem_read,
        mem_read_data => mem_read_data
    );
    
    -- Clock generation
    clk <= not clk after clk_period/2;
    
    process
    begin
        -- Test 1: Write 1024 (0x00000400) to Address 2
        mem_write_en <= '1';
        mem_access_addr <= x"00000002";
        mem_write_data <= x"00000400";  -- 1024 in hex
        wait for 10 ns;
        mem_write_en <= '0';
        
        -- Read back from Address 2 and check
        mem_read <= '1';
        mem_access_addr <= x"00000002";
        wait for 10 ns;
        assert mem_read_data = x"00000400"
            report "Data Memory failed: Address 2 should read 0x00000400, got 0x" &
                   integer'image(to_integer(unsigned(mem_read_data)))
            severity failure;
        mem_read <= '0';
        wait for 10 ns;
        
        -- Unwritten address must read as zero
        mem_read <= '1';
        mem_access_addr <= x"00000063";
        wait for 10 ns;
        assert mem_read_data = x"00000000"
            report "Data Memory failed: unwritten Address 99 should read 0x00000000, got 0x" &
                   integer'image(to_integer(unsigned(mem_read_data)))
            severity failure;
        mem_read <= '0';
        wait for 10 ns;
        
        -- Test 2: Write 429496 (0x00068E78) to Address 4
        mem_write_en <= '1';
        mem_access_addr <= x"00000004";
        mem_write_data <= x"00068E78";  -- 429496 in hex
        wait for 10 ns;
        mem_write_en <= '0';
        
        -- Read back from Address 4 and check
        mem_read <= '1';
        mem_access_addr <= x"00000004";
        wait for 10 ns;
        assert mem_read_data = x"00068E78"
            report "Data Memory failed: Address 4 should read 0x00068E78, got 0x" &
                   integer'image(to_integer(unsigned(mem_read_data)))
            severity failure;
        mem_read <= '0';
        
        -- Stop simulation
        wait for 20 ns;
        report "Data Memory Testbench completed successfully - all assertions passed!" severity note;
        wait;
    end process;
    
end Behavioral;

-- Register_File_tb.vhd
-- Testbench for Register File with full signal visibility

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File_tb is
end Register_File_tb;

architecture Behavioral of Register_File_tb is
    component Register_File_32bit
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
    end component;
    
    signal clk             : STD_LOGIC := '0';
    signal rst             : STD_LOGIC := '1';
    signal reg_write_en    : STD_LOGIC := '0';
    signal reg_write_dest  : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal reg_write_data  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal reg_read_addr_1 : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal reg_read_addr_2 : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal reg_read_data_1 : STD_LOGIC_VECTOR(31 downto 0);
    signal reg_read_data_2 : STD_LOGIC_VECTOR(31 downto 0);
    
    constant clk_period : time := 10 ns;
    
begin
    UUT: Register_File_32bit port map (
        clk => clk,
        rst => rst,
        reg_write_en => reg_write_en,
        reg_write_dest => reg_write_dest,
        reg_write_data => reg_write_data,
        reg_read_addr_1 => reg_read_addr_1,
        reg_read_addr_2 => reg_read_addr_2,
        reg_read_data_1 => reg_read_data_1,
        reg_read_data_2 => reg_read_data_2
    );
    
    -- Clock generation
    clk <= not clk after clk_period/2;
    
    -- Test process
    process
    begin
        -- Reset
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 10 ns;
        
        -- Write to Register 1: 1934858
        reg_write_en <= '1';
        reg_write_dest <= "001";
        reg_write_data <= x"001D878A";
        wait for 10 ns;
        
        -- Write to Register 3: 8558447
        reg_write_dest <= "011";
        reg_write_data <= x"00829BEF";
        wait for 10 ns;
        
        -- Write to Register 5: 203848544
        reg_write_dest <= "101";
        reg_write_data <= x"0C2685A0";
        wait for 10 ns;
        
        -- Write to Register 7: 20670420
        reg_write_dest <= "111";
        reg_write_data <= x"013B6B54";
        wait for 10 ns;
        
        reg_write_en <= '0';
        
        -- Read Register 1
        reg_read_addr_1 <= "001";
        wait for 10 ns;
        
        -- Read Register 3
        reg_read_addr_1 <= "011";
        wait for 10 ns;
        
        -- Read Register 5
        reg_read_addr_1 <= "101";
        wait for 10 ns;
        
        -- Read Register 7
        reg_read_addr_1 <= "111";
        wait for 10 ns;
        
        -- Stop simulation
        wait for 20 ns;
        report "Register File Testbench completed!" severity note;
        wait;
    end process;
    
end Behavioral;
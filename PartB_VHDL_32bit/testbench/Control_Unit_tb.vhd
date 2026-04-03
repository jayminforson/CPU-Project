-- Control_Unit_tb.vhd
-- Testbench for Control Unit with full signal visibility

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Control_Unit_tb is
end Control_Unit_tb;

architecture Behavioral of Control_Unit_tb is
    component Control_Unit
        Port (
            opcode      : in  STD_LOGIC_VECTOR(5 downto 0);
            reset       : in  STD_LOGIC;
            reg_dst     : out STD_LOGIC_VECTOR(1 downto 0);
            mem_to_reg  : out STD_LOGIC_VECTOR(1 downto 0);
            alu_op      : out STD_LOGIC_VECTOR(1 downto 0);
            jump        : out STD_LOGIC;
            branch      : out STD_LOGIC;
            mem_read    : out STD_LOGIC;
            mem_write   : out STD_LOGIC;
            alu_src     : out STD_LOGIC;
            reg_write   : out STD_LOGIC;
            sign_or_zero: out STD_LOGIC
        );
    end component;
    
    signal opcode      : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
    signal reset       : STD_LOGIC := '1';
    signal reg_dst     : STD_LOGIC_VECTOR(1 downto 0);
    signal mem_to_reg  : STD_LOGIC_VECTOR(1 downto 0);
    signal alu_op      : STD_LOGIC_VECTOR(1 downto 0);
    signal jump        : STD_LOGIC;
    signal branch      : STD_LOGIC;
    signal mem_read    : STD_LOGIC;
    signal mem_write   : STD_LOGIC;
    signal alu_src     : STD_LOGIC;
    signal reg_write   : STD_LOGIC;
    signal sign_or_zero: STD_LOGIC;
    
begin
    UUT: Control_Unit port map (
        opcode => opcode,
        reset => reset,
        reg_dst => reg_dst,
        mem_to_reg => mem_to_reg,
        alu_op => alu_op,
        jump => jump,
        branch => branch,
        mem_read => mem_read,
        mem_write => mem_write,
        alu_src => alu_src,
        reg_write => reg_write,
        sign_or_zero => sign_or_zero
    );
    
    process
    begin
        -- Reset
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        wait for 10 ns;
        
        -- R-type (add, sub, and, or, slt)
        opcode <= "000000";
        wait for 10 ns;
        
        -- addi
        opcode <= "001000";
        wait for 10 ns;
        
        -- lw
        opcode <= "100011";
        wait for 10 ns;
        
        -- sw
        opcode <= "101011";
        wait for 10 ns;
        
        -- beq
        opcode <= "000100";
        wait for 10 ns;
        
        -- j
        opcode <= "000010";
        wait for 10 ns;
        
        -- jal
        opcode <= "000011";
        wait for 10 ns;
        
        -- slti
        opcode <= "001010";
        wait for 10 ns;
        
        -- Stop simulation
        wait for 10 ns;
        report "Control Unit Testbench completed!" severity note;
        wait;
    end process;
    
end Behavioral;
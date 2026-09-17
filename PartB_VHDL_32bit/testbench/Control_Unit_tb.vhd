-- Control_Unit_tb.vhd
-- Self-checking testbench for Control Unit (asserts expected results)

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
    
    -- Helper: full 10-bit control word for one-line assertions
    function ctrl(
        reg_dst, mem_to_reg, alu_op : STD_LOGIC_VECTOR(1 downto 0);
        jump, branch, mem_read, mem_write, alu_src, reg_write, sign_or_zero : STD_LOGIC
    ) return STD_LOGIC_VECTOR is
    begin
        return reg_dst & mem_to_reg & alu_op
             & jump & branch & mem_read & mem_write & alu_src & reg_write & sign_or_zero;
    end function;
    
    signal ctrl_out : STD_LOGIC_VECTOR(12 downto 0);
    
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
    
    -- Aggregate outputs so each opcode check is a single assertion
    ctrl_out <= reg_dst & mem_to_reg & alu_op
              & jump & branch & mem_read & mem_write & alu_src & reg_write & sign_or_zero;
    
    process
    begin
        -- Reset: all control signals inactive
        reset <= '1';
        wait for 10 ns;
        assert ctrl_out = ctrl("00", "00", "00", '0', '0', '0', '0', '0', '0', '0')
            report "Control Unit failed during reset: expected all-inactive, got " &
                   integer'image(to_integer(unsigned(ctrl_out)))
            severity failure;
        reset <= '0';
        wait for 10 ns;
        
        -- R-type (add, sub, and, or, slt):
        -- reg_dst=01, alu_op=10, reg_write=1
        opcode <= "000000";
        wait for 10 ns;
        assert ctrl_out = ctrl("01", "00", "10", '0', '0', '0', '0', '0', '1', '0')
            report "Control Unit failed for R-type: got " &
                   integer'image(to_integer(unsigned(ctrl_out)))
            severity failure;
        
        -- addi: alu_src=1, reg_write=1, sign extend
        opcode <= "001000";
        wait for 10 ns;
        assert ctrl_out = ctrl("00", "00", "00", '0', '0', '0', '0', '1', '1', '1')
            report "Control Unit failed for addi: got " &
                   integer'image(to_integer(unsigned(ctrl_out)))
            severity failure;
        
        -- lw: mem_to_reg=01, alu_src=1, mem_read=1, reg_write=1, sign extend
        opcode <= "100011";
        wait for 10 ns;
        assert ctrl_out = ctrl("00", "01", "00", '0', '0', '1', '0', '1', '1', '1')
            report "Control Unit failed for lw: got " &
                   integer'image(to_integer(unsigned(ctrl_out)))
            severity failure;
        
        -- sw: alu_src=1, mem_write=1, sign extend
        opcode <= "101011";
        wait for 10 ns;
        assert ctrl_out = ctrl("00", "00", "00", '0', '0', '0', '1', '1', '0', '1')
            report "Control Unit failed for sw: got " &
                   integer'image(to_integer(unsigned(ctrl_out)))
            severity failure;
        
        -- beq: alu_op=01, branch=1, sign extend
        opcode <= "000100";
        wait for 10 ns;
        assert ctrl_out = ctrl("00", "00", "01", '0', '1', '0', '0', '0', '0', '1')
            report "Control Unit failed for beq: got " &
                   integer'image(to_integer(unsigned(ctrl_out)))
            severity failure;
        
        -- j: jump=1 only
        opcode <= "000010";
        wait for 10 ns;
        assert ctrl_out = ctrl("00", "00", "00", '1', '0', '0', '0', '0', '0', '0')
            report "Control Unit failed for j: got " &
                   integer'image(to_integer(unsigned(ctrl_out)))
            severity failure;
        
        -- jal: jump=1, reg_write=1
        opcode <= "000011";
        wait for 10 ns;
        assert ctrl_out = ctrl("00", "00", "00", '1', '0', '0', '0', '0', '1', '0')
            report "Control Unit failed for jal: got " &
                   integer'image(to_integer(unsigned(ctrl_out)))
            severity failure;
        
        -- slti: alu_op=11, alu_src=1, reg_write=1, sign extend
        opcode <= "001010";
        wait for 10 ns;
        assert ctrl_out = ctrl("00", "00", "11", '0', '0', '0', '0', '1', '1', '1')
            report "Control Unit failed for slti: got " &
                   integer'image(to_integer(unsigned(ctrl_out)))
            severity failure;
        
        -- Unknown opcode: all control signals inactive
        opcode <= "111111";
        wait for 10 ns;
        assert ctrl_out = ctrl("00", "00", "00", '0', '0', '0', '0', '0', '0', '0')
            report "Control Unit failed for unknown opcode: expected all-inactive, got " &
                   integer'image(to_integer(unsigned(ctrl_out)))
            severity failure;
        
        -- Stop simulation
        report "Control Unit Testbench completed successfully - all assertions passed!" severity note;
        wait;
    end process;
    
end Behavioral;

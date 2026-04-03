-- Control_Unit.vhd
-- MIPS Control Unit for 32-bit Processor
-- Final Project - Task 5

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Control_Unit is
    Port (
        opcode      : in  STD_LOGIC_VECTOR(5 downto 0);  -- Instruction opcode
        reset       : in  STD_LOGIC;                     -- Reset signal
        
        -- Control signals output
        reg_dst     : out STD_LOGIC_VECTOR(1 downto 0);  -- Register destination
        mem_to_reg  : out STD_LOGIC_VECTOR(1 downto 0);  -- Memory to register
        alu_op      : out STD_LOGIC_VECTOR(1 downto 0);  -- ALU operation
        jump        : out STD_LOGIC;                     -- Jump control
        branch      : out STD_LOGIC;                     -- Branch control
        mem_read    : out STD_LOGIC;                     -- Memory read
        mem_write   : out STD_LOGIC;                     -- Memory write
        alu_src     : out STD_LOGIC;                     -- ALU source
        reg_write   : out STD_LOGIC;                     -- Register write
        sign_or_zero: out STD_LOGIC                      -- Sign or zero extend
    );
end Control_Unit;

architecture Behavioral of Control_Unit is
begin
    process(opcode, reset)
    begin
        if reset = '1' then
            -- Reset all control signals to default (inactive)
            reg_dst     <= "00";
            mem_to_reg  <= "00";
            alu_op      <= "00";
            jump        <= '0';
            branch      <= '0';
            mem_read    <= '0';
            mem_write   <= '0';
            alu_src     <= '0';
            reg_write   <= '0';
            sign_or_zero<= '0';
        else
            -- Default values (inactive)
            reg_dst     <= "00";
            mem_to_reg  <= "00";
            alu_op      <= "00";
            jump        <= '0';
            branch      <= '0';
            mem_read    <= '0';
            mem_write   <= '0';
            alu_src     <= '0';
            reg_write   <= '0';
            sign_or_zero<= '0';
            
            -- Decode opcode and set control signals
            case opcode is
                -- R-type instructions (add, sub, and, or, slt)
                when "000000" =>
                    reg_dst     <= "01";    -- Write to rd
                    mem_to_reg  <= "00";    -- Result from ALU
                    alu_op      <= "10";    -- Use funct field
                    reg_write   <= '1';     -- Enable register write
                    
                -- addi (add immediate)
                when "001000" =>
                    mem_to_reg  <= "00";    -- Result from ALU
                    alu_op      <= "00";    -- Addition
                    alu_src     <= '1';     -- Use immediate
                    reg_write   <= '1';     -- Enable register write
                    sign_or_zero<= '1';     -- Sign extend
                    
                -- lw (load word)
                when "100011" =>
                    mem_to_reg  <= "01";    -- Result from memory
                    alu_op      <= "00";    -- Addition for address
                    alu_src     <= '1';     -- Use immediate
                    mem_read    <= '1';     -- Enable memory read
                    reg_write   <= '1';     -- Enable register write
                    sign_or_zero<= '1';     -- Sign extend
                    
                -- sw (store word)
                when "101011" =>
                    alu_op      <= "00";    -- Addition for address
                    alu_src     <= '1';     -- Use immediate
                    mem_write   <= '1';     -- Enable memory write
                    sign_or_zero<= '1';     -- Sign extend
                    
                -- beq (branch if equal)
                when "000100" =>
                    alu_op      <= "01";    -- Subtraction for compare
                    branch      <= '1';     -- Enable branch
                    sign_or_zero<= '1';     -- Sign extend
                    
                -- j (jump)
                when "000010" =>
                    jump        <= '1';     -- Enable jump
                    
                -- jal (jump and link)
                when "000011" =>
                    jump        <= '1';     -- Enable jump
                    reg_write   <= '1';     -- Save return address to $31
                    
                -- slti (set on less than immediate)
                when "001010" =>
                    mem_to_reg  <= "00";    -- Result from ALU
                    alu_op      <= "11";    -- SLT operation
                    alu_src     <= '1';     -- Use immediate
                    reg_write   <= '1';     -- Enable register write
                    sign_or_zero<= '1';     -- Sign extend
                    
                -- sltiu (set on less than immediate unsigned)
                when "001011" =>
                    mem_to_reg  <= "00";
                    alu_op      <= "11";
                    alu_src     <= '1';
                    reg_write   <= '1';
                    sign_or_zero<= '0';     -- Zero extend
                    
                -- Default case (no operation)
                when others =>
                    null;
            end case;
        end if;
    end process;
    
end Behavioral;
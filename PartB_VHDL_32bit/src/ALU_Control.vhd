-- ALU_Control.vhd
-- Controls ALU operations based on ALUOp and funct field
-- Final Project

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_Control is
    Port (
        ALUOp       : in  STD_LOGIC_VECTOR(1 downto 0);
        ALU_Funct   : in  STD_LOGIC_VECTOR(5 downto 0);
        ALU_Control : out STD_LOGIC_VECTOR(2 downto 0)
    );
end ALU_Control;

architecture Behavioral of ALU_Control is
begin
    process(ALUOp, ALU_Funct)
    begin
        case ALUOp is
            when "00" =>   -- lw/sw/addi (addition)
                ALU_Control <= "000";
            when "01" =>   -- beq (subtraction for compare)
                ALU_Control <= "001";
            when "10" =>   -- R-type (use funct field)
                case ALU_Funct is
                    when "100000" => ALU_Control <= "000";  -- add
                    when "100010" => ALU_Control <= "001";  -- sub
                    when "100100" => ALU_Control <= "010";  -- and
                    when "100101" => ALU_Control <= "011";  -- or
                    when "101010" => ALU_Control <= "100";  -- slt
                    when others => ALU_Control <= "000";
                end case;
            when "11" =>   -- slti/sltiu
                ALU_Control <= "100";
            when others =>
                ALU_Control <= "000";
        end case;
    end process;
end Behavioral;
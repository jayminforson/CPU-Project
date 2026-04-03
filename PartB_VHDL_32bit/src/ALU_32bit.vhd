-- ALU_32bit.vhd
-- 32-bit Arithmetic Logic Unit for MIPS Processor
-- Computer Organization & Architecture
-- Final Project Part B

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU_32bit is
    Port (
        A           : in  STD_LOGIC_VECTOR(31 downto 0);  -- First operand
        B           : in  STD_LOGIC_VECTOR(31 downto 0);  -- Second operand
        ALU_Control : in  STD_LOGIC_VECTOR(2 downto 0);   -- Operation selector
        ALU_Result  : out STD_LOGIC_VECTOR(31 downto 0);  -- Result of operation
        Zero        : out STD_LOGIC                        -- Zero flag (1 if result = 0)
    );
end ALU_32bit;

architecture Behavioral of ALU_32bit is
    signal Result : STD_LOGIC_VECTOR(31 downto 0);
begin
    process(A, B, ALU_Control)
    begin
        case ALU_Control is
            when "000" =>   -- Addition
                Result <= std_logic_vector(signed(A) + signed(B));
                
            when "001" =>   -- Subtraction
                Result <= std_logic_vector(signed(A) - signed(B));
                
            when "010" =>   -- Bitwise AND
                Result <= A and B;
                
            when "011" =>   -- Bitwise OR
                Result <= A or B;
                
            when "100" =>   -- Set on Less Than (SLT)
                if (signed(A) < signed(B)) then
                    Result <= x"00000001";
                else
                    Result <= x"00000000";
                end if;
                
            when others =>   -- Default case (should not occur)
                Result <= x"00000000";
        end case;
    end process;
    
    -- Assign output
    ALU_Result <= Result;
    
    -- Zero flag: 1 when result is all zeros
    Zero <= '1' when Result = x"00000000" else '0';
    
end Behavioral;
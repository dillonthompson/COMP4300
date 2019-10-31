use work.dlx_types.all;
use work.bv_arithmetic.all;

entity alu is 
    generic(prop_delay: time := 15ns);
    port(operand1, operand2: in dlx_word; operation: in alu_operation_code;  
        result: out dlx_word; error: out error_code
        );
end entity alu;

architecture behaviour of alu is
    begin
        aluProc : process(operand1,operand2,operation) is
            variable tempres: dlx_word;
            variable flow: boolean;
            variable divzero: boolean;
            begin
                case operation is
                    error<= "0000"
                    when "0000" =>  --unsigned add
                                bv_addu(operand1,operand2,tempres,flow);
                                if flow then
                                    error<= "0001";
                                end if ;
                    when "0001" => -- unsigned sub
                                bv_subu(operand1,operand2,tempres,flow);
                                if flow then
                                    error<= "0010";                                
                                end if ;
                    when "0010" => --two's add
                                bv_add(operand1,operand2,tempres,flow);
                                if flow then
                                    error<= "0001";
                                elsif (operand1(operand1'left) = '1' and operand(operand2'left) = '1' and tempres(tempres'left) = '1') then
                                    error<= "0010";
                                end if ;
                    when "0011" => -- two's sub
                                bv_sub(operand1,operand2,tempres,flow);
                                if flow then
                                    error<= "0010";
                                elsif (operand1(operand1'left) = '1' and operand2(operand2'left) = '1' and tempres(tempres'left) = '1') then
                                    error<= "0010";
                                end if ;
                    when "0100" => --two's mult
                                bv_mult(operand1,operand2,tempres,flow);
                                if flow then
                                    error<= "0001";
                                elsif (operand1(operand1'left) = '1' and operand2(operand2'left) = '0' and tempres(tempres'left) = '0') then
                                    error<= "0010";
                                elsif (operand1(operand1'left) = '0' and operand2(operand2'left) = '1' and tempres(tempres'left) = '0') then
                                    error<= "0010";
                                end if ;
                    when "0101" => --two's div
                                bv_div(operand1,operand2,tempres,divzero,flow);
                                if divzero = 0 then
                                    error<= "0011";
                                elsif flow then
                                    error<= "0001";
                                elsif (operand1(operand1'left) = '1' and operand2(operand2'left) = '0' and tempres(tempres'left) = '0') then
                                    error<= "0010";
                                elsif (operand1(operand1'left) = '0' and operand2(operand2'left) = '1' and tempres(tempres'left) = '0') then
                                    error=> "0010";
                                end if ;
                    when "0110" => --logical &
                                tempres := operand1 and operand2;
                    when "0111" => --bitwise &
                                tempres := operand1 & operand2;
                    when "1000" => --logcial or
                                tempres := operand1 or operand2;
                    when "1001" => --bitwise or
                                tempres := operand1 | operand2;
                    when "1010"=> -- logical not
                                tempres := not operand1;
                    when "1011" --bitwise not
                                if operand1 /= natural_to_bv(1, 32) then
                                    tempres := natural_to_bv(0, 32);
                                else
                                    tempres := natural_to_bv(1, 32);
                    when others => --print all zeroes
                                tempres := natural_to_bv(0, 32);
                end case; 
                result<= tempres after prop_delay;  
            end process aluProc;
    end architecture behaviour;
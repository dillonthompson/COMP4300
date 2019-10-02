entity andOrGate is 
	generic(prop_delay: Time := 10 ns);
	port(a_in,b_in,control: in bit;
             result: out bit);
end entity andOrGate; 


architecture behaviour1 of andOrGate is
begin
	andOrProcess : process(a_in,b_in,control) is 
	
    begin
        if control = '1' then
            if a_in = '1' then
                if b_in = '1' then
                    result <= '1' after prop_delay;
                else
                    result <= '0' after prop_delay;
                end if;
            else
                if b_in = '1' then
                    result <= '0' after prop_delay;
                else
                    result <= '0' after prop_delay;
                end if;
            end if;
        else
            if a_in = '1' then
                result <= '1' after prop_delay;
            end if;
            if b_in ='1' then
                result <= '1' after prop_delay;
            end if ;
            if a_in = '1' then
                if b_in = '1' then
                    result <= '1' after prop_delay;
                end if;
            else
            result <= '0' after prop_delay;
            end if;
	end process andOrProcess; 
end architecture behaviour1; 
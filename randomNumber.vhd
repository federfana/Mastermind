library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity randomNumber is 
	generic (wd : integer:=12);
	
	port (
		CLOCK			:in std_logic;
		random_num 	: out std_logic_vector(wd-1 downto 0)	
	);
end randomNumber;
	
architecture Behavioral of randomNumber is 
begin
		process(CLOCK)
			variable rand_temp : std_logic_vector(wd-1 downto 0) := (wd-1=>'1', others=>'0');
			variable temp : std_logic:='0';
		begin
			if (rising_edge(CLOCK)) then
				temp := rand_temp(wd-1) xor rand_temp(wd-2);
				rand_temp(wd-1 downto 1) := rand_temp(wd-2 downto 0 );
				rand_temp(0):=temp;
			end if;
			random_num<=rand_temp;
		end process;
end Behavioral;
 	
	
	
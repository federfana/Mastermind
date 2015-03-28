library ieee;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.mastermind_package.all;
use work.vga_package.all;

entity mastermind_datapath is
port
	(
		CLOCK						: in  std_logic;
		RESET_N					: in  std_logic;
		random_num				: in 	std_logic_vector(2 downto 0);
		
		---connection with view ----- 
		NEW_GAME 				: in std_logic;
		ENABLE_CHECK			: in std_logic;
		USER_VICTORY			: out std_logic;
		INSERT_ATTEMPT 		: in row;
		CHECK						: out std_logic:='1';
		INSERT_CHECK			: out code
	
	);
	
	
end entity;


architecture RTL of mastermind_datapath is
	signal secret_cod		: code;
	signal check_victory : code;	
	type b 		 is array(3 downto 0) of Boolean;

begin
	
	Cod_RTL : process(CLOCK, RESET_N)

	begin		
		if(RESET_N = '0')then
		
		end if;
		if(rising_edge(CLOCK))then
			if(NEW_GAME = '1')then
--				for i in 0 to 3 loop
--					case random_num is 
--						when "000" => secret_cod(i) <= COLOR_RED;
--						when "001" => secret_cod(i) <= COLOR_BLUE;
--						when "010" => secret_cod(i) <= COLOR_ORANGE;
--						when "011" => secret_cod(i) <= COLOR_GREEN;
--						when "100" => secret_cod(i) <= COLOR_YELLOW;
--						when "101" => secret_cod(i) <= COLOR_CYAN;
--						when "110" => secret_cod(i) <= COLOR_GREY;
--						when "111" => secret_cod(i) <= COLOR_MAGENTA;
--					end case;
--				end loop;
--				NEW_SECRET_COD <= secret_cod;
				secret_cod(0) <= COLOR_RED;
				secret_cod(1) <= COLOR_BLUE;
				secret_cod(2) <= COLOR_ORANGE;
				secret_cod(3) <= COLOR_GREEN;				
			end if;
		end if;
	end process;


	
	CHECK_RTL : process(CLOCK)
		variable rightPlaceCount : integer := 0;
		variable presentCount	 : integer := 0;
		variable black : b;
		variable white : b;
	begin
		
		if(rising_edge(CLOCK)) then
		rightPlaceCount :=0;
		presentCount := 0;
		CHECK<='0';
		for i in 0 to 3 loop
				check_victory(i)<= COLOR_BROWN;
				black(i) := false;
				white(i) := false;
		end loop;
		if(ENABLE_CHECK = '1') then
			for i in 0 to 3 loop
				if(INSERT_ATTEMPT.cells(i).color = secret_cod(i) ) then
					rightPlaceCount := rightPlaceCount + 1;
					black(i) := true;					
				end if;
			end loop;
			
			for i in 0 to 3 loop
				for j in 0 to 3 loop
					if(white(j) = false)then
						if (black(i) = false and black(j) = false and (INSERT_ATTEMPT.cells(i).color = secret_cod(j))) then
							presentCount := presentCount + 1;
							white(j) := true;
							exit;
						end if;
					end if;
				end loop;
			end loop;			
	
			if (rightPlaceCount + presentCount > 0)then
				if (rightPlaceCount = 4)then
					USER_VICTORY <= '1';
					for i in 0 to 3 loop
						check_victory(i) <= COLOR_BLACK;
					end loop;
				else
					USER_VICTORY <= '0';
					if(rightPlaceCount > 0) then 
						for i in 0 to 3 loop
							if(i<rightPlaceCount) then
								check_victory(i) <= COLOR_BLACK;
							end if;
						end loop;
					end if;
					if(presentCount > 0)then
						for i in 0 to 3 loop
							if(i<presentCount) then
								check_victory(rightPlaceCount+i) <= COLOR_WHITE;
							end if;
						end loop;
					end if;										
				end if;
				if (rightPlaceCount + presentCount <4)then
					for i in 0 to 3 loop
						if(i<presentCount+rightPlaceCount and (presentCount+rightPlaceCount+i<=3)) then
							check_victory(i+rightPlaceCount+presentCount)<= COLOR_BROWN;
						end if;
					end loop;
				end if;
			end if;
			INSERT_CHECK <= check_victory;
			CHECK<='1';
		end if;
	end if;
	end process;
--INSERT_CHECK <= secret_cod;
end architecture;






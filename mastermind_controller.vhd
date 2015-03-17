library ieee;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use work.mastermind_package.all;

entity mastermind_controller is
	port
	(
		CLOCK						: in  std_logic;
		RESET_N					: in  std_logic;
		random_num				: in 	std_logic_vector(2 downto 0);
		
		-- Connections with Datapath
		NEW_COD					: out std_logic;			--ok
		NEW_SECRET_COD			: out code;					--ok
		CLEAR_BOARDS			: out std_logic;			
		INSERT_CHECK			: out code;
		ENABLE_INSERT			: out std_logic;
		
		
		-- Connections with view--
		NEW_GAME					: in std_logic;
		ENABLE_CHECK			: in std_logic;
		USER_VICTORY			: out std_logic;
		INSERT_ATTEMPT 		: in code
	);
end entity;	

architecture RTL of mastermind_controller is
	signal secret_cod		: code;
	signal getPiece		: piece_type;
	signal check_victory : code;	
	signal black 			: std_logic_vector (3 downto 0);
	signal white 			: std_logic_vector (3 downto 0);
	signal rand_num      : integer :=0;

begin
	
	Cod_RTL : process(CLOCK, RESET_N)
--		variable mynum			: Integer := 0;
		variable seed1, seed2	: positive;              -- Seed values for random generator
		variable rand				: real;                  -- Random real-number value in range 0 to 1.0
		variable range_of_rand			: real :=7.0;           -- Random integer value in range 0..4095

	begin
		
		
		if(RESET_N = '0')then
			NEW_COD <= '1';
			CLEAR_BOARDS <= '1';
		elsif(rising_edge(CLOCK))then
			if(NEW_GAME = '1')then
				for i in 0 to 3 loop
					case random_num is 
						when "000" => secret_cod(i) <= PIECE_RED;
						when "001" => secret_cod(i) <= PIECE_BLUE;
						when "010" => secret_cod(i) <= PIECE_ORANGE;
						when "011" => secret_cod(i) <= PIECE_GREEN;
						when "100" => secret_cod(i) <= PIECE_YELLOW;
						when "101" => secret_cod(i) <= PIECE_CYAN;
						when "110" => secret_cod(i) <= PIECE_GREY;
						when "111" => secret_cod(i) <= PIECE_MAGENTA;
					end case;
				end loop;
				NEW_SECRET_COD <= secret_cod;
			end if;
		end if;
	end process;


	
	CHECK_RTL : process(INSERT_ATTEMPT, secret_cod, ENABLE_CHECK)
		variable rightPlaceCount : integer := 0;
		variable presentCount	 : integer := 0;
	begin
		black <= "0000";
		white <= "0000";
		
		if(ENABLE_CHECK = '1') then
			for i in 0 to 3 loop
				if(INSERT_ATTEMPT(i) = secret_cod(i) ) then
					rightPlaceCount := rightPlaceCount + 1;
					black(i) <= '1';
				end if;
			end loop;
			
			for i in 0 to 3 loop
				for j in 0 to 3 loop
					if(white(j) = '0')then
						if (black(i) = '0' and black(j) = '0' and (INSERT_ATTEMPT(i) = secret_cod(j))) then
							presentCount := presentCount + 1;
							white(j) <= '1';
							exit;
						end if;
					end if;
				end loop;
			end loop;
			
			if (rightPlaceCount + presentCount > 0)then
				if (rightPlaceCount = 4)then
					USER_VICTORY <= '1';
					for i in 0 to 3 loop
						check_victory(i) <= PIECE_BLACK;
					end loop;
				else
					USER_VICTORY <= '0';
					if(rightPlaceCount > 0) then 
						for i in 0 to 3 loop
							if(i<rightPlaceCount) then
								check_victory(i) <= PIECE_BLACK;
							end if;
						end loop;
					end if;
					if(presentCount > 0)then
						for i in 0 to 3 loop
							if(i<presentCount) then
								check_victory(rightPlaceCount + i) <= PIECE_WHITE;
							end if;
						end loop;
					end if;
				end if;
			end if;
			INSERT_CHECK <= check_victory;
		end if;
	end process;
end architecture;
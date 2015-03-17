library ieee;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all; 		--tetris dice di non usarlo
use work.mastermind_package.all;

entity mastermind_datapath is
	port
	(
			CLOCK						: in std_logic;
			RESET_N					: in std_logic;
			
			--CONNECTION FOR THE CONTROLLER
			--secret code
			NEW_COD					: in std_logic;			
			NEW_SECRET_COD			: in code;					
			CLEAR_BOARDS			: in std_logic;			
			INSERT_CHECK			: inout code;
			ENABLE_INSERT			: inout std_logic;
		
			
			--CONNECTION FOR THE VIEW
			COUNT						: out integer range 0 to (BOARD1_ROWS-1);
			REFRESH					: out std_logic;
			INSERT_ATTEMPT 		: in code
			
 ---------NON METTERE ; ALLA FINEEE!!!!!!!!!!!!!!!-------	
	);
end entity;

architecture RTL of mastermind_datapath is 
	signal secret_cod 		: code;
	signal board_cod			: board1_type;
	signal board_response	: board2_type;
	signal counter				: integer range 0 to (BOARD1_ROWS-1);
begin
		SecretCod_RTL : process(CLOCK, RESET_N) 
		begin			
			if(rising_edge(CLOCK)) then
				if(NEW_COD = '1') then
					secret_cod <= NEW_SECRET_COD;
				end if;
			end if;
		end process;
		
		
		BoardCod_RTL : process(CLOCK, RESET_N)
		--eventuali costanti
		begin
			if (RESET_N = '0') then
				for row in 0 to (BOARD1_ROWS-1) loop
					for col in 0 to (BOARD1_COLUMNS-1) loop
						board_cod.cells(row,col).filled <= '0';
               end loop;
				end loop;
			elsif (rising_edge(CLOCK)) then
				if (CLEAR_BOARDS = '1') then
					for row in 0 to BOARD1_ROWS-1 loop
						for col in 0 to BOARD1_COLUMNS-1 loop
							board_cod.cells(row,col).filled <= '0';
						end loop;
					end loop;
				elsif(ENABLE_INSERT = '1') then
					for col in 0 to BOARD1_COLUMNS-1 loop
						board_cod.cells(counter,col).piece <= INSERT_ATTEMPT(col);
						board_cod.cells(counter,col).filled <= '1';
					end loop;
				end if;
			end if;
		end process;
		
		
		Counter_RTL : process(CLOCK, RESET_N)   --dentro c'era anche il segnale ENABLE_INSERT ma Tucci ha detto di non inserirlo
		begin 
			if(RESET_N = '0') then
				counter <= 0;
			elsif(rising_edge(CLOCK)) then
				if(ENABLE_INSERT = '1') then
					counter <= counter + 1;
				elsif(CLEAR_BOARDS = '1') then
					counter <= 0;
				end if;
			end if;	
		end process;
		COUNT <= counter;
		
		BoardResponse_RTL : process(CLOCK, RESET_N)
		--eventuali costanti
		begin
			if (RESET_N = '0') then
				for row in 0 to BOARD2_ROWS-1 loop
					for col in 0 to BOARD2_COLUMNS-1 loop
						board_response.cells(row,col).filled <= '0';
               end loop;
				end loop;
			elsif (rising_edge(CLOCK)) then
				if (CLEAR_BOARDS = '1') then
					for row in 0 to BOARD2_ROWS-1 loop
						for col in 0 to BOARD2_COLUMNS-1 loop
							board_response.cells(row,col).filled <= '0';
						end loop;
					end loop;	
				elsif (ENABLE_INSERT = '1') then
					for col in 0 to BOARD2_COLUMNS-1 loop
						board_response.cells(counter,col).piece <= INSERT_CHECK(col);
						board_response.cells(counter,col).filled <= '1';
					end loop;
				end if;
			end if;
		end process;
		
end architecture;


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.mastermind_package.all;
use work.vga_package.all;


entity mastermind is

        port
		(
			CLOCK_50            : in  std_logic;
			KEY                 : in  std_logic_vector(3 downto 0);
			SW                  : in  std_logic_vector(9 downto 9);
			VGA_R               : out std_logic_vector(3 downto 0);
			VGA_G               : out std_logic_vector(3 downto 0);
			VGA_B               : out std_logic_vector(3 downto 0);
			VGA_HS              : out std_logic;
			VGA_VS              : out std_logic;
			SRAM_ADDR           : out   std_logic_vector(17 downto 0);
			SRAM_DQ             : inout std_logic_vector(15 downto 0);
			SRAM_CE_N           : out   std_logic;
			SRAM_OE_N           : out   std_logic;
			SRAM_WE_N           : out   std_logic;
			SRAM_UB_N           : out   std_logic;
			SRAM_LB_N           : out   std_logic
			
			
--			leds1 			: OUT STD_LOGIC_VECTOR(6 downto 0); 
--			leds2 			: OUT STD_LOGIC_VECTOR(6 downto 0);
--			leds3 			: OUT STD_LOGIC_VECTOR(6 downto 0); 
--			leds4 			: OUT STD_LOGIC_VECTOR(6 downto 0)
       );
end;

architecture RTL of mastermind is
	signal clock 					:	std_logic;
	signal RESET_N					:	std_logic;
	signal clock_25Mhz			: STD_LOGIC;
	-- mancano i segnali della view
	
	---segnali datapath
	signal new_cod					: 	std_logic;
	signal new_secret_cod		: 	code;
	signal clear_boards			: 	std_logic;
	signal insert_check			:	code;
	signal enable_insert			: 	std_logic;
	signal count					: 	integer range 0 to (BOARD1_ROWS-1);
	signal refresh					:	std_logic;
	signal insert_attempt 		: 	code;
	--segnali controller
	signal new_game				: 	std_logic;
	signal enable_check			: 	std_logic;
	signal user_victory			:	std_logic;
	signal random_num				: std_logic_vector(2 downto 0);
	
	
begin

	pll: entity work.PLL
			port map(
				inclk0 				=> CLOCK_50,
				c0 					=> clock,
				c1						=> clock_25Mhz			
			);
	randomNumber : entity work.randomNumber
			port map(
				CLOCK => clock,
				random_num =>random_num
			);
			
			
	datapath : entity work.mastermind_datapath
			port map(
				CLOCK					=> clock_25Mhz,
				RESET_N 				=> RESET_N,
				NEW_COD 				=> new_cod,
				NEW_SECRET_COD 	=> new_secret_cod,
				CLEAR_BOARDS 		=> clear_boards,
				INSERT_CHECK 		=> insert_check,
				ENABLE_INSERT 		=> enable_insert,
				COUNT 				=> count,
				REFRESH 				=> refresh,
				INSERT_ATTEMPT 	=> insert_attempt
			);
			
	controller : entity work.mastermind_controller
			port map(
				CLOCK					=> clock_25Mhz,
				RESET_N 				=> RESET_N,
				NEW_COD 				=> new_cod,
				NEW_SECRET_COD 	=> new_secret_cod,
				CLEAR_BOARDS 		=> clear_boards,
				INSERT_CHECK 		=> insert_check,
				ENABLE_INSERT 		=> enable_insert,
				INSERT_ATTEMPT 	=> insert_attempt,
				NEW_GAME 			=> new_game,
				ENABLE_CHECK 		=> enable_check,
				USER_VICTORY 		=> user_victory,
				random_num			=> random_num
			);
			
	view : entity work.mastermind_view
			port map(
				CLOCK					=> clock_25Mhz,
				RESET_N 				=> RESET_N,
				INSERT_ATTEMPT 	=> insert_attempt,
				NEW_GAME 			=> new_game,
				ENABLE_CHECK 		=> enable_check,
				USER_VICTORY 		=> user_victory,
				VGA_HS		=> VGA_HS,		
				VGA_VS		=> VGA_VS,		
				VGA_R		=> VGA_R,	
				VGA_G		=> VGA_G,		
				VGA_B		=> VGA_B,
				KEY 		=> KEY
				
--				leds1			=> leds1,		
--				leds2 		=> leds2,
--				leds3 		=> leds3, 
--				leds4 		=> leds4
			);
			
	

end architecture;





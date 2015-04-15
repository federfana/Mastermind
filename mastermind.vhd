library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.vga_package.all;
use work.mastermind_package.all;


entity mastermind is

        port
		(
			CLOCK_50            : in  std_logic;
			KEY                 : in  std_logic_vector(3 downto 0);
			SW                  : in  std_logic_vector(9 downto 9);
			LEDG						: out std_logic_vector(7 downto 0);
			VGA_R               : out std_logic_vector(3 downto 0);
			VGA_G               : out std_logic_vector(3 downto 0);
			VGA_B               : out std_logic_vector(3 downto 0);
			VGA_HS              : out std_logic;
			VGA_VS              : out std_logic
       );
end;

architecture RTL of mastermind is
	signal clock 					: std_logic;
	signal RESET_N					: std_logic;
	signal clock_25Mhz			: STD_LOGIC;
	signal color 					: color_type;
	signal h_count					: integer range 0 to 1000;
	signal v_count 				: integer range 0 to 500;
	signal xpos						: integer;
	signal ypos						: integer;
	signal dimx						: integer;
	signal dimy						: integer;
	signal random_num				: std_logic_vector(11 downto 0);
	signal enable_check 			: std_logic;
	signal user_victory			: std_logic;
	signal insert_attempt		: row;
	signal insert_check 			: code;
	signal new_game				:std_logic;
	signal check					:std_logic;
	signal start 					: std_logic;
	--signal drawBox					: std_logic;
begin
	pll: entity work.PLL
			port map(
				inclk0 				=> CLOCK_50,
				c0 					=> clock,
				c1						=> clock_25Mhz			
			);
	
	randomNumber : entity work.randomNumber
			port map(
				CLOCK => clock_25Mhz,
				random_num =>random_num
			);

			
	vga_c : entity work.vga_controller
		port map
		(
			CLOCK					=> clock_25Mhz,
			RESET_N 				=> RESET_N,
			VGA_HS				=> VGA_HS,		
			VGA_VS				=> VGA_VS,		
			VGA_R					=> VGA_R,	
			VGA_G					=> VGA_G,		
			VGA_B					=> VGA_B,
			COLOR 				=> color,
			H_COUNT				=> h_count,
			V_COUNT				=> v_count
		);
	view : entity work.mastermind_view
		port map
		(
			CLOCK					=> clock_25Mhz,
			RESET_N 				=> RESET_N,
			KEY					=> KEY,
			COLOR 				=> color,
			ENABLE_CHECK		=> enable_check,
			NEW_GAME 			=> new_game,
			USER_VICTORY  		=> user_victory,
			INSERT_ATTEMPT    => insert_attempt,
			INSERT_CHECK		=> insert_check,
			CHECK 				=> check,
			H_COUNT				=> h_count,
			START 			   => start,	
			V_COUNT				=> v_count			
		);
		
	datapath: entity work.mastermind_datapath
		port map
		(
			CLOCK					=> clock_25Mhz,
			RESET_N 				=> RESET_N,
			random_num 			=> random_num,
			ENABLE_CHECK		=> enable_check,
			NEW_GAME 			=> new_game,
			USER_VICTORY  		=> user_victory,
			CHECK 				=> check,
			INSERT_ATTEMPT    => insert_attempt,
			START 			   => start,
			INSERT_CHECK		=> insert_check
		);	
		
		

end architecture;





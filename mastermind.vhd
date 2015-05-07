	library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.vga_package.all;
use work.mastermind_package.all;


entity mastermind is

        port
		(
			CLOCK_50            	: in  std_logic;
			KEY                 	: in  std_logic_vector(3 downto 0);
			HEX0						: out std_logic_vector(6 downto 0);
			HEX1						: out std_logic_vector(6 downto 0);
			HEX2						: out std_logic_vector(6 downto 0);
			HEX3						: out std_logic_vector(6 downto 0);
			SW                 	: in  std_logic_vector(9 downto 9);
			LEDG						: out std_logic_vector(7 downto 0);
			VGA_R             	: out std_logic_vector(3 downto 0);
			VGA_G               	: out std_logic_vector(3 downto 0);
			VGA_B               	: out std_logic_vector(3 downto 0);
			VGA_HS              	: out std_logic;
			VGA_VS              	: out std_logic
       );
end;

architecture RTL of mastermind is
	signal clock 					: std_logic;
	signal RESET_N					: std_logic;
	signal reset_sync_reg     : std_logic;
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
	signal attempt 					: row;
	signal new_game				:std_logic;
	signal check					:std_logic;
	signal start 					: std_logic;
	signal contatore1 			:  integer range 0 to 8;
	signal ypos_sel1 				: integer range 0 to 1000;
	signal paletta 				: 	colors_pal;
	signal colore_selezionato 	:  color_type;
	signal xpos_sel2 : integer range 0 to 1000;
	signal ypos_sel2 : integer range 0 to 1000;
	signal contatore2 : integer range 0 to 4;
	signal user_lose  :  std_logic:='0';
	signal contatore_riga : integer range 0 to BOARD_ROWS;
	signal new_secret_code : code;
	
	begin
	pll: entity work.PLL
			port map(
				inclk0 				=> CLOCK_50,
				c0 					=> clock,
				c1						=> clock_25Mhz			
			);
	
	reset_sync : process(CLOCK_50)
        begin
                if (rising_edge(CLOCK_50)) then
                        reset_sync_reg <= SW(9);
                        RESET_N <= reset_sync_reg;
                end if;
        end process;
	
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
			COLOR 				=> color,
			counter_sel     	=>contatore1,
			ypos_sel				=> ypos_sel1,
			selected_color		=> colore_selezionato, 
			colors_pals			=> paletta,
			counter_sel_griglia	=>	contatore2,
			row_count		=> contatore_riga,
			xpos_sel_griglia			=> xpos_sel2,
			ypos_sel_griglia			=> ypos_sel2,
			NEW_SECRET_COD		=> new_secret_code,
			NEW_GAME 			=> new_game,
			USER_VICTORY  		=> user_victory,
			USER_LOSE 			=> user_lose,
			ATTEMPT            => ATTEMPT,
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
			NEW_SECRET_COD		=> new_secret_code,
			INSERT_ATTEMPT    => insert_attempt,
			START 			   => start,
			INSERT_CHECK		=> insert_check
		);	
		
		
		controller : entity work.mastermind_controller
		port map
		(
			CLOCK					=> clock_25Mhz,
			RESET_N 				=> RESET_N,
			KEY					=> KEY,
			HEX0 					=> HEX0,
			HEX1 					=> HEX1,
			HEX2 					=> HEX2,
			HEX3 					=> HEX3,
			SW0    				=> SW,
			ATTEMPT				=> attempt,
			INSERT_ATTEMPT    => insert_attempt,
			CONTATORE1     	=>contatore1,
			YPOS_SEL1			 => ypos_sel1,
			COLORE_SELEZIONATO => colore_selezionato,
			USER_LOSE 			=> user_lose,
			ENABLE_CHECK		=> enable_check,
			PALETTA_COLORI 	=> paletta,
			USER_VICTORY  		=> user_victory,
			CONTATORE2			=>	contatore2,
			CONTATORE_RIGA		=> contatore_riga,
			XPOS_SEL2			=> xpos_sel2,
			YPOS_SEL2			=> ypos_sel2,
			START 			   => start		
		);
		
		

end architecture;





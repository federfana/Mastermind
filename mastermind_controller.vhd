library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.vga_package.all;
use work.mastermind_package.all;

entity mastermind_controller is
port
	(
		CLOCK						: in  std_logic;
		RESET_N					: in  std_logic;
		KEY				: in  std_logic_vector(3 downto 0);
		HEX0				: out std_logic_vector(6 downto 0) := not("0000110"); --1;
		HEX1				: out std_logic_vector(6 downto 0);
		HEX2				: out std_logic_vector(6 downto 0);
		HEX3				: out std_logic_vector(6 downto 0);
		ENABLE_CHECK 	: out std_logic;
		INSERT_ATTEMPT	: out row;
		ATTEMPT 			: in row;
		CONTATORE1     		: out  integer range 0 to 8;
		YPOS_SEL1				: out integer range 0 to 1000;
		COLORE_SELEZIONATO 	: out color_type;
		START 					: out std_logic :='0';  
		PALETTA_COLORI			: out colors_pal;
		CONTATORE2				: out integer range 0 to 4;
		CONTATORE_RIGA			: out integer range 0 to BOARD_ROWS+1;
		XPOS_SEL2				: out integer range 0 to 1000;
		YPOS_SEL2				: out integer range 0 to 1000
	);
	
	
end entity;


architecture RTL of mastermind_controller is
	signal ypos_sel : integer range 0 to 1000:=78;
	signal counter_sel : integer range 0 to 8 := 1;
	signal selected_color : color_type := COLOR_RED;
	signal inizio : std_logic:='0';
	signal xpos_sel_griglia : integer range 0 to 1000:=52;
	signal ypos_sel_griglia : integer range 0 to 1000:=24;
	signal counter_sel_griglia : integer range 0 to 4 := 1;
	signal row_count : integer range 0 to BOARD_ROWS+1:=1;
	signal enablecheck : std_logic:='0';
	signal insert_att : row;
	signal colors_pals : colors_pal;

begin 
	
		colors_pals(0)			<= COLOR_RED;
		colors_pals(1)			<= COLOR_ORANGE;
		colors_pals(2)			<= COLOR_GREEN;
		colors_pals(3)			<= COLOR_BLUE;
		colors_pals(4)			<= COLOR_YELLOW;
		colors_pals(5)			<= COLOR_CYAN;
		colors_pals(6)			<= COLOR_GREY;
		colors_pals(7)			<= COLOR_MAGENTA;
		
	
	key0_press : process 
	begin 
		if(RESET_N='0')then
			counter_sel<= 1;
			ypos_sel <= 78;
			selected_color <= COLOR_RED;
		end if;
		 wait until KEY(0)='0' and KEY(0)'EVENT; 
			 if(inizio='1') then
				case counter_sel is
					when 0=> 
						ypos_sel <= ypos_sel;
						selected_color <= COLOR_RED;
						counter_sel <= counter_sel + 1;
					when 1 to 7 =>
						ypos_sel <= ypos_sel + 40;
						counter_sel <= counter_sel + 1;
						selected_color <= colors_pals(counter_sel);
					when 8 =>
						counter_sel <= 1;
				end case;
			end if;
	end process;
	
	 key1_press : process 
	begin 
		if(RESET_N='0')then
			counter_sel_griglia<= 0;
			xpos_sel_griglia	<=52;
		end if;
		 wait until KEY(1)='0' and KEY(1)'EVENT;
			if(inizio='1') then
			case counter_sel_griglia is
				when 0 => 
					xpos_sel_griglia <= 52;
					counter_sel_griglia <= counter_sel_griglia + 1;				
				when 1 to 3 =>
					xpos_sel_griglia <= xpos_sel_griglia + 54;
					counter_sel_griglia <= counter_sel_griglia + 1;
				when 4 =>
					counter_sel_griglia <= 1 ; 
			end case;
		end if;
	end process;
 
	key2_press : process 
		begin 
		if(RESET_N='0') then 
			row_count <= 1;
			ypos_sel_griglia 	<= 24;
			enablecheck <='0';
			HEX1	<= "1111111";
			HEX2	<= "1111111";
			HEX3	<= "1111111";
		end if;
		wait until KEY(2)='0' and KEY(2)'EVENT;
			if(inizio='1') then
				enablecheck	<='0';
				case row_count is 
					when 0 to 7 => 
						row_count <= row_count+1;
						ypos_sel_griglia <= ypos_sel_griglia + 54;
						if(row_count = 1)then
							HEX0 <= not("1011011"); --2
						elsif(row_count = 2)then
							HEX0 <= not("1001111"); --3
						elsif(row_count = 3)then
							HEX0 <= not("1100110"); --4
						elsif(row_count = 4)then
							HEX0 <= not("1101101"); --5
						elsif(row_count = 5)then
							HEX0 <= not("1111101"); --6
						elsif(row_count = 6)then
							HEX0 <= not("0000111"); --7
						elsif(row_count = 7)then
							HEX0 <= not("1111111"); --8
						end if;
						enablecheck<= '1';
					when 8 =>
						row_count <= 9;
						ypos_sel_griglia <=ypos_sel_griglia;
						enablecheck<= '1';
					when 9 =>
						row_count <= 9;
						ypos_sel_griglia <=ypos_sel_griglia;
						enablecheck<= '0';
				end case;				
				insert_att <= ATTEMPT;
				
			end if;
	end process;



	key3_press: process
	begin
		wait until KEY(3)='0' and KEY(3)'EVENT;
			inizio <= '1';		
	end process;
	
		
--		someKey_press :process 
--		begin 
--		if(RESET_N='0') then
--			counter_sel<= 1;
--			ypos_sel <= 78;
--			selected_color <= COLOR_RED;
--			counter_sel_griglia<= 0;
--			xpos_sel_griglia	<=52;
--			row_count <= 1;
--			ypos_sel_griglia 	<= 24;
--			ENABLE_CHECK <='0';
--		end if;
--		wait until KEY(0)='0' or KEY(1)='0' or KEY(2)='0';
--			if(KEY(0)='0' and KEY(1)='1' and KEY(2)='1') then
--				case counter_sel is
--					when 0=> 
--						ypos_sel <= ypos_sel;
--						selected_color <= COLOR_RED;
--						counter_sel <= counter_sel + 1;
--					when 1 to 7 =>
--						ypos_sel <= ypos_sel + 40;
--						counter_sel <= counter_sel + 1;
--						selected_color <= colors_pals(counter_sel);
--					when 8 =>
--						counter_sel <= 1;
--						ypos_sel <= 78;
--				end case;
--			elsif(KEY(1)='0' and KEY(0)='1' and KEY(2)='1') then 
--				case counter_sel_griglia is
--					when 0 => 
--						xpos_sel_griglia <= 52;
--						counter_sel_griglia <= counter_sel_griglia + 1;				
--					when 1 to 3 =>
--						xpos_sel_griglia <= xpos_sel_griglia + 54;
--						counter_sel_griglia <= counter_sel_griglia + 1;
--					when 4 =>
--						counter_sel_griglia <= 1 ; 
--				end case;			
--			elsif(KEY(2)='0' and KEY(1)='1' and KEY(0)='1') then
--				ENABLE_CHECK<='0';
--				case row_count is 
--					when 0 to 7 => 
--						row_count <= row_count+1;
--						ypos_sel_griglia <= ypos_sel_griglia + 54;
--					when 8 =>
--						row_count <= 9;
--						ypos_sel_griglia <=ypos_sel_griglia;
--					when 9 =>
--						row_count <= 9;
--						ypos_sel_griglia <=ypos_sel_griglia;
--				end case;
--				INSERT_ATTEMPT <= board1.rows(row_count-1);
--				ENABLE_CHECK<= '1';
--			elsif(KEY(3)='0') then
--			
--			end if;
--		end process;

	INSERT_ATTEMPT <= insert_att;
	ENABLE_CHECK<=enablecheck;
	CONTATORE2<=counter_sel_griglia;
	CONTATORE_RIGA<=row_count;
	XPOS_SEL2<=xpos_sel_griglia;
	YPOS_SEL2<=ypos_sel_griglia;
	PALETTA_COLORI<=colors_pals;
	CONTATORE1<=counter_sel;
	YPOS_SEL1<=ypos_sel;
	COLORE_SELEZIONATO<=selected_color;
	START<=inizio;

end architecture; 
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.vga_package.all;
use work.mastermind_package.all;

entity mastermind_view is
   port
	(
		CLOCK				: in  std_logic;
		RESET_N			: in  std_logic;
		KEY				: in  std_logic_vector(3 downto 0);
		COLOR 			: out color_type;
		NEW_GAME			: out std_logic:='1';
		ENABLE_CHECK 	: out std_logic:='0';
		USER_VICTORY	: in 	std_logic;
		INSERT_ATTEMPT	: out row;
		INSERT_CHECK   : in code;
		CHECK				: in std_logic;
		H_COUNT			: in integer range 0 to 1000;
		V_COUNT			: in integer range 0 to 500
	);
end entity;


architecture RTL of mastermind_view is
	signal board1 : board;
	signal board2 : board;
	signal row_count : integer range 0 to BOARD_ROWS+1:=1;
	signal colors_pals : colors_pal;
	signal draw_sel			: std_logic_vector(1 downto 0);
	signal coloreSelettore 	: color_type;
	signal ypos_sel : integer range 0 to 1000:=78;
	signal counter_sel : integer range 0 to 8 := 1;
	signal selected_color : color_type := COLOR_RED;
	signal xpos_sel_griglia : integer range 0 to 1000:=52;
	signal ypos_sel_griglia : integer range 0 to 1000:=24;
	signal counter_sel_griglia : integer range 0 to 4 := 1;	
	
	
begin
		board1.color 			<= COLOR_BROWN;
		board2.color			<= COLOR_BROWN;
		colors_pals(0)			<= COLOR_RED;
		colors_pals(1)			<= COLOR_ORANGE;
		colors_pals(2)			<= COLOR_GREEN;
		colors_pals(3)			<= COLOR_BLUE;
		colors_pals(4)			<= COLOR_YELLOW;
		colors_pals(5)			<= COLOR_CYAN;
		colors_pals(6)			<= COLOR_GREY;
		colors_pals(7)			<= COLOR_MAGENTA;
		
SELEZIONATORE_COLORE: entity work.dinamic_selectors
	port map
	(
		XPOS => 578,
		YPOS => ypos_sel,
		SPES => 2,
		DIMX => 22,
		DIMY => 22,
		pixel_x => H_COUNT,
		pixel_y => V_COUNT,
		drawbox => draw_sel(0)
);

SELEZIONATORE_CELLA: entity work.dinamic_selectors
	port map
	(
		XPOS => xpos_sel_griglia,
		YPOS => ypos_sel_griglia,
		SPES => 2,
		DIMX => 52,
		DIMY => 52,
		pixel_x => H_COUNT,
		pixel_y => V_COUNT,
		drawbox => draw_sel(1)
);
		
	drawBoard : process(CLOCK, RESET_N)
		variable XPOS : integer;
	   variable YPOS : integer;
	   variable DIMX : integer;
	   variable DIMY : integer;
	begin
		if(RESET_N ='0') then
			
		end if;
		if(rising_edge(CLOCK) and CLOCK'EVENT )then
			NEW_GAME <= '0';
			if((H_COUNT <= 640) and (V_COUNT<= 480)) then 
				COLOR <= COLOR_BACKGROUND;
				XPOS := MARGIN_L_BOARD1;
				YPOS := MARGIN_TOP_BOARD;
				DIMX := DIM_BOARD_X;
				DIMY := DIM_BOARD_Y;
				if((H_COUNT >= XPOS) and (H_COUNT <= ( XPOS + DIMX)) and (V_COUNT >= YPOS) and (V_COUNT <= (YPOS + DIMY))) then			
					COLOR <= board1.color;
						if(draw_sel(1) = '1') then 
								COLOR <= COLOR_BLACK;
						end if;
					XPOS := MARGIN_L_BOARD1 + MARGIN_CELL;
					YPOS := MARGIN_TOP_BOARD + MARGIN_CELL;
					DIMX := DIM_CELL;
					DIMY := DIM_CELL;
					for i in 0 to (BOARD_ROWS-1) loop
						if(row_count-1 >= i) then
							for j in 0 to (BOARD_COLUMNS-1) loop
							if(counter_sel_griglia -1 = j and row_count -1 = i) then 
								board1.rows(i).cells(j).color <= selected_color;
							end if;
								if((H_COUNT >= XPOS) and (H_COUNT <= ( XPOS + DIMX)) and (V_COUNT >= YPOS) and (V_COUNT <= (YPOS + DIMY))) then
									if(board1.rows(i).cells(j).color = COLOR_BLACK) then
									board1.rows(i).cells(j).color <=COLOR_RED;
									end if;									
									COLOR <= board1.rows(i).cells(j).color;
								end if;
								XPOS := XPOS + DIMX + MARGIN_CELL;
							end loop;								
						end if;
						XPOS := MARGIN_L_BOARD1 + MARGIN_CELL;
						YPOS := YPOS + DIMY + MARGIN_CELL;
				end loop;
				else
					XPOS := MARGIN_L_BOARD2;
					YPOS := MARGIN_TOP_BOARD;
					DIMX := DIM_BOARD_X;
					DIMY := DIM_BOARD_Y;
					if((H_COUNT >= XPOS) and (H_COUNT <= ( XPOS + DIMX)) and (V_COUNT >= YPOS) and (V_COUNT <= (YPOS + DIMY))) then			
						COLOR <= board2.color;
						XPOS := MARGIN_L_BOARD2 + MARGIN_CELL;
						YPOS := MARGIN_TOP_BOARD + MARGIN_CELL;
						DIMX := DIM_CELL;
						DIMY := DIM_CELL;
					for i in 0 to (BOARD_ROWS) loop
						if(row_count-2 >= i) then
							for j in 0 to (BOARD_COLUMNS-1) loop							
								if(CHECK='1') then									
									board2.rows(row_count-2).cells(j).color<=INSERT_CHECK(j);									
								end if;
								if(i<=7) then
								if((H_COUNT >= XPOS) and (H_COUNT <= ( XPOS + DIMX)) and (V_COUNT >= YPOS) and (V_COUNT <= (YPOS + DIMY))) then
									COLOR <= board2.rows(i).cells(j).color;
								end if;
								end if;
								XPOS := XPOS + DIMX + MARGIN_CELL;
							end loop;
						end if;
						XPOS := MARGIN_L_BOARD2 + MARGIN_CELL;
						YPOS := YPOS + DIMY + MARGIN_CELL;
				end loop;	
					else 
						XPOS := MARGIN_L_BOARD2 + DIM_BOARD_X + 40;
						YPOS := 80;
						DIMX := DIM_PALETTA;
						DIMY := DIM_PALETTA;
							for i in 0 to BOARD_ROWS-1 loop								
								if((H_COUNT >= XPOS) and (H_COUNT <= ( XPOS + DIMX)) and (V_COUNT >= YPOS) and (V_COUNT <= (YPOS + DIMY))) then			
									COLOR <= colors_pals(i);
								end if;					
								YPOS := YPOS + 40;
							end loop;
						if(draw_sel(0) = '1') then 
								COLOR <= COLOR_BLACK;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;

	
key0_press : process 
 begin 
	if(RESET_N='0')then
		counter_sel<= 1;
		ypos_sel <= 78;
		selected_color <= COLOR_RED;
	end if;
	 wait until KEY(0)='0' and KEY(0)'EVENT; 
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
 end process;
 
 key1_press : process 
 begin 
	if(RESET_N='0')then
		counter_sel_griglia<= 0;
		xpos_sel_griglia	<=52;
	end if;
	 wait until KEY(1)='0' and KEY(1)'EVENT;
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
 end process;
	
	key2_press : process 
		begin 
		if(RESET_N='0') then 
			row_count <= 1;
			ypos_sel_griglia 	<= 24;
			ENABLE_CHECK <='0';
		end if;
		wait until KEY(2)='0' and KEY(2)'EVENT;
			ENABLE_CHECK<='0';
			case row_count is 
				when 0 to 7 => 
					row_count <= row_count+1;
					ypos_sel_griglia <= ypos_sel_griglia + 54;
				when 8 =>
					row_count <= 9;
					ypos_sel_griglia <=ypos_sel_griglia;
				when 9 =>
					row_count <= 9;
					ypos_sel_griglia <=ypos_sel_griglia;
			end case;
			INSERT_ATTEMPT <= board1.rows(row_count-1);
			ENABLE_CHECK<= '1';
		end process;

end architecture;
	

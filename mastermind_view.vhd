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
		COLOR 			: out color_type;
		counter_sel     		: in  integer range 0 to 8;
		ypos_sel				: 	in integer range 0 to 1000;
		selected_color 	: 	in color_type;
		colors_pals			:	in colors_pal;
		counter_sel_griglia			: in integer range 0 to 4;
		row_count						: in integer range 0 to BOARD_ROWS+1;
		xpos_sel_griglia				: in integer range 0 to 1000;
		ypos_sel_griglia				: in integer range 0 to 1000;		
		NEW_GAME			: out std_logic:='1';
		USER_VICTORY	: in 	std_logic;
		NEW_SECRET_COD : in code;
		USER_LOSE 		: in std_logic;
		ATTEMPT			: out row;
		START 			: in std_logic;
		INSERT_CHECK   : in code;
		CHECK				: in std_logic;
		H_COUNT			: in integer range 0 to 1000;
		V_COUNT			: in integer range 0 to 500
	);
end entity;


architecture RTL of mastermind_view is
	signal board1 : board;
	signal board2 : board;	
	signal draw_sel			: std_logic_vector(1 downto 0);
	signal coloreSelettore 	: color_type;
	signal newgame : std_logic:='1';
	signal temp_tc : color_type;
	signal text_on : std_logic_vector(3 downto 0);
	signal col : color_type;
begin
		board1.color 			<= COLOR_BROWN;
		board2.color			<= COLOR_BROWN;
		
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

text_gen : entity work.text_generator
	port map(
		CLOCK => CLOCK,
		COLOR => col,
		H_COUNT => H_COUNT,
		V_COUNT => V_COUNT,
		TEXT_ON => text_on
	);
		
	drawBoard : process(CLOCK, RESET_N)
		variable XPOS : integer;
	   variable YPOS : integer;
	   variable DIMX : integer;
	   variable DIMY : integer;
	begin
		if(rising_edge(CLOCK) and CLOCK'EVENT )then
			if((H_COUNT <= 640) and (V_COUNT<= 480)) then
				COLOR <= COLOR_BACKGROUND;
				if(text_on="0100" and START = '0')then
					COLOR <= col;
				end if;
				if(text_on="0010" and START = '0')then
					COLOR <= col;
				end if;				
				if(START='1') then
					if(USER_LOSE ='0' and USER_VICTORY='0') then
						newgame <= '0';
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
								XPOS := MARGIN_L_BOARD2 + MARGIN_CELL;
								YPOS := YPOS + DIMY + MARGIN_CELL;
								end if;
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
					elsif(USER_LOSE='1' and USER_VICTORY='0') then
						if(text_on="0001")then
							COLOR <= col;							
						end if;
							XPOS := 200;
							YPOS := 275;
							DIMX := DIM_CELL;
							DIMY := DIM_CELL;
							for i in 0 to (BOARD_COLUMNS-1) loop
								if((H_COUNT >= XPOS) and (H_COUNT <= ( XPOS + DIMX)) and (V_COUNT >= YPOS) and (V_COUNT <= (YPOS + DIMY))) then
									COLOR <= NEW_SECRET_COD(i);
								end if;
								XPOS := XPOS + DIMX + MARGIN_CELL;
							end loop;
					elsif(USER_LOSE='0' and USER_VICTORY='1') then
						if(text_on="1000")then
							COLOR <= col;
						end if;
					elsif(USER_LOSE='1' and USER_VICTORY='1') then
						if(text_on="1000")then
							COLOR <= col;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;
	ATTEMPT <= BOARD1.rows(row_count-1);
	NEW_GAME <= newgame;
end architecture;
	

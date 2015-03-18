library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.vga_package.all;

entity dinamic_selectors is
	port
	(
		XPOS : in integer range 0 to 1000;
		YPOS : in integer range 0 to 1000;
		DIMX : in integer range 0 to 1000;
		DIMY : in integer range 0 to 1000;
		SPES : in integer range 0 to 1000;
		pixel_x : in integer range 0 to 1000;
		pixel_y : in integer range 0 to 500;
		number	: in integer range 0 to 2500;		
		color	: OUT STD_LOGIC_VECTOR(11 downto 0);
		-- segnale che indica alla view quando va disegnato il box
		drawBox : OUT STD_LOGIC := '0'
		
	);
end dinamic_selectors;


architecture box of dinamic_selectors is
	-- Coordinate finali del cubo sullo schermo
	signal MAX_X 		: integer range 0 to 1000 	:= XPOS + DIMX;
	signal MAX_Y 		: integer range 0 to 500 	:= YPOS + DIMY;
begin

	valueChange : process(number)
	begin
		case number is
			when 0 => 
				color <=	COLOR_BROWN;
			when 1 =>
				color <=COLOR_RED;
			when 2 =>
				color <=COLOR_ORANGE;
			when 3 =>
				color <=COLOR_GREEN;
			when 4 =>
				color <=COLOR_BLUE;
			when 5 =>
				color <=COLOR_YELLOW;
			when 6 =>
				color <=COLOR_CYAN;
			when 7 =>
				color <=COLOR_GREY;
			when 8 =>
				color <=COLOR_MAGENTA;
			when 9 =>
				color <= COLOR_BLACK;
			when others => 
				color 	<=	"000000000000";
		end case;
	end process valueChange;

	drawBox <= '1' 
		when 
			(pixel_x >= XPOS and pixel_x <= XPOS+SPES and pixel_y >= YPOS and pixel_y <= MAX_Y+SPES) or 
			(pixel_x >= XPOS and pixel_x <= MAX_X+SPES and pixel_y >= YPOS and pixel_y <= YPOS+SPES) or
			(pixel_x >= MAX_X and pixel_x <= MAX_X+SPES and pixel_y >= YPOS and pixel_y <= MAX_Y+SPES) or
			(pixel_x >= XPOS and pixel_x <= MAX_X+SPES and pixel_y >= MAX_Y and pixel_y <= MAX_Y+SPES)
		else
			'0';
end box;
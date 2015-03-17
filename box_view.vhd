library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.vga_package.all;

entity box_view is
	generic
	(
		XPOS : in NATURAL;
		YPOS : in NATURAL;
		SPES : in NATURAL;
		DIMX : in NATURAL;
		DIMY : in NATURAL
	);
	port
	(
		pixel_x : in integer range 0 to 1000;
		pixel_y : in integer range 0 to 500;
		number	: in integer range 0 to 2500;		
		color	: OUT STD_LOGIC_VECTOR(11 downto 0);
		-- segnale che indica alla view quando va disegnato il box
		drawBox : OUT STD_LOGIC := '0'
	);
end box_view;


architecture box of box_view is
	-- Coordinate finali del cubo sullo schermo
	constant MAX_X 		: integer range 0 to 1000 	:= XPOS + DIMX;
	constant MAX_Y 		: integer range 0 to 500 	:= YPOS + DIMY;
	constant SPESSORE 	: integer range 0 to 500   := SPES;
begin

	valueChange : process(number)
	begin
		case number is
			when 0 => 
				color 	<=	COLOR_BROWN;
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
			when others => 
				color 	<=	"000000000000";
		end case;
	end process valueChange;

	drawBox <= '1' 
		when 
			pixel_x >= XPOS and pixel_x <= MAX_X and pixel_y >= YPOS and pixel_y <= MAX_Y 
		else
			'0';
end box;
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.vga_package.all;

package mastermind_package is
	-- BOARD GIOCATORE
	constant BOARD_COLUMNS			: positive := 4;
	constant BOARD_ROWS				: positive := 8;
	constant DIM_CELL					: positive := 50;
	constant MARGIN_CELL 			: positive := 4;
	constant DIM_BOARD_X				: positive := 220;
	constant DIM_BOARD_Y				: positive := 436;
	constant MARGIN_TOP_BOARD	 	: positive := 22;
	constant MARGIN_L_BOARD1		: positive := 50;
	constant MARGIN_L_BOARD2		: positive := 320;
	constant DIM_PALETTA 			: positive := 20;


	--cell DECLARATIONS
	type cell is record
		color  	 	: color_type;
	end record;
	
	--row Declaration
	type cells is array (0 to BOARD_COLUMNS-1) of cell;
	
	type row is record 
		cells	:	cells;
	end record;
	
	type board_type is array(0 to BOARD_ROWS-1) of row;

	type board is record
		rows			: board_type;
		color			: color_type;
	end record;
	
	type colors_pal is array (0 to (BOARD_ROWS-1)) of color_type;
	
	type code is array (0 to (BOARD_COLUMNS-1)) of color_type;
	

end package;

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
		cells		:	cells;
		enable 	: std_logic;
	end record;
	
	type board_type is array(0 to BOARD_ROWS-1) of row;

	type board is record
		rows			: board_type;
		color			: color_type;
	end record;
	
	type colors_pal is array (0 to (BOARD_ROWS-1)) of color_type;
	
	type code is array (0 to (BOARD_COLUMNS-1)) of color_type;
	
	--COD Declarations
--	
--	
--	--PIECE1 DEFINITION
--	constant PIECE_RED : piece_type :=
--	(
--		peg		=> PEG_RED,
--		color		=> COLOR_RED
--	);
--	
--	constant PIECE_BLUE : piece_type :=
--	(
--		peg		=> PEG_BLUE,
--		color		=> COLOR_BLUE
--	);
--	
--	constant PIECE_ORANGE : piece_type :=
--	(
--		peg		=> PEG_ORANGE,
--		color		=> COLOR_ORANGE
--	);
--	
--	constant PIECE_GREEN : piece_type :=
--	(
--		peg		=> PEG_GREEN,
--		color		=> COLOR_GREEN
--	);
--	
--	constant PIECE_YELLOW : piece_type :=
--	(
--		peg		=> PEG_YELLOW,
--		color		=> COLOR_YELLOW
--	);
--	
--	constant PIECE_CYAN : piece_type :=
--	(
--		peg		=> PEG_CYAN,
--		color		=> COLOR_CYAN
--	);
--	
--	constant PIECE_GREY : piece_type :=
--	(
--		peg		=> PEG_GREY,
--		color		=> COLOR_GREY
--	);
--	
--	constant PIECE_MAGENTA : piece_type :=
--	(
--		peg		=> PEG_MAGENTA,
--		color		=> COLOR_MAGENTA
--	);	
--		
--	constant PIECE_BLACK : piece_type :=
--	(
--		peg		=> PEG_BLACK,
--		color		=> COLOR_BLACK
--	);
--	
--	constant PIECE_WHITE : piece_type :=
--	(
--		peg		=> PEG_WHITE,
--		color		=> COLOR_WHITE
--	);
end package;

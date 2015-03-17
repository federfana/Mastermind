library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.vga_package.all;

package mastermind_package is
	--BOARD GIOCATORE
	constant BOARD1_COLUMNS		: positive :=4;
	constant BOARD1_ROWS			: positive :=8;
	--BOARD VERIFICA
	constant BOARD2_COLUMNS		: positive :=4;
	constant BOARD2_ROWS			: positive :=8;
	
	--PIOLINI CODICI
	type peg_type is(PEG_RED, PEG_YELLOW, PEG_GREEN, PEG_CYAN, PEG_BLUE, PEG_ORANGE,PEG_GREY,PEG_MAGENTA,PEG_WHITE, PEG_BLACK);
	attribute enum_encoding 				: string;
	attribute enum_encoding of peg_type : type is "one-hot";
	
	--PIOLINI VERIFICA
	--type peg2_type is(PEG_WHITE, PEG_BLACK);
	--attribute enum2_encoding : string;
	--attribute enum2_encoding of peg2_type : type is "one-hot";
	
	--PEG1 DECLARATIONS
	type piece_type is record
		peg		: peg_type;
		color   	: color_type;
	end record;
	
	
	--BOARD1 Declaration
	type board1_cell_type is record 
		filled		:	std_logic;
		piece 		: 	piece_type;
	end record;
	
	type board1_cell_array is array(natural range <>, natural range <>) of board1_cell_type;
	
	type board1_type is record
		cells		:	board1_cell_array(0 to (BOARD1_ROWS-1),0 to (BOARD1_COLUMNS-1));
	end record;
	
	--BOARD2 Declaration
	type board2_cell_type is record 
		filled		:	std_logic;
		piece 		: 	piece_type;
	end record;
	
	type board2_cell_array is array(natural range <>, natural range <>) of board2_cell_type;
	
	type board2_type is record
		cells		:	board2_cell_array(0 to (BOARD2_ROWS-1),0 to (BOARD2_COLUMNS-1));
	end record;
	
	
	
	--COD Declarations
	type code is array (0 to (BOARD2_COLUMNS-1)) of piece_type;

	
	--PEG2 DECLARATIONS
	--type piece2_type is record
	--	peg2	: peg2_type;
	--color   : color_type;
	--end record;
	
	--PIECE1 DEFINITION
	constant PIECE_RED : piece_type :=
	(
		peg		=> PEG_RED,
		color		=> COLOR_RED
	);
	
	constant PIECE_BLUE : piece_type :=
	(
		peg		=> PEG_BLUE,
		color		=> COLOR_BLUE
	);
	
	constant PIECE_ORANGE : piece_type :=
	(
		peg		=> PEG_ORANGE,
		color		=> COLOR_ORANGE
	);
	
	constant PIECE_GREEN : piece_type :=
	(
		peg		=> PEG_GREEN,
		color		=> COLOR_GREEN
	);
	
	constant PIECE_YELLOW : piece_type :=
	(
		peg		=> PEG_YELLOW,
		color		=> COLOR_YELLOW
	);
	
	constant PIECE_CYAN : piece_type :=
	(
		peg		=> PEG_CYAN,
		color		=> COLOR_CYAN
	);
	
	constant PIECE_GREY : piece_type :=
	(
		peg		=> PEG_GREY,
		color		=> COLOR_GREY
	);
	
	constant PIECE_MAGENTA : piece_type :=
	(
		peg		=> PEG_MAGENTA,
		color		=> COLOR_MAGENTA
	);	
		
	constant PIECE_BLACK : piece_type :=
	(
		peg		=> PEG_BLACK,
		color		=> COLOR_BLACK
	);
	
	constant PIECE_WHITE : piece_type :=
	(
		peg		=> PEG_WHITE,
		color		=> COLOR_WHITE
	);
end package;

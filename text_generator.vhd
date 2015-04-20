library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.vga_package.all;
use work.mastermind_package.all;

entity text_generator is
   port
	(
		CLOCK 			: in std_logic;
		TEXT_ON			: out std_logic_vector(3 downto 0);
		COLOR				: out color_type;
		H_COUNT			: in integer range 0 to 1000;
		V_COUNT			: in integer range 0 to 500
	);
end entity;


architecture RTL of text_generator is
	signal pix_x , pix_y : unsigned(9 downto 0);
	signal rom_addr: std_logic_vector(10 downto 0);
	signal char_addr, char_addr_s,char_addr_l,char_addr_r, char_addr_o: std_logic_vector(6 downto 0);
	signal row_addr, row_addr_s,row_addr_l,row_addr_r, row_addr_o: std_logic_vector(3 downto 0);
	signal bit_addr, bit_addr_s,bit_addr_l, bit_addr_r, bit_addr_o : std_logic_vector(2 downto 0);
	signal font_word: std_logic_vector(7 downto 0);
	signal font_bit, score_on, logo_on, rule_on, over_on: std_logic;
	signal rule_rom_addr : unsigned(5 downto 0 ) ;
	type rule_rom_type is array ( 0 to 63) of std_logic_vector (6 downto 0 ) ;
	-- rule text ROM definition
	constant RULE_ROM: rule_rom_type :=
	(
		-- row 1
		"1001011", --K
		"0110011", --3	
		"0111010", --:
		"0000000",
		"1110011", --s
		"1110100", --t
		"1100001", --a
		"1110010", --r
		"1110100", --t
		"0000000", 
		"0000000", 
		"0000000", 
		"0000000",  
		"0000000", 
		"0000000",  
		"0000000",
		-- row 2 
		"1001011", --K
		"0110000", --0
		"0111010", --:
		"0000000", -- 
		"1110011", --s
		"1100101", --e
		"1101100", --l
		"1100101", --e
		"1100011", --c 
		"1110100", --t 
		"0000000", -- 
		"1100011", --c 
		"1101111", --o 
		"1101100", --l  
		"1101111", --o
		"1110010", --r
		-- row 3
		"1001011", --K
		"0110001", --1
		"0111010", --:
		"1110011", --s
		"1100101", --e
		"1101100", --l
		"1100101", --e
		"1100011", --c 
		"1110100", --t 
		"0000000", -- 
		"1100011", --c 
		"1100101", --e
		"1101100", --l  
		"1101100", --l
		"0000000", -- 
		"0000000", -- 
		-- row 4 
		"1001011", --K
		"0110010", --2
		"0111010", --:
		"0000000", -- 
		"1100011", --c  
		"1101111", --o
		"1101110", --n
		"1100110", --f
		"1101001", --i
		"1110010", --r
		"1101101", --m
		"0101110", --.
		"0000000",
		"0000000",
		"0000000",
		"0000000"
	);
begin
	pix_x <= unsigned(std_logic_vector(to_unsigned(H_COUNT, pix_x'LENGTH)));
	pix_y <= unsigned(std_logic_vector(to_unsigned(V_COUNT, pix_y'LENGTH)));
	
	-- instantiate font ROM
	font_unit: entity work.font_rom
		port map(
			CLOCK => clock,
			addr => rom_addr,
			data => font_word
		);
	
-----------------------------------------------------------------	
	-- score region
	--	-display score and ball at top left -- -text:"Score:DDBall:D"
	--	-scale to 16-by-32 font
-----------------------------------------------------------------
	score_on <=
	'1' when pix_y(9 downto 7 )=0 and(0<= pix_x(9 downto 6) and pix_x(9 downto 6)<=9) 
	else 
		'0';
		
	row_addr_s <= std_logic_vector (pix_y(6 downto 3));
	bit_addr_s <= std_logic_vector(pix_x(5 downto 3)); 
	with pix_x(9 downto 6) select
		char_addr_s <=
			"1011001" when "0000", -- Y
			"1101111" when "0001", -- o
			"1110101" when "0010", -- u  
			"0000000" when "0011", -- 
			"1010111" when "0100", -- W
			"1101001" when "0101", -- i 
			"1101110" when "0110", -- n 
			"0100001" when others; -- ! 
			
		--logo region:
		-- display logo "MASTERMIND" at top center
		-- used as background
		-- scale to 64-by-128 font
		
	logo_on <=
		'1' when pix_y(9 downto 7 )=2 and(0<= pix_x(9 downto 6) and pix_x(9 downto 6)<=9) 
	else 
		'0';
		
	row_addr_l <= std_logic_vector(pix_y(6 downto 3));
	bit_addr_l <= std_logic_vector (pix_x(5 downto 3)) ;
	with pix_x(9 downto 6) select
		char_addr_l <=
			"1001101" when "0000",-- M
			"1000001" when "0001",-- A
			"1010011" when "0010",-- S
			"1010100" when "0011",-- T
			"1000101" when "0100",-- E
			"1010010" when "0101",-- R
			"1001101" when "0110",-- M
			"1001001" when "0111",-- I
			"1001110" when "1000",-- N
			"1000100" when others; --D
	
	--rule region
	--
	rule_on <= '1' when pix_x(9 downto 7) = "010" and pix_y(9 downto 6)= "0010" 
		else '0';
	row_addr_r <= std_logic_vector(pix_y(3 downto 0)) ; 
	bit_addr_r <= std_logic_vector (pix_x ( 2 downto 0 ) ) ; 
	rule_rom_addr <= pix_y(5 downto 4) & pix_x(6 downto 3); 
	char_addr_r <= RULE_ROM(to_integer(rule_rom_addr));
	
	--GAME OVER
	over_on <=
		'1' when pix_y(9 downto 6)=3 and 5<= pix_x(9 downto 5) and pix_x(9 downto 5)<=13 	
		else
		'0';
	row_addr_o <= std_logic_vector (pix_y ( 5 downto 2 ));
	bit_addr_o <= std_logic_vector(pix_x(4 downto 2 ) ) ; 
	with pix_x(8 downto 5) select
		char_addr_o <=
			"1000111" when "0101", -- G x47 
			"1100001" when "0110", -- a x61 
			"1101101" when "0111", -- m x6d 
			"1100101" when "1000", -- e x65
			"0000000" when "1001", -- 
			"1001111" when "1010", -- 0 x4f 
			"1110110" when "1011", -- v x76 
			"1100101" when "1100", -- e x65 
			"1110010" when others; -- r x72
	
	-- mux for font ROM addresses and rgb
	process (score_on,logo_on,rule_on, pix_x, pix_y, font_bit, char_addr_s, char_addr_l, char_addr_r,char_addr_o, row_addr_s,row_addr_l,row_addr_r,row_addr_o,bit_addr_s,bit_addr_l,bit_addr_r,bit_addr_o)
	begin
	COLOR <= COLOR_BACKGROUND;
		if score_on='1' then 
			char_addr <= char_addr_s;
			row_addr <= row_addr_s;
			bit_addr <= bit_addr_s;
			if font_bit='1' then
				COLOR <= COLOR_ORANGE;
			end if;
		elsif rule_on= '1' then 
			char_addr <= char_addr_r; 
			row_addr <= row_addr_r;
			bit_addr <= bit_addr_r;
			if font_bit= '1' then
				COLOR <= COLOR_RED;
			end if;
		elsif logo_on='1' then 
			char_addr <= char_addr_l;
			row_addr <= row_addr_l; 
			bit_addr <= bit_addr_l; 
			if font_bit='1' then
				COLOR <= COLOR_BLUE;
			end if;
		else -- game over
			char_addr <= char_addr_o; 
			row_addr <= row_addr_o;
			bit_addr <= bit_addr_o;
			if font_bit='1' then
				COLOR <= COLOR_BLACK;
			end if;
		end if;
		
	end process;
	TEXT_ON <= score_on & logo_on & rule_on & over_on;
	-- font ROM interface
	rom_addr <= char_addr & row_addr;
	font_bit <= font_word(to_integer(unsigned(not bit_addr)));
end architecture;
	

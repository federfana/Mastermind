library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.mastermind_package.all;
use work.vga_package.all;


entity mastermind_view is
   port
	(
		CLOCK          : in  std_logic;
		RESET_N        : in  std_logic;
		VGA_R               : out std_logic_vector(3 downto 0);
		VGA_G               : out std_logic_vector(3 downto 0);
		VGA_B               : out std_logic_vector(3 downto 0);
		VGA_HS              : out std_logic;
		VGA_VS              : out std_logic;
		KEY                 : in  std_logic_vector(3 downto 0);
		LEDG				  		:out std_LOGIC_VECTOR(7 downto 0);
		--CONNECTION FOR THE CONTROLLER
		INSERT_ATTEMPT : out code;
		ENABLE_CHECK	: out std_logic;
		NEW_GAME			: out std_logic;
		USER_VICTORY	: in std_logic
		--CONNECTION FOR THE datatapath
		
		
	);
end entity;


architecture RTL of mastermind_view is
	shared variable h_cnt	: integer range 0 to 1000;
	shared variable v_cnt  	: integer range 0 to 500;
	signal boards					: std_logic_vector(1 downto 0);
	subtype c_b	is std_logic_vector(11 downto 0);
	type colorBoard is array (1 downto 0) of c_b;
	signal colorsBoards 		: colorBoard;
	signal paletta				: std_logic_vector(7 downto 0);
	type colorsPal is array (7 downto 0) of c_b;
	signal colori_paletta	: colorsPal;	
	signal draw_sel			: std_logic_vector(1 downto 0);
	type selettore is array (2 downto 0) of c_b;
	signal color_sel			: selettore;
	signal counter_sel            	: integer range 0 to 7 :=0; 
	signal ypos_sel 						: integer range 0 to 1000 := 98;
	signal counter_sel_griglia       : integer range 0 to 3 :=0; 
	signal ypos_sel_griglia 			: integer range 0 to 1000:= 24;
	signal xpos_sel_griglia 			: integer range 0 to 1000:=52;
	
	
begin

BOARD1: entity work.box_view
	generic map
	(
		XPOS => 50,
		YPOS => 22,
		DIMX => 220,
		DIMY => 436
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 0,
		drawbox => boards(0),
		color	=> colorsBoards(0)
	);
	
BOARD2: entity work.box_view
	generic map
	(
		XPOS => 320,
		YPOS => 22,
		DIMX => 220,
		DIMY => 436
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 0,
		drawbox => boards(1),
		color	=> colorsBoards(1)
	);
PALETTAROSSA: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 100,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 1,
		drawbox => paletta(0),
		color	=> colori_paletta(0)
	);
PALETTAARANCIO: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 130,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 2,
		drawbox => paletta(1),
		color	=> colori_paletta(1)
	);
PALETTAGREEN: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 160,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 3,
		drawbox => paletta(2),
		color	=> colori_paletta(2)
	);
PALETTABLUE: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 190,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 4,
		drawbox => paletta(3),
		color	=> colori_paletta(3)
	);
PALETTAYELLOW: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 220,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 5,
		drawbox => paletta(4),
		color	=> colori_paletta(4)
	);
PALETTACYAN: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 250,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 6,
		drawbox => paletta(5),
		color	=> colori_paletta(5)
	);
PALETTAGREY: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 280,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 7,
		drawbox => paletta(6),
		color	=> colori_paletta(6)
	);
PALETTAMAGENTA: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 310,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 8,
		drawbox => paletta(7),
		color	=> colori_paletta(7)
	);
	
SELEZIONATORE_COLORE: entity work.dinamic_selectors
	port map
	(
		XPOS => 558,
		YPOS => ypos_sel,
		SPES => 2,
		DIMX => 22,
		DIMY => 22,
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 10,
		drawbox => draw_sel(0),
		color	=> color_sel(0) 
);

SELEZIONATORE_GRIGLIA: entity work.dinamic_selectors
	port map
	(
		XPOS => xpos_sel_griglia,
		YPOS => ypos_sel_griglia,
		SPES => 2,
		DIMX => 52,
		DIMY => 52,
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 9,
		drawbox => draw_sel(1),
		color	=> color_sel(1)
);

--RIGA1_BOARD1 : entity work.righe_board
--port map
--(
--		XPOS => xpos_sel_griglia,
--		YPOS => ypos_sel_griglia,
--		SPES => 2,
--		DIMX => 52,
--		DIMY => 52,
--		pixel_x => h_cnt,
--		pixel_y => v_cnt,
--		number 	=> 9,
--		drawbox => draw_sel_griglia
--);
	
	

process	
	variable h_sync	: STD_LOGIC;
	variable v_sync	: STD_LOGIC;

-- Enable del video
	variable video_en		: STD_LOGIC; 
	variable horizontal_en	: STD_LOGIC;
	variable vertical_en	: STD_LOGIC;

	-- Segnali colori RGB a 4 bit
	variable red_signal		: std_logic_vector(3 downto 0); 
	variable green_signal	: std_logic_vector(3 downto 0);
	variable blue_signal		: std_logic_vector(3 downto 0);
	
	


begin

WAIT UNTIL(CLOCK'EVENT) AND (CLOCK = '1');
		

----------------- SFONDO DELLO SCHERMO ---------------------------
		if(v_cnt<=480 and h_cnt<=640) then
			red_signal:="1011";
			green_signal:="1011";
			blue_signal:="1011";
		end if;		
------------------ FINE SFONDO SCHERMO --------------------------- 
		-- RESET
		IF (RESET_N='0')  
			THEN
--			leds1 <= "0000000";
--			leds2 <= "0000000";
--			leds3 <= "0000000";
--			leds4 <= "0000000";			
		END IF;
		

	----- DISEGNO BOX --------
		if(boards(0)='1' or boards(1)='1') then
		red_signal(3 downto 0) 	:= colorsBoards(0)(11 downto 8); 		
		green_signal(3 downto 0):= colorsBoards(0)(7 downto 4);  
		blue_signal(3 downto 0) := colorsBoards(0)(3 downto 0);	
		end if;
		for i in 0 to 7 loop 
			if(paletta(i)='1') then 
				red_signal(3 downto 0) 	:= colori_paletta(i)(11 downto 8); 		
				green_signal(3 downto 0):= colori_paletta(i)(7 downto 4);  
				blue_signal(3 downto 0) := colori_paletta(i)(3 downto 0);	
			end if;
		end loop;
		
		for i in 0 to 1 loop 
			if(draw_sel(i)='1') then 
				red_signal(3 downto 0) 	:= color_sel(i)(11 downto 8); 		
				green_signal(3 downto 0):= color_sel(i)(7 downto 4);  
				blue_signal(3 downto 0) := color_sel(i)(3 downto 0);	
			end if;
		end loop;

	----- FINE DISEGNO BOX --------

		--Horizontal Sync
		
		--Reset Horizontal Counter	
		-- (resettato al valore 799, anzich� 640, per rispettare i tempi di Front Porch)
		-- Infatti (799-639)/25000000 = 3.6 us = 3.8(a)+1.9(b)+0.6(d)	
		IF (h_cnt = 799) 
			THEN
				h_cnt := 0;
			ELSE
				h_cnt := h_cnt + 1;
		END IF;
	--Generazione segnale hsync (rispettando la specifica temporale di avere un ritardo "a" di 3.8 us fra un segnale e l'altro)
	--Infatti (659-639)/25000000 = 0.6 us, ossia il tempo di Front Porch "d". (755-659)/25000000 = 3.8, ossia il tempo "a"
	IF (h_cnt <= 755) AND (h_cnt >= 659) THEN
		h_sync := '0';
	ELSE
		h_sync := '1';
	END IF;
	
	--Vertical Sync
	--Reset Vertical Counter. Non ci si ferma a 480 per rispettare le specifiche temporali
	--Infatti (524-479)= 45 = 2(a)+33(b)+10(d) righe
	IF (v_cnt >= 524) AND (h_cnt >= 699) 
		THEN
		v_cnt := 0;
	ELSIF (h_cnt = 699) 
		THEN
		v_cnt := v_cnt + 1;
	END IF;
	
	--Generazione segnale vsync (rispettando la specifica temporale di avere un ritardo "a" di due volte il tempo di riga us fra un segnale e l'altro)
	IF (v_cnt = 490 OR v_cnt = 491) 
	THEN
		v_sync := '0';	
	ELSE
		v_sync := '1';
	END IF;
	
	--Generazione Horizontal Data Enable (dati di riga validi, ossia nel range orizzontale 0-639)
	IF (h_cnt <= 639) 
	THEN
		horizontal_en := '1';
	ELSE
		horizontal_en := '0';
	END IF;
	
	--Generazione Vertical Data Enable (dati di riga validi, ossia nel range verticale 0-479)
	IF (v_cnt <= 479) 
	THEN
		vertical_en := '1';
	ELSE
		vertical_en := '0';
	END IF;
	
	video_en := horizontal_en AND vertical_en;

	-- Assegnamento segnali fisici a VGA
	VGA_R(0)		<= red_signal(0) AND video_en;
	VGA_G(0)  		<= green_signal(0) AND video_en;
	VGA_B(0)		<= blue_signal(0) AND video_en;
	VGA_R(1)		<= red_signal(1) AND video_en;
	VGA_G(1)  		<= green_signal(1) AND video_en;
	VGA_B(1)		<= blue_signal(1) AND video_en;
	VGA_R(2)		<= red_signal(2) AND video_en;
	VGA_G(2)  		<= green_signal(2) AND video_en;
	VGA_B(2)		<= blue_signal(2) AND video_en;
	VGA_R(3)		<= red_signal(3) AND video_en;
	VGA_G(3) 		<= green_signal(3) AND video_en;
	VGA_B(3)		<= blue_signal(3) AND video_en;
	VGA_HS			<= h_sync;
	VGA_VS			<= v_sync;

end process; 

 key0_press : process 
 begin 
	if(RESET_N='0')then
		counter_sel<= 0;
		ypos_sel <= 98;
	end if;
	 wait until KEY(0)='0' and KEY(0)'EVENT; 
		case counter_sel is
			when 0 => 
				ypos_sel <= 98;
				counter_sel <= counter_sel + 1;
			when 1 =>
				ypos_sel <= 128;
				counter_sel <= counter_sel + 1;
			when 2 =>
				ypos_sel <= 158;
				counter_sel <= counter_sel + 1;
			when 3 =>
				ypos_sel <= 188;
				counter_sel <= counter_sel + 1;
			when 4 =>
				ypos_sel <= 218;
				counter_sel <= counter_sel + 1;
			when 5 =>
				ypos_sel <= 248;
				counter_sel <= counter_sel + 1;
			when 6 =>
				ypos_sel <= 278;
				counter_sel <= counter_sel + 1;
			when 7 =>
				ypos_sel <= 308;
				counter_sel <= 0;
		end case;
 end process;
 
 key1_press : process 
 begin 
	if(RESET_N='0')then
		counter_sel_griglia<= 0;
		ypos_sel_griglia 	<= 24;
		xpos_sel_griglia	<=52;
	end if;
	 wait until KEY(1)='0' and KEY(1)'EVENT; 
		case counter_sel_griglia is
			when 0 => 
				xpos_sel_griglia <= 52;
				counter_sel_griglia <= counter_sel_griglia + 1;
			when 1 =>
				xpos_sel_griglia <= 104;
				counter_sel_griglia <= counter_sel_griglia + 1;
			when 2 =>
				xpos_sel_griglia <= 158;
				counter_sel_griglia <= counter_sel_griglia + 1;
			when 3 =>
				xpos_sel_griglia <= 212;
				counter_sel_griglia <= 0;
		end case;
 end process;

end architecture;
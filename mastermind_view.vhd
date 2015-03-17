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
		COUNT 					: inout integer range 0 to 7; 
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
	signal b1					: std_logic;
	signal colorB1				: STD_LOGIC_VECTOR(11 downto 0);
	signal b2					: std_logic;
	signal colorB2				: STD_LOGIC_VECTOR(11 downto 0);
	signal palR					: std_logic;
	signal colorR				: STD_LOGIC_VECTOR(11 downto 0);
	signal palO					: std_logic;
	signal colorO				: STD_LOGIC_VECTOR(11 downto 0);
	signal palG					: std_logic;
	signal colorG				: STD_LOGIC_VECTOR(11 downto 0);
	signal palB					: std_logic;
	signal colorB				: STD_LOGIC_VECTOR(11 downto 0);
	signal palY					: std_logic;
	signal colorY				: STD_LOGIC_VECTOR(11 downto 0);
	signal palC					: std_logic;
	signal colorC				: STD_LOGIC_VECTOR(11 downto 0);
	signal palGR				: std_logic;
	signal colorGR				: STD_LOGIC_VECTOR(11 downto 0);
	signal palM					: std_logic;
	signal colorM				: STD_LOGIC_VECTOR(11 downto 0);
	signal sel					: std_logic;
	signal selez				: STD_LOGIC_VECTOR(11 downto 0);
	signal cnt            : integer range 0 to 7 :=0;
	signal xpos : integer range 0 to 1000 := 558;
	signal ypos : integer range 0 to 1000 := 98;
	signal dimX : integer range 0 to 1000;
	signal dimY : integer range 0 to 1000;
	signal number : integer range 0 to 1000;
begin

BOARD1: entity work.box_view
	generic map
	(
		XPOS => 50,
		YPOS => 22,
		SPES => 0,
		DIMX => 220,
		DIMY => 436
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 0,
		drawbox => b1,
		color	=> colorB1
	);
	
BOARD2: entity work.box_view
	generic map
	(
		XPOS => 320,
		YPOS => 22,
		SPES => 0,
		DIMX => 220,
		DIMY => 436
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 0,
		drawbox => b2,
		color	=> colorB2
	);
PALETTAROSSA: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 100,
		SPES => 0,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 1,
		drawbox => palR,
		color	=> colorR
	);
PALETTAARANCIO: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 130,
		SPES => 0,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 2,
		drawbox => palO,
		color	=> colorO
	);
PALETTAGREEN: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 160,
		SPES => 0,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 3,
		drawbox => palG,
		color	=> colorG
	);
PALETTABLUE: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 190,
		SPES => 0,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 4,
		drawbox => palB,
		color	=> colorB
	);
PALETTAYELLOW: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 220,
		SPES => 0,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 5,
		drawbox => palY,
		color	=> colorY
	);
PALETTACYAN: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 250,
		SPES => 0,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 6,
		drawbox => palC,
		color	=> colorC
	);
PALETTAGREY: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 280,
		SPES => 0,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 7,
		drawbox => palGR,
		color	=> colorGR
	);
PALETTAMAGENTA: entity work.box_view
 generic map
	(
		XPOS => 560,
		YPOS => 310,
		SPES => 0,
		DIMX => 20,
		DIMY => 20
	)
	port map
	(
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 8,
		drawbox => palM,
		color	=> colorM
	);
	
SELEZIONATORE: entity work.dinamic_selectors
	port map
	(
		XPOS => xpos,
		YPOS => ypos,
		SPES => 2,
		DIMX => 2,
		DIMY => 2,
		pixel_x => h_cnt,
		pixel_y => v_cnt,
		number 	=> 9,
		drawbox => sel,
		color	=> selez 
);
	
	

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
		if(b1='1' or b2='1') then
		red_signal(3 downto 0) 	:= colorB1(11 downto 8); 		
		green_signal(3 downto 0):= colorB1(7 downto 4);  
		blue_signal(3 downto 0) := colorB1(3 downto 0);	
		end if;
		if(palR='1') then
				red_signal(3 downto 0) 	:= colorR(11 downto 8); 		
				green_signal(3 downto 0):= colorR(7 downto 4);  
				blue_signal(3 downto 0) := colorR(3 downto 0);	
		end if;
		if(palO='1') then
				red_signal(3 downto 0) 	:= colorO(11 downto 8); 		
				green_signal(3 downto 0):= colorO(7 downto 4);  
				blue_signal(3 downto 0) := colorO(3 downto 0);	
		end if;
		if(palG='1') then
				red_signal(3 downto 0) 	:= colorG(11 downto 8); 		
				green_signal(3 downto 0):= colorG(7 downto 4);  
				blue_signal(3 downto 0) := colorG(3 downto 0);	
		end if;
		if(palB='1') then
				red_signal(3 downto 0) 	:= colorB(11 downto 8); 		
				green_signal(3 downto 0):= colorB(7 downto 4);  
				blue_signal(3 downto 0) := colorB(3 downto 0);	
		end if;
		if(palY='1') then
				red_signal(3 downto 0) 	:= colorY(11 downto 8); 		
				green_signal(3 downto 0):= colorY(7 downto 4);  
				blue_signal(3 downto 0) := colorY(3 downto 0);	
		end if;
		if(palC='1') then
				red_signal(3 downto 0) 	:= colorC(11 downto 8); 		
				green_signal(3 downto 0):= colorC(7 downto 4);  
				blue_signal(3 downto 0) := colorC(3 downto 0);	
		end if;
		if(palGR='1') then
				red_signal(3 downto 0) 	:= colorGR(11 downto 8); 		
				green_signal(3 downto 0):= colorGR(7 downto 4);  
				blue_signal(3 downto 0) := colorGR(3 downto 0);	
		end if;
		if(palM='1') then
				red_signal(3 downto 0) 	:= colorM(11 downto 8); 		
				green_signal(3 downto 0):= colorM(7 downto 4);  
				blue_signal(3 downto 0) := colorM(3 downto 0);	
		end if;
		
		
		if(sel='1') then
				red_signal(3 downto 0)  := selez(11 downto 8); 		
				green_signal(3 downto 0)  := selez(7 downto 4);  
				blue_signal(3 downto 0)  := selez(3 downto 0);
		end if;
		

	----- FINE DISEGNO BOX --------
--gridOn <= '1' when ((unsigned(pixel_y) > 40 and unsigned(pixel_y) <= 440) and (unsigned(pixel_x) > 120 and unsigned(pixel_x) <=520)) 
	--else '0';

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

 key_press : process 
 begin 
	if(RESET_N='0')then
		cnt<= 0;
		xpos <= 558;
		ypos <= 98;
	end if;
	 wait until KEY(0)='0' and KEY(0)'EVENT; 
		case COUNT is
			when 0 => 
				xpos <= 558;
				ypos <= 98;
				cnt <= cnt + 1;
			when 1 =>
				xpos <= 558;
				ypos <= 128;
				cnt <= cnt + 1;
			when 2 =>
				xpos <= 558;
				ypos <= 158;
				cnt <= cnt + 1;
			when 3 =>
				xpos <= 558;
				ypos <= 188;
				cnt <= cnt + 1;
			when 4 =>
				xpos <= 558;
				ypos <= 218;
				cnt <= cnt + 1;
			when 5 =>
				xpos <= 558;
				ypos <= 248;
				cnt <= cnt + 1;
			when 6 =>
				xpos <= 558;
				ypos <= 278;
				cnt <= cnt + 1;
			when 7 =>
				xpos <= 558;
				ypos <= 308;
				cnt <= 0;
		end case;
 end process;
 
COUNT <= cnt;

	
end architecture;
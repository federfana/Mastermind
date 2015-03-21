library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.vga_package.all;


entity vga_controller is
   port
	(
		CLOCK          		: in  std_logic;
		RESET_N					: in  std_logic;
		VGA_R						: out std_logic_vector(3 downto 0);
		VGA_G						: out std_logic_vector(3 downto 0);
		VGA_B						: out std_logic_vector(3 downto 0);
		VGA_HS					: out std_logic;
		VGA_VS					: out std_logic;
		COLOR 					: in color_type;
		H_COUNT					: out integer range 0 to 1000;
		V_COUNT              : out integer range 0 to 500
	);
end entity;

architecture RTL of vga_controller is
	shared variable h_cnt	: integer range 0 to 1000;
	shared variable v_cnt  	: integer range 0 to 500;
	signal h_sync				: STD_LOGIC;
	signal v_sync				: STD_LOGIC;
	-- Enable del video
	signal video_en			: STD_LOGIC; 
	signal horizontal_en		: STD_LOGIC;
	signal vertical_en		: STD_LOGIC;
	-- Segnali colori RGB a 4 bit
	signal red_signal			: std_logic_vector(3 downto 0); 
	signal green_signal		: std_logic_vector(3 downto 0);
	signal blue_signal		: std_logic_vector(3 downto 0);

begin 
	H_V_Signal : process(CLOCK	)
		begin
		--	 wait until CLOCK='1' and CLOCK'EVENT; 
			if(rising_edge(CLOCK) and  CLOCK'EVENT)then
				--Horizontal Sync
				--Reset Horizontal Counter	
				-- (resettato al valore 799, anziche' 640, per rispettare i tempi di Front Porch)
				-- Infatti (799-639)/25000000 = 3.6 us = 3.8(a)+1.9(b)+0.6(d)	
				IF (h_cnt = 799) THEN
						h_cnt := 0;
					ELSE
						h_cnt := h_cnt + 1;
				END IF;
			--Generazione segnale hsync (rispettando la specifica temporale di avere un ritardo "a" di 3.8 us fra un segnale e l'altro)
			--Infatti (659-639)/25000000 = 0.6 us, ossia il tempo di Front Porch "d". (755-659)/25000000 = 3.8, ossia il tempo "a"
				IF (h_cnt <= 755) AND (h_cnt >= 659) THEN
					h_sync <= '0';
				ELSE
					h_sync <= '1';
				END IF;
			--Vertical Sync
			--Reset Vertical Counter. Non ci si ferma a 480 per rispettare le specifiche temporali
			--Infatti (524-479)= 45 = 2(a)+33(b)+10(d) righe
				IF (v_cnt >= 524) AND (h_cnt >= 699) THEN
					v_cnt := 0;
				ELSIF (h_cnt = 699) 
					THEN
					v_cnt := v_cnt + 1;
				END IF;
			--Generazione segnale vsync (rispettando la specifica temporale di avere un ritardo "a" di due volte il tempo di riga us fra un segnale e l'altro)
				IF (v_cnt = 490 OR v_cnt = 491) THEN
					v_sync <= '0';	
				ELSE
					v_sync <= '1';
				END IF;
			--Generazione Horizontal Data Enable (dati di riga validi, ossia nel range orizzontale 0-639)
				IF (h_cnt <= 639) THEN
					horizontal_en <= '1';
				ELSE
					horizontal_en <= '0';
				END IF;
				--Generazione Vertical Data Enable (dati di riga validi, ossia nel range verticale 0-479)
				IF (v_cnt <= 479) 
				THEN
					vertical_en <= '1';
				ELSE
					vertical_en <= '0';
				END IF;
			
			red_signal<=COLOR(11 downto 8);
			green_signal<=COLOR(7 downto 4);
			blue_signal<=COLOR(3 downto 0);
			video_en <= horizontal_en AND vertical_en;
			-- Assegnamento segnali fisici a VGA
			VGA_R(0)			<= red_signal(0) AND video_en;
			VGA_G(0)  		<= green_signal(0) AND video_en;
			VGA_B(0)			<= blue_signal(0) AND video_en;
			VGA_R(1)			<= red_signal(1) AND video_en;
			VGA_G(1)  		<= green_signal(1) AND video_en;
			VGA_B(1)			<= blue_signal(1) AND video_en;
			VGA_R(2)			<= red_signal(2) AND video_en;
			VGA_G(2)  		<= green_signal(2) AND video_en;
			VGA_B(2)			<= blue_signal(2) AND video_en;
			VGA_R(3)			<= red_signal(3) AND video_en;
			VGA_G(3) 		<= green_signal(3) AND video_en;
			VGA_B(3)			<= blue_signal(3) AND video_en;
			VGA_HS			<= h_sync;
			VGA_VS			<= v_sync;
			H_COUNT			<= h_cnt;
			V_COUNT			<= v_cnt;
		end if;
	end process;
end architecture;

---------------------------------------------------------------------------------
--Nik Taormina
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


library UNISIM;
use UNISIM.VComponents.all;

entity atlys_lab_top_level is
    port (
             clk        : in  std_logic;
             reset      : in  std_logic;
             serial_in  : in  std_logic;
             serial_out : out std_logic;
				 switch     : in  std_logic_vector(7 downto 0);
             led        : out std_logic_vector(7 downto 0)
         );
end atlys_lab_top_level;

architecture Behavioral of atlys_lab_top_level is

	COMPONENT clk_to_baud
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		baud_16x_en : OUT std_logic
		);
	END COMPONENT;



  component kcpsm6 
    generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                    interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
             scratch_pad_memory_size : integer := 64);
    port (                   address : out std_logic_vector(11 downto 0);
                         instruction : in std_logic_vector(17 downto 0);
                         bram_enable : out std_logic;
                             in_port : in std_logic_vector(7 downto 0);
                            out_port : out std_logic_vector(7 downto 0);
                             port_id : out std_logic_vector(7 downto 0);
                        write_strobe : out std_logic;
                      k_write_strobe : out std_logic;
                         read_strobe : out std_logic;
                           interrupt : in std_logic;
                       interrupt_ack : out std_logic;
                               sleep : in std_logic;
                               reset : in std_logic;
                                 clk : in std_logic);
  end component;



-- Development Program Memory


  component Taormina
    generic(             C_FAMILY : string := "S6"; 
                C_RAM_SIZE_KWORDS : integer := 1;
             C_JTAG_LOADER_ENABLE : integer := 0);
    Port (      address : in std_logic_vector(11 downto 0);
            instruction : out std_logic_vector(17 downto 0);
                 enable : in std_logic;
                    rdl : out std_logic;                    
                    clk : in std_logic);
  end component;

--
-- UART Transmitter with integral 16 byte FIFO buffer
--

  component uart_tx6 
    Port (             data_in : in std_logic_vector(7 downto 0);
                  en_16_x_baud : in std_logic;
                    serial_out : out std_logic;
                  buffer_write : in std_logic;
           buffer_data_present : out std_logic;
              buffer_half_full : out std_logic;
                   buffer_full : out std_logic;
                  buffer_reset : in std_logic;
                           clk : in std_logic);
  end component;

--
-- UART Receiver with integral 16 byte FIFO buffer
--

  component uart_rx6 
    Port (           serial_in : in std_logic;
                  en_16_x_baud : in std_logic;
                      data_out : out std_logic_vector(7 downto 0);
                   buffer_read : in std_logic;
           buffer_data_present : out std_logic;
              buffer_half_full : out std_logic;
                   buffer_full : out std_logic;
                  buffer_reset : in std_logic;
                           clk : in std_logic);
  end component;

	COMPONENT nibble_to_ascii
	PORT(
		nibble : IN std_logic_vector(3 downto 0);          
		ascii : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
--
--
-------------------------------------------------------------------------------------------
--
-- Signals
--
-------------------------------------------------------------------------------------------
--
--
-- Signals used to connect KCPSM6
--
signal              address : std_logic_vector(11 downto 0);
signal          instruction : std_logic_vector(17 downto 0);
signal          bram_enable : std_logic;
signal              in_port : std_logic_vector(7 downto 0);
signal             out_port : std_logic_vector(7 downto 0);
signal              port_id : std_logic_vector(7 downto 0);
signal         write_strobe : std_logic;
signal       k_write_strobe : std_logic;
signal          read_strobe : std_logic;
signal            interrupt : std_logic;
signal        interrupt_ack : std_logic;
signal         kcpsm6_sleep : std_logic;
signal         kcpsm6_reset : std_logic;
signal                  rdl : std_logic;
--
-- Signals used to connect UART_TX6
--
signal      uart_tx_data_in : std_logic_vector(7 downto 0);
signal     write_to_uart_tx : std_logic;
signal uart_tx_data_present : std_logic;
signal    uart_tx_half_full : std_logic;
signal         uart_tx_full : std_logic;
signal         uart_tx_reset : std_logic;
--
-- Signals used to connect UART_RX6
--
signal     uart_rx_data_out : std_logic_vector(7 downto 0);
signal    read_from_uart_rx : std_logic;
signal uart_rx_data_present : std_logic;
signal    uart_rx_half_full : std_logic;
signal         uart_rx_full : std_logic;
signal        uart_rx_reset : std_logic;
--
-- Signals used to define baud rate
--

signal	asciiMS, asciiLS, switchMS, switchLS : std_logic_vector(7 downto 0);
signal         en_16_x_baud : std_logic ;
--
--

-------------------------------------------------------------------------------------------
--
-- Start of circuit description
--
-------------------------------------------------------------------------------------------
--
begin

  --
  -----------------------------------------------------------------------------------------
  -- Instantiate KCPSM6 and connect to program ROM
  -----------------------------------------------------------------------------------------
  --
  -- The generics can be defined as required. In this case the 'hwbuild' value is used to 
  -- define a version using the ASCII code for the desired letter and the interrupt vector
  -- has been set to 3C0 to provide 64 instructions for an Interrupt Service Routine (ISR)
  -- before reaching the end of a 1K memory 
  -- 
  --

  processor: kcpsm6
    generic map (                 hwbuild => X"41",    -- 41 hex is ASCII character "A"
                         interrupt_vector => X"3C0",   
                  scratch_pad_memory_size => 64)
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => reset,
                       clk => clk);
 
interrupt <= interrupt_ack;

 


  kcpsm6_sleep <= '0';  -- Always '0'


  --
  -- Development Program Memory 
  --   JTAG Loader enabled for rapid code development. 
  --

  program_rom:Taormina
    generic map(             C_FAMILY => "S6", 
                    C_RAM_SIZE_KWORDS => 2,
                 C_JTAG_LOADER_ENABLE => 1)
    port map(      address => address,      
               instruction => instruction,
                    enable => bram_enable,
                       rdl => rdl,
                       clk => clk);


	Inst_clk_to_baud: clk_to_baud PORT MAP(
		clk => clk,
		reset => reset,
		baud_16x_en => en_16_x_baud
	);


  

  tx: uart_tx6 
  port map (              data_in => uart_rx_data_out,
                     en_16_x_baud => en_16_x_baud,
                       serial_out => serial_out,
                     buffer_write => uart_rx_data_present,
              buffer_data_present => uart_tx_data_present,
                 buffer_half_full => open,
                      buffer_full => open,
                     buffer_reset => reset,              
                              clk => clk);



  
  rx: uart_rx6 
  port map (            serial_in => serial_in,
                     en_16_x_baud => en_16_x_baud,
                         data_out => uart_rx_data_out,
                      buffer_read => uart_tx_data_present,
              buffer_data_present => uart_rx_data_present,
                 buffer_half_full => open,
                      buffer_full => open,
                     buffer_reset => reset,              
                              clk => clk);


--	Inst_nibble_to_ascii_1: nibble_to_ascii PORT MAP(
--		nibble => switch(7 downto 4),
--		ascii => switchMS
--	);
--	
--		Inst_nibble_to_ascii_2: nibble_to_ascii PORT MAP(
--		nibble => switch(3 downto 0),
--		ascii => switchLS
--	);
--
-- 
--in_port <= uart_rx_data_out when port_id = x"05" else
--           switchLS when port_id = x"03" else
--			  switchMS when port_id = x"02" else
--			  "0000000" & uart_rx_data_present when port_id =x"01" else
--			  (others=> '0');
--
--write_to_uart_tx  <= '1' when (write_strobe = '1') and (port_id = x"04")
--                     else '0';                     
--
--read_from_uart_rx  <= '1' when (read_strobe = '1') and (port_id = x"05")
--                      else '0';
--  
--uart_tx_data_in <= out_port when port_id = x"04" else
--						 (others=>'0');
--

--  
end Behavioral;




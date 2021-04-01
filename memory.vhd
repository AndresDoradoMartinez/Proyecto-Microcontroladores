library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is port(
	address, data_in, port_in_00, 
	port_in_01, port_in_02						:	in std_logic_vector(7 downto 0);
	clock, writen, reset							:	in std_logic;
	
	data_out, port_out_00, 
	port_out_01, port_out_02					:	out std_logic_vector(7 downto 0));
end entity;

architecture memo of memory is
	signal rom_data_out, rw_data_out: std_logic_vector(7 downto 0);
	
	component rom_128x8_sync
		port(	address	: in std_logic_vector(7 downto 0);
				clock		: in std_logic;
				data_out	: out std_logic_vector(7 downto 0));
	end component;
	
	component rw_96x8_sync
		port(	address, data_in	: in std_logic_vector(7 downto 0);
				clock, writen	 	: in std_logic;
				data_out				: out std_logic_vector(7 downto 0));
	end component;
	
	component output_ports
		port(	address, data_in								: in std_logic_vector(7 downto 0);
				clock, writen, reset						 	: in std_logic;
				port_out_00, port_out_01, port_out_02	: out std_logic_vector(7 downto 0));
	end component;
begin
	U1	:	rom_128x8_sync port map (address, clock, rom_data_out);
	U2	:	rw_96x8_sync port map (address, data_in, clock, writen, rw_data_out);
	U3	:	output_ports port map (address, data_in, clock, writen, reset, port_out_00, port_out_01, port_out_02);
	
	MUX1 : process (address, rom_data_out, rw_data_out,
		port_in_00, port_in_01, port_in_02)
--		port_in_04, port_in_05, port_in_06, port_in_07,
--		port_in_08, port_in_09, port_in_10, port_in_11,
--		port_in_12, port_in_13, port_in_14, port_in_15)

	begin
		if ( (to_integer(unsigned(address)) >= 0) and
		(to_integer(unsigned(address)) <= 127)) then data_out <= rom_data_out;
		elsif ( (to_integer(unsigned(address)) >= 128) and
		(to_integer(unsigned(address)) <= 223)) then data_out <= rw_data_out;
		elsif (address = x"F0") then data_out <= port_in_00;
		elsif (address = x"F1") then data_out <= port_in_01;
		elsif (address = x"F2") then data_out <= port_in_02;
--		elsif (address = x"F3") then data_out <= port_in_03;
--		elsif (address = x"F4") then data_out <= port_in_04;
--		elsif (address = x"F5") then data_out <= port_in_05;
--		elsif (address = x"F6") then data_out <= port_in_06;
--		elsif (address = x"F7") then data_out <= port_in_07;
--		elsif (address = x"F8") then data_out <= port_in_08;
--		elsif (address = x"F9") then data_out <= port_in_09;
--		elsif (address = x"FA") then data_out <= port_in_10;
--		elsif (address = x"FB") then data_out <= port_in_11;
--		elsif (address = x"FC") then data_out <= port_in_12;
--		elsif (address = x"FD") then data_out <= port_in_13;
--		elsif (address = x"FE") then data_out <= port_in_14;
--		elsif (address = x"FF") then data_out <= port_in_15;
		else data_out <= x"00";
		end if;
	end process;
end architecture;
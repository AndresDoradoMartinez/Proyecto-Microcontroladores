library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity output_ports is port(
	address, data_in				:	in std_logic_vector(7 downto 0);
	clock,writen, reset			:	in std_logic;
	port_out_00, port_out_01, port_out_02	:	out std_logic_vector(7 downto 0));
end entity;

architecture OUTPorts of output_ports is
begin
	-- port_out_00 description : ADDRESS x"E0"
	U3 : process (clock, reset)
	begin
		if (reset = '0') then
			port_out_00 <= x"00";
		elsif (clock'event and clock='1') then
			if (address = x"E0" and writen = '1') then
				port_out_00 <= data_in;
			end if;
		end if;
	end process;
	-- port_out_01 description : ADDRESS x"E1"
	U4 : process (clock, reset)
	begin
		if (reset = '0') then
			port_out_01 <= x"00";
		elsif (clock'event and clock='1') then
			if (address = x"E1" and writen = '1') then
				port_out_01 <=	data_in;
			end if;
		end if;
	end process;
	-- port_out_02 description : ADDRESS x"E2"
	U5 : process (clock, reset)
	begin
		if (reset = '0') then
			port_out_02 <= x"00";
		elsif (clock'event and clock='1') then
			if (address = x"E2" and writen = '1') then
				port_out_02 <=	data_in;
			end if;
		end if;
	end process;
--	-- port_out_03 description : ADDRESS x"E3"
--	U6 : process (clock, reset)
--	begin
--		if (reset = '0') then
--			port_out_03 <= x"00";
--		elsif (clock'event and clock='1') then
--			if (address = x"E3" and writen = '1') then
--				port_out_03 <=	data_in;
--			end if;
--		end if;
--	end process;
end architecture;
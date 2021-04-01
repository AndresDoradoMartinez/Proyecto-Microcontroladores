library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit is port(
	IR	: in std_logic_vector(7 downto 0);
	CCR_Result	: in std_logic_vector(3 downto 0);
	clock, reset	: in std_logic;
	
	Bus1_Sel, Bus2_Sel	: out std_logic_vector(1 downto 0);
	ALU_Sel	: out std_logic_vector(2 downto 0);
	IR_Load, MAR_Load, PC_Load, PC_Inc,
		A_Load, B_Load, CCR_Load, writen: out std_logic);
end entity;

architecture CU_Arch of control_unit is
	type state_type is
	(S_FETCH_0, S_FETCH_1, S_FETCH_2,
		S_DECODE_3,
		S_LDA_IMM_4, S_LDA_IMM_5, S_LDA_IMM_6,
		S_LDA_DIR_4, S_LDA_DIR_5, S_LDA_DIR_6, S_LDA_DIR_7, S_LDA_DIR_8,
		S_LDB_IMM_4, S_LDB_IMM_5, S_LDB_IMM_6,
		S_LDB_DIR_4, S_LDB_DIR_5, S_LDB_DIR_6, S_LDB_DIR_7, S_LDB_DIR_8,
		S_STA_DIR_4, S_STA_DIR_5, S_STA_DIR_6, S_STA_DIR_7,
		S_STB_DIR_4, S_STB_DIR_5, S_STB_DIR_6, S_STB_DIR_7,
		S_ADD_AB_4,
		S_BRA_4, S_BRA_5, S_BRA_6,
		S_BEQ_4, S_BEQ_5, S_BEQ_6, S_BEQ_7);
	signal current_state, next_state : state_type;
	signal LDA_IMM, LDA_DIR, STA_DIR, ADD_AB, BRA, BEQ: std_logic_vector(7 downto 0);
begin
	STATE_MEMORY : process (Clock, Reset)
	begin
		if (Reset = '0') then
			current_state <= S_FETCH_0;
		elsif (clock'event and clock = '1') then
			current_state <= next_state;
		end if;
	end process;
	
	NEXT_STATE_LOGIC : process (current_state, IR, CCR_Result)
	begin
		if (current_state = S_FETCH_0) then
			next_state <= S_FETCH_1;
		elsif (current_state = S_FETCH_1) then
			next_state <= S_FETCH_2;
		elsif (current_state = S_FETCH_2) then
			next_state <= S_DECODE_3;
		elsif (current_state = S_DECODE_3) then
			-- select execution path
			if (IR = LDA_IMM) then -- Load A Immediate
				next_state <= S_LDA_IMM_4;
			elsif (IR = LDA_DIR) then -- Load A Direct
				next_state <= S_LDA_DIR_4;
			elsif (IR = STA_DIR) then -- Store A Direct
				next_state <= S_STA_DIR_4;
			elsif (IR = ADD_AB) then -- Add A and B
				next_state <= S_ADD_AB_4;
			elsif (IR = BRA) then -- Branch Always
				next_state <= S_BRA_4;
			elsif (IR=BEQ and CCR_Result(2)='1') then -- BEQ and Z=1
				next_state <= S_BEQ_4;
			elsif (IR=BEQ and CCR_Result(2)='0') then -- BEQ and Z=0
				next_state <= S_BEQ_7;
			else
				next_state <= S_FETCH_0;
			end if;
		--elsif	: “paths for each instruction go here. . .” 	:
		end if;
	end process;
	
	OUTPUT_LOGIC : process (current_state)
	begin
		case(current_state) is
			when S_FETCH_0 => -- Put PC onto MAR to read Opcode
				IR_Load <= '0';
				MAR_Load <= '1';
				PC_Load <= '0';
				PC_Inc <= '0';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00"; -- "00"=PC, "01"=A, "10"=B
				Bus2_Sel <= "01"; -- "00"=ALU_Result, "01"=Bus1, "10"=from_memory
				writen <= '0';
			when S_FETCH_1 => -- Increment PC
				IR_Load <= '0';
				MAR_Load <= '0';
				PC_Load <= '0';
				PC_Inc <= '1';
				A_Load <= '0';
				B_Load <= '0';
				ALU_Sel <= "000";
				CCR_Load <= '0';
				Bus1_Sel <= "00"; -- "00"=PC, "01"=A, "10"=B
				Bus2_Sel <= "00"; -- "00"=ALU, "01"=Bus1, "10"=from_memory
				writen <= '0';
			when others =>
				
			--: “output assignments for all other states go here. . .” :
		end case;
	end process;
end architecture;
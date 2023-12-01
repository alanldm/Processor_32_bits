LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY fsm IS
	PORT (
		IR : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		Reset, Clock, Status : IN STD_LOGIC;
		W, Push, Pop : OUT STD_LOGIC;
		LDpc, LDir, LDraux, LDru, LDsr : OUT STD_LOGIC;
		CLRpc, CLRir, CLRraux, CLRru, CLRsr : OUT STD_LOGIC;
		LD0_7 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		CLR0_7 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		SELmem : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		SELbus : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
		SELalu : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		SELpc : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END fsm;
	
ARCHITECTURE Behavior OF fsm IS
	COMPONENT dec3to11 IS
		PORT(
			Reg : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			Onehot : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
		);
	END COMPONENT;
	
	TYPE States IS (START, SEARCH0, SEARCH1, DECODER, ADD0, ADD1, ADD2, ADD3, ADDL0, ADDL1, ADDL2, ADDL3, SUB0, SUB1, SUBL0, SUBL1, INC0, INC1, INC2, DEC, MUL0, MUL1, MUL2, MUL3, DIV0, DIV1, DIV2, DIV3, DIV4, DIV5, SAVE0, AND0, AND1, ANDL0, ANDL1, OR0, OR1, ORL0, ORL1, XOR0, XOR1, XORL0, XORL1, NOT0, SHR, SHL, SAVE1, GTR0, GTR1, GTRE0, GTRE1, SML0, SML1, SMLE0, SMLE1, EQ0, EQ1, MOV0, MOV1, MOVL0, MOVL1, JUMP0, JUMP1, JUMPC0, JUMPC1, JUMPC2, CALL0, CALL1, RETURN0, RETURN1, RETURN2, CLR, STORE0, STORE1, LOAD0, LOAD1, LOAD2, NOP);
	SIGNAL state : States;
	SIGNAL addr_a, addr_b : STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL Opcode : STD_LOGIC_VECTOR(4 DOWNTO 0);
	
	BEGIN
		Opcode <= IR(10 DOWNTO 6);
		ra : dec3to11 PORT MAP (IR(5 DOWNTO 3), addr_a);
		rb : dec3to11 PORT MAP (IR(2 DOWNTO 0), addr_b);
	
		PROCESS (Reset, Clock, Status, state)
			BEGIN	
				IF (Reset = '1') THEN
					state <= START;
				ELSIF (rising_edge(Clock)) THEN	
					CASE state IS
						WHEN START =>
							CLRpc <= '1';
							CLRir <= '1';
							CLRraux <= '1';
							CLRru <= '1';
							CLRsr <= '1';
							CLR0_7 <= "11111111";
							LDir <= '0';
							LDpc <= '0';
							LDraux <= '0';
							LDru <= '0';
							LDsr <= '0';
							LD0_7 <= "00000000";
							W <= '0';
							Push <= '0';
							Pop <= '0';
							SELmem <= "10";
							
							
							state <= SEARCH0;
						WHEN SEARCH0 =>
							LDir <= '1';
							LDpc <= '1';
							LDraux <= '0';
							LDru <= '0';
							LDsr <= '0';
							LD0_7 <= "00000000";
							W <= '0';
							Push <= '0';
							Pop <= '0';
							CLRpc <= '0';
							CLRir <= '0';
							CLRraux <= '0';
							CLRru <= '0';
							CLRsr <= '0';
							CLR0_7 <= "00000000";
							SELpc <= "001";
							
							state <= SEARCH1;
						WHEN SEARCH1 =>
						  LDir <= '0';
							LDpc <= '0';
							
							state <= DECODER;
						WHEN DECODER =>
							
							CASE Opcode IS
								WHEN "00000" =>
									state <= ADD0;
								WHEN "00001" =>
									state <= ADDL0;
								WHEN "00010" =>
									state <= SUB0;
								WHEN "00011" =>
									state <= SUBL0;
								WHEN "00100" =>
									state <= MUL0;
								WHEN "00101" =>
									state <= INC0;
								WHEN "00110" =>
									state <= DEC;
								WHEN "00111" =>
									state <= DIV0;
								WHEN "01000" =>
									state <= AND0;
								WHEN "01001" =>
									state <= ANDL0;
								WHEN "01010" =>
									state <= OR0;
								WHEN "01011" =>
									state <= ORL0;
								WHEN "01100" =>
									state <= XOR0;
								WHEN "01101" =>
									state <= XORL0;
								WHEN "01110" =>
									state <= NOT0;
								WHEN "01111" =>
									state <= SHR;
								WHEN "10000" =>
									state <= SHL;
								WHEN "10001" =>
									state <= GTR0;
								WHEN "10010" =>
									state <= SML0;
								WHEN "10011" =>
									state <= EQ0;
								WHEN "10100" =>
									state <= GTRE0;
								WHEN "10101" =>
									state <= SMLE0;
								WHEN "10110" =>
									state <= MOV0;
								WHEN "10111" =>
									state <= MOVL0;
								WHEN "11000" =>
									state <= JUMP0;
								WHEN "11001" =>
									state <= CALL0;
								WHEN "11010" =>
									state <= RETURN0;
								WHEN "11011" =>
									state <= JUMPC0;
								WHEN "11100" =>
									state <= CLR;
								WHEN "11101" =>
									state <= NOP;
								WHEN "11110" =>
									state <= LOAD0;
								WHEN "11111" =>
									state <= STORE0;
								WHEN OTHERS =>
									state <= SEARCH0;
							END CASE;
						
						WHEN ADD0 =>
							LDraux <= '1';
							SELalu <= "00000";	
							SELbus <= addr_a;
							
							state <= ADD1;
						WHEN ADD1 =>
							LDraux <= '0';
							SELbus <= addr_b;
							
							state <= ADD2;
						WHEN ADD2 =>
						  SELalu <= "UUUUU";
							
							state <= ADD3;
						WHEN ADD3 =>
						  LDru <= '1';
							LDsr <= '1';
							SELalu <= "00000";
							
							state <= SAVE0;
						WHEN ADDL0 =>
							LDraux <= '1';
							SELbus <= addr_a;
							SELalu <= "00000";
							
							state <= ADDL1;
						WHEN ADDL1 =>
							LDraux <= '0';
							SELbus <= "00000000001";
							
							state <= ADDL2;
						WHEN ADDL2 =>
						  SELalu <= "UUUUU";
						  
						  state <= ADDL3;
						WHEN ADDL3 =>
						  LDru <= '1';
						  LDsr <= '1';
						  SELalu <= "00000";
						  
						  state <= SAVE0;
						WHEN SUB0 =>
							LDraux <= '1';
							SELbus <= addr_a;
							
							state <= SUB1;
						WHEN SUB1 =>
							LDraux <= '0';
							LDru <= '1';
							SELbus <= addr_b;
							SELalu <= "00001";
							
							state <= SAVE0;
						WHEN SUBL0 =>
							LDraux <= '1';
							SELbus <= addr_a;
							
							state <= SUBL1;
						WHEN SUBL1 =>
							LDraux <= '0';
							LDru <= '1';
							SELbus <= "00000000001";
							SELalu <= "00001";
							
							state <= SAVE0;
						WHEN INC0 =>
							SELbus <= addr_a;
							SELalu <= "00010";
							
							state <= INC1;
						WHEN INC1 =>
						  SELalu <= "UUUUU";
						  
						  state <= INC2;
						WHEN INC2 =>
						  SELalu <= "00010";
						  LDru <= '1';
							LDsr <= '1';
						  
						  state<= SAVE0;
						WHEN DEC =>
							LDru <= '1';
							SELbus <= addr_a;
							SELalu <= "00011";
							
							state <= SAVE0;
						WHEN MUL0 =>
							LDraux <= '1';
							SELbus <= addr_a;
							SELalu <= "01111";
							
							state <= MUL1;
						WHEN MUL1 =>
							LDraux <= '0';
							SELbus <= addr_b;
							
							state <= MUL2;
						WHEN MUL2 =>
						  SELalu <= "UUUUU";
						  
						  state <= MUL3;
						WHEN MUL3 =>
						  LDru <= '1';
						  LDsr <= '1';
						  SELalu <= "01111";
						  
						  state <= SAVE0;
						WHEN DIV0 =>
							LDraux <= '1';
							LDsr <= '1';
							SELbus <= addr_b;
							SELalu <= "10000";
							
              state <= DIV1;
						WHEN DIV1 =>
						  LDsr <= '0';
						  LDraux <= '0';
						  
							state <= DIV2;
						WHEN DIV2 =>
						  IF (Status = '0') THEN
								state <= DIV3;
							ELSE
								state <= SEARCH0;
							END IF;
					
					  WHEN DIV3 =>
					    SELbus <= addr_a;
					    SELalu <= "10001";
							
							state <= DIV4;
						WHEN DIV4 =>
						  SELalu <= "UUUUU";
						  
						  state <= DIV5;
			      WHEN DIV5 =>
			        SELalu <= "10001";
			        LDru <= '1';
			        
			        state <= SAVE0;
						WHEN SAVE0 =>
							SELmem <= "10";
							LDru <= '0';
							LDsr <= '0';
							LD0_7 <= addr_a(10 DOWNTO 3);
							SELbus <= "00000000100";
							
							state <= SEARCH0;
						WHEN AND0 =>
							LDraux <= '1';
							SELbus <= addr_a;
							
							
							state <= AND1;
						WHEN AND1 =>
							LDraux <= '0';
							LDru <= '1';
							SELbus <= addr_b;
							SELalu <= "00101";
							
							state <= SAVE1;
						WHEN ANDL0 =>
							LDraux <= '1';
							SELbus <= addr_a;
						
							state <= ANDL1;
						WHEN ANDL1 =>
							LDraux <= '0';
							LDru <= '1';
							SELbus <= "00000000001";
							SELalu <= "00101";
							
							state <= SAVE1;
						WHEN OR0 =>
							LDraux <= '1';
							SELbus <= addr_a;
							
							state <= OR1;
						WHEN OR1 =>
							LDraux <= '0';
							LDru <= '1';
							SELbus <= addr_b;
							SELalu <= "00110";
							
							state <= SAVE1;
						WHEN ORL0 =>
							LDraux <= '1';
							SELbus <= addr_a;
							
							state <= ORL1;
						WHEN ORL1 =>
							LDraux <= '0';
							LDru <= '1';
							SELbus <= "00000000001";
							SELalu <= "00110";
							
							state <= SAVE1;
						WHEN XOR0 =>
							LDraux <= '1';
							SELbus <= addr_a;
							
							state <= XOR1;
						WHEN XOR1 =>
							LDraux <= '0';
							LDru <= '1';
							SELbus <= addr_b;
							SELalu <= "00111";
							
							state <= SAVE1;
						WHEN XORL0 =>
							LDraux <= '1';
							SELbus <= addr_a;
							
							state <= XORL1;
						WHEN XORL1 =>
							LDraux <= '0';
							LDru <= '1';
							SELbus <= "00000000001";
							SELalu <= "00111";
							
							state <= SAVE1;						
						WHEN NOT0 =>
							LDru <= '1';
							SELbus <= addr_a;
							SELalu <= "00100";
							
							state <= SAVE1;
						WHEN SHR =>
							LDru <= '1';
							SELbus <= addr_a;
							SELalu <= "01101";
							
							state <= SAVE1;
						WHEN SHL =>
							LDru <= '1';
							SELbus <= addr_a;
							SELalu <= "01110";
							
							state <= SAVE1;
						WHEN SAVE1 =>
							LDru <= '0';
							LD0_7 <= addr_a(10 DOWNTO 3);
							SELbus<= "00000000100";
							SELmem <= "10";
							
							state <= SEARCH0;
						WHEN GTR0 =>
							LDraux <= '1';
							SELbus <= addr_a;
							
							state <= GTR1;
						WHEN GTR1 =>
							LDraux <= '0';
							LDsr <= '1';
							SELbus <= addr_b;
							SELalu <= "01001";
							SELmem <= "10";
							
							state <= SEARCH0;
						WHEN GTRE0 =>
							LDraux <= '1';
							SELbus <= addr_a;
							
							state <= GTRE1;
						WHEN GTRE1 =>
							LDraux <= '0';
							LDsr <= '1';
							SELbus <= addr_b;
							SELalu <= "01011";
							SELmem <= "10";
							
							state <= SEARCH0;
						WHEN SML0 =>
							LDraux <= '1';
							SELbus <= addr_a;
							
							state <= SML1;
						WHEN SML1 =>
							LDraux <= '0';
							LDsr  <= '1';
							SELbus <= addr_b;
							SELalu <= "01010";
							SELmem <= "10";
							
							state <= SEARCH0;
						WHEN SMLE0 =>
							LDraux <= '1';
							SELbus <= addr_a;
							
							state <= SMLE1;
						WHEN SMLE1 =>
							LDraux <= '0';
							LDsr <= '1';
							SELbus <= addr_b;
							SELalu <= "01100";
							SELmem <= "10";
							
							state <= SEARCH0;
						WHEN EQ0 =>
							LDraux <= '1';
							SELbus <= addr_a;
							
							state <= EQ1;
						WHEN EQ1 =>
							LDraux <= '0';
							LDsr <= '1';
							SELbus <= addr_b;
							SELalu <= "01000";
							SELmem <= "10";
							
							state <= SEARCH0;					
						WHEN MOV0 =>	
							LD0_7 <= addr_a(10 DOWNTO 3);
							SELbus <= addr_b;
							
							state <= MOV1;
						WHEN MOV1 =>
						  LD0_7 <= "00000000";
							SELmem <= "10";
							
							state <= SEARCH0;
						WHEN MOVL0 =>
							LD0_7 <= addr_a(10 DOWNTO 3);
							SELbus <= "00000000001";
							
							state <= MOVL1;
							
						WHEN MOVL1 =>
						  LD0_7 <= "00000000";
							SELmem <= "10";
							
							state <= SEARCH0;
						WHEN JUMP0 =>
							LDpc <= '1';
							SELpc <= "010";
							
							state <= JUMP1;
						WHEN JUMP1 =>
							LDpc <= '0';
							SELmem <= "10";
							
							state <= SEARCH0;
						WHEN JUMPC0 =>
							IF (Status = '1') THEN
								state <= JUMPC1;
							ELSE
								state <= SEARCH0;
							END IF;
						WHEN JUMPC1 =>
							LDpc <= '1';
							SELpc <= "010";
							
							state <= JUMPC2;
					  WHEN JUMPC2 =>
							LDpc <= '0';
							SELmem <= "10";
							
							state <= SEARCH0;
						WHEN CALL0 =>
							Push <= '1';
							LDpc <= '1';
							SELpc <= "010";
							
							state <= CALL1;
						WHEN CALL1 =>
							Push <= '0';
							LDpc <= '0';
							SELmem <= "10";
							
							state <= SEARCH0;
						WHEN RETURN0 =>
							Pop <= '1';
							
							state <= RETURN1;
						WHEN RETURN1 =>
							Pop <= '0';
							LDpc <= '1';
							SELpc <= "100";
							
							state <= RETURN2;
						WHEN RETURN2 =>
							SELmem <= "10";
							
							state <= SEARCH0;
						WHEN CLR =>
							CLR0_7 <= addr_a(10 DOWNTO 3);
							SELmem <= "10";
							
							state <= SEARCH0;
						WHEN STORE0 =>
							W <= '1';
							SELbus <= addr_a;
							SELmem <= "01";
							
							state <= STORE1;
						WHEN STORE1 =>
							W <= '0';
							SELmem <= "10";
							
							state <= SEARCH0;
						WHEN LOAD0 =>
							SELmem <= "01";
							
							state <= LOAD1;
						WHEN LOAD1 =>
							LD0_7 <= addr_a(10 DOWNTO 3);
							SELbus <= "00000000010";
							
							state <= LOAD2;
						WHEN LOAD2 =>
						  LD0_7 <= "00000000";
						  SELmem <= "10";
						  
						  state <= SEARCH0;
						WHEN NOP =>
						  SELmem <= "10";
						  
							state <= SEARCH0;
						WHEN OTHERS =>
							state <= START;
					END CASE;
				END IF;
			END PROCESS;
END Behavior;
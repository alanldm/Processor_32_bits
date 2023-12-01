LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--USE ieee.std_logic_unsigned.all;

ENTITY alu IS
	GENERIC (
		n : INTEGER := 32
	);
	PORT (
		Selector : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		Raux, Buswire : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Status : OUT STD_LOGIC;
		Ru : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
END alu;

ARCHITECTURE Behavior OF alu IS
  signal add : unsigned(n DOWNTO 0); -- 00000
	-- SUB 00001
	signal inc : unsigned(n DOWNTO 0); -- 00010
	-- DEC 00011
	-- NOT 00100
	-- UND 00101
	-- ODER 00110
	-- XODER 00111
	-- EQ 01000
	-- GTR 01001
	-- SML 01010
	-- GTRE 01011
	-- SMLE 01100
	-- SHR 01101
	-- SHL 01110
	signal mul : unsigned(n*2 - 1 DOWNTO 0); -- 01111
	-- EQ0 10000
	signal div : unsigned(n - 1 DOWNTO 0); -- 10001
	
	FUNCTION TO_STD_LOGIC(B : BOOLEAN) RETURN STD_LOGIC IS
	 BEGIN
	   IF B THEN
	     RETURN('1');
	   ELSE
	     RETURN('0');
	   END IF;
	 END FUNCTION TO_STD_LOGIC;
	
	BEGIN
		PROCESS (Buswire, Raux, Selector)
		
			variable rx : unsigned(n DOWNTO 0);
			variable bw : unsigned(n DOWNTO 0);
      
			BEGIN
				-- Bloco de soma
				IF (Selector = "00000") THEN
				  add <= UNSIGNED('0' & Raux) + UNSIGNED('0' & Buswire);
					Ru <= STD_LOGIC_VECTOR(add(n-1 DOWNTO 0));
					Status <= add(n);
							
				-- Bloco de subtração			
				ELSIF (Selector = "00001") THEN
					Ru <= STD_LOGIC_VECTOR(UNSIGNED(Raux) - UNSIGNED(Buswire));
				
				-- Bloco de incremento
				ELSIF (Selector = "00010") THEN					
					inc <= UNSIGNED('0' & Buswire) + "000000000000000000000000000000001";
					Ru <= STD_LOGIC_VECTOR(inc(n-1 DOWNTO 0));
					Status <= inc(n);
							
				-- Bloco de decremento
				ELSIF (Selector = "00011") THEN
					Ru <= STD_LOGIC_VECTOR(UNSIGNED(Buswire) - "00000000000000000000000000000001");
					
				-- Bloco de negação
				ELSIF (Selector = "00100") THEN
					Ru <= STD_LOGIC_VECTOR(NOT(UNSIGNED(Buswire)));
				
				-- Bloco de and
				ELSIF (Selector = "00101") THEN
					Ru <= STD_LOGIC_VECTOR(UNSIGNED(Raux) AND UNSIGNED(Buswire));
					
				-- Bloco de or
				ELSIF (Selector = "00110") THEN
					Ru <= STD_LOGIC_VECTOR(UNSIGNED(Raux) OR UNSIGNED(Buswire));
					
				-- Bloco de xor
				ELSIF (Selector = "00111") THEN
					Ru <= STD_LOGIC_VECTOR(UNSIGNED(Raux) XOR UNSIGNED(Buswire));
					
				-- Bloco de igual
				ELSIF (Selector = "01000") THEN
					Status <= TO_STD_LOGIC(Raux = Buswire);

				-- Bloco de maior 
				ELSIF (Selector = "01001") THEN
					Status <= TO_STD_LOGIC(Raux > Buswire);
					
				-- Bloco de menor 
				ELSIF (Selector = "01010") THEN
					Status <= TO_STD_LOGIC(Raux < Buswire);
					
				-- Bloco de maior ou igual
				ELSIF (Selector = "01011") THEN
					Status <= TO_STD_LOGIC(Raux >= Buswire);
					
				-- Bloco de menor ou igual
				ELSIF (Selector = "01100") THEN
					Status <= TO_STD_LOGIC(Raux <= Buswire);
					
				-- Bloco de deslocamento à direita
				ELSIF (Selector = "01101") THEN
					Ru <= STD_LOGIC_VECTOR(UNSIGNED(Buswire) SRL 1);
					
				-- Bloco de deslocamento à esquerda
				ELSIF (Selector = "01110") THEN
					Ru <= STD_LOGIC_VECTOR(UNSIGNED(Buswire) SLL 1);

				-- Bloco de multiplicação
				ELSIF (Selector = "01111") THEN				
					mul <= UNSIGNED(Raux) * UNSIGNED(Buswire);
					Ru <= STD_LOGIC_VECTOR(mul(n-1 DOWNTO 0));
					Status <= TO_STD_LOGIC(mul(n*2-1 DOWNTO n) /= "00000000000000000000000000000000");
				
				-- Bloco de verificação do denominador
				ELSIF (Selector = "10000") THEN
					Status <= TO_STD_lOGIC(Buswire = "00000000000000000000000000000000");

				-- Bloco de divisão
				ELSIF (Selector = "10001") THEN
					IF (Buswire /= "00000000000000000000000000000000") THEN						
						div <= UNSIGNED(Buswire)/UNSIGNED(Raux);
						Ru <= STD_LOGIC_VECTOR(div);
					END IF;
				
				ELSE
					Ru <= "00000000000000000000000000000000";
					Status <= '0';
				
				END IF;
		END PROCESS;
END Behavior;
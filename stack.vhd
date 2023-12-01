LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY stack IS
	GENERIC(
		n : INTEGER := 7;
		k : INTEGER := 10
	);
	PORT(
		Pop, Push, Clock : IN STD_LOGIC;
		Qpc : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Addr_stack : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
END stack;

ARCHITECTURE Behavior OF stack IS
	TYPE StackType IS ARRAY (0 TO k-1) OF STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	signal Stack : StackType;
	signal count : NATURAL RANGE 0 TO k-1 := 0;
	
	BEGIN		
		PROCESS(Clock)
			BEGIN
				IF(rising_edge(Clock)) THEN
					IF (Pop = '1' AND Push = '0') THEN
						Addr_stack <= Stack(count-1);
						count <= count - 1;
					ELSIF (Push = '1' AND Pop = '0') THEN
						Stack(count) <= Qpc;
						count <= count + 1;
					END IF;
				END IF;
		END PROCESS;
END Behavior; 
LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY regn IS
	GENERIC (
		n : INTEGER := 32
	);
	PORT (
		R : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		Load, Clock, Clear : IN STD_LOGIC;
		Q : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
	);
END regn;

ARCHITECTURE Behavior OF regn IS
	BEGIN
		PROCESS (Clock, Clear)
			BEGIN
				IF (Clear = '1') THEN
					Q <= (OTHERS => '0');
				ELSE
					IF (rising_edge(Clock)) THEN
						IF (Load = '1') THEN
							Q <= R;
						END IF;
					END IF;
				END IF;
		END PROCESS;
END Behavior;
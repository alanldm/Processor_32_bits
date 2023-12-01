LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY reg_status IS
	PORT (
		R : IN STD_LOGIC;
		Load, Clock, Clear : IN STD_LOGIC;
		Q : OUT STD_LOGIC
	);
END reg_status;

ARCHITECTURE Behavior OF reg_status IS
	BEGIN
		PROCESS (Clock, Clear)
			BEGIN
				IF (Clear = '1') THEN
					Q <= '0';
				ELSE
					IF (rising_edge(Clock)) THEN
						IF (Load = '1') THEN
							Q <= R;
						END IF;
					END IF;
				END IF;
		END PROCESS;
END Behavior;
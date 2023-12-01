LIBRARY ieee;
USE ieee.std_logic_1164.all;


ENTITY Testbench IS
END Testbench;

ARCHITECTURE Behavior OF Testbench IS
  COMPONENT LaHe IS
 	  PORT(
		  Reset, Clock : IN STD_LOGIC;
		  BusWire : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0)
	  );
	END COMPONENT;
	
	SIGNAL Clock, Reset : STD_LOGIC := '0';
	CONSTANT T : Time := 80 ns;
		  
	BEGIN
	  proc : LaHe PORT MAP (Reset, Clock, OPEN);
	    
	  Clock <= NOT Clock AFTER T/2;
	END Behavior;
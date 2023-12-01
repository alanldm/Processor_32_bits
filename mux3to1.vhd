LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux3to1 IS
	PORT (
		SELpc : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Addr_ir : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		Addr_stack : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		Inc_pc : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		Rpc : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END mux3to1;

ARCHITECTURE Behavior OF mux3to1 IS
	BEGIN
		Rpc <= Addr_stack WHEN SELpc = "100" ELSE
				 Addr_ir WHEN SELpc = "010" ELSE
				 Inc_pc WHEN SELpc = "001";
END Behavior;
	
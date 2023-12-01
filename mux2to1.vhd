LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux2to1 IS
	PORT (
		SELmem : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Addr_ir : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		Qpc : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		Addr_mem : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END mux2to1;

ARCHITECTURE Behavior OF mux2to1 IS
	BEGIN
		Addr_mem <= Qpc WHEN SELmem = "10" ELSE
						Addr_ir WHEN SELmem = "01";
END Behavior;
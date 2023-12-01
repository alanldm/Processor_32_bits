LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux11to1 IS
	PORT (
		Selector : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		IR : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		R0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		R1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		R2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		R3 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		R4 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		R5 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		R6 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		R7 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Ru : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Memory : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Buswire : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END mux11to1;

ARCHITECTURE Behavior OF mux11to1 IS
	BEGIN
		Buswire <= R0 WHEN Selector = "10000000000" ELSE
					  R1 WHEN Selector = "01000000000" ELSE
					  R2 WHEN Selector = "00100000000" ELSE
					  R3 WHEN Selector = "00010000000" ELSE
					  R4 WHEN Selector = "00001000000" ELSE
					  R5 WHEN Selector = "00000100000" ELSE
					  R6 WHEN Selector = "00000010000" ELSE
					  R7 WHEN Selector = "00000001000" ELSE
					  Ru WHEN Selector = "00000000100" ELSE
					  Memory WHEN Selector = "00000000010" ELSE
					  IR WHEN Selector = "00000000001";
END Behavior;
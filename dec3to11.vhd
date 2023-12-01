LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY dec3to11 IS
	PORT(
		Reg : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		Onehot : OUT STD_LOGIC_VECTOR(10 DOWNTO 0)
	);
END dec3to11;

ARCHITECTURE Behavior OF dec3to11 IS
	BEGIN
		Onehot <= "10000000000" WHEN Reg = "000" ELSE
					 "01000000000" WHEN Reg = "001" ELSE
					 "00100000000" WHEN Reg = "010" ELSE
					 "00010000000" WHEN Reg = "011" ELSE
					 "00001000000" WHEN Reg = "100" ELSE
					 "00000100000" WHEN Reg = "101" ELSE
					 "00000010000" WHEN Reg = "110" ELSE
					 "00000001000" WHEN Reg = "111"; 
END Behavior;
	
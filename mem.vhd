LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.all;
USE ieee.std_logic_textio.all;
USE std.textio.all;

ENTITY mem IS
	PORT(
		Buswire : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ADDR : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
		Clock, W : IN STD_LOGIC;
		Output : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
	);	
END mem;

ARCHITECTURE Behavior OF mem IS
  TYPE MemType IS ARRAY (0 TO 127) OF STD_LOGIC_VECTOR(63 DOWNTO 0);
  
  IMPURE FUNCTION init_ram_bin RETURN MemType IS
    FILE text_file : text OPEN read_mode IS "IR.txt";
    VARIABLE text_line : line;
    VARIABLE ram_content : MemType;
    VARIABLE bv : bit_vector(ram_content(0)'RANGE);
    BEGIN
      FOR i IN 0 TO 127 LOOP
        readline(text_file, text_line);
        read(text_line, bv);
        ram_content(i) := To_StdLogicVector(bv);
    END LOOP;
 
    RETURN ram_content;
  END FUNCTION;
	
	SIGNAL mem : MemType := init_ram_bin;

	BEGIN
		PROCESS (Clock)
			BEGIN
				IF (rising_edge(Clock)) THEN
					IF (W = '0') THEN
						Output <= mem(TO_INTEGER(UNSIGNED(ADDR)));
					ELSIF (W = '1') THEN
						mem(TO_INTEGER(UNSIGNED(ADDR))) <= Buswire & "00000000000000000000000000000000";
					END IF;
				END IF;
			END PROCESS;					
END Behavior;
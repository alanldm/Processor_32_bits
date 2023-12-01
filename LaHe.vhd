LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY LaHe IS
	PORT(
		Reset, Clock : IN STD_LOGIC;
		BusWire : BUFFER STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END LaHe;
	
ARCHITECTURE Behavior OF LaHe IS
	-- Definição dos componentes do Datapath.
	COMPONENT regn IS
		GENERIC (
			n : INTEGER := 32
		);
		PORT (
			R : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			Load, Clock, Clear : IN STD_LOGIC;
			Q : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT reg_status IS
		PORT (
			R : IN STD_LOGIC;
			Load, Clock, Clear : IN STD_LOGIC;
			Q : OUT STD_LOGIC
		);
	END COMPONENT;
	
	COMPONENT mux11to1 IS
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
	END COMPONENT;
	
	COMPONENT mux3to1 IS
		PORT (
			SELpc : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
			Addr_ir : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			Addr_stack : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			Inc_pc : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			Rpc : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT mux2to1 IS
		PORT (
			SELmem : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
			Addr_ir : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			Qpc : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			Addr_mem : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT alu IS
		GENERIC (
			n : INTEGER := 32
		);
		PORT (
			Selector : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			Raux, Buswire : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			Status : OUT STD_LOGIC;
			Ru : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT stack IS
		GENERIC(
			n : INTEGER := 7;
			k : INTEGER := 10
		);
		PORT(
			Pop, Push, Clock : IN STD_LOGIC;
			Qpc : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			Addr_stack : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0)
		);
	END COMPONENT;
	
	COMPONENT mem IS
		PORT(
			Buswire : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			ADDR : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			Clock, W : IN STD_LOGIC;
			Output : OUT STD_LOGIC_VECTOR(63 DOWNTO 0)
		);	
	END COMPONENT;
	
	COMPONENT fsm IS
		PORT (
			IR : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
			Reset, Clock, Status : IN STD_LOGIC;
			W, Push, Pop : OUT STD_LOGIC;
			LDpc, LDir, LDraux, LDru, LDsr : OUT STD_LOGIC;
			CLRpc, CLRir, CLRraux, CLRru, CLRsr : OUT STD_LOGIC;
			LD0_7 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			CLR0_7 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			SELmem : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			SELbus : OUT STD_LOGIC_VECTOR(10 DOWNTO 0);
			SELalu : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
			SELpc : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
		);
	END COMPONENT;
	--------------------------------------------------------
	
	SIGNAL SELalu : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL SELpc : STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL SELmem : STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL SELbus : STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL Ru : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL L_ir, L_mem, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Qu, Qaux : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Qmem : STD_LOGIC_VECTOR(63 DOWNTO 0);
	SIGNAL LDpc, LDir, LDraux, LDru, LDsr : STD_LOGIC := '0';
	SIGNAL CLRpc, CLRir, CLRraux, CLRru, CLRsr : STD_LOGIC := '0';
	SIGNAL W, Push, Pop : STD_LOGIC := '0';
	SIGNAL LD0_7, CLR0_7 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL Rir, Qir : STD_LOGIC_VECTOR(39 DOWNTO 0);
	SIGNAL Rpc, Qpc : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL Rsr, Qsr : STD_LOGIC;
	SIGNAL Addr_ir, Addr_stack, Inc_pc, Addr_mem : STD_LOGIC_VECTOR(6 DOWNTO 0);
	SIGNAL IR : STD_LOGIC_VECTOR(10 DOWNTO 0);
	
	BEGIN
	
		Addr_ir <= Qir(31 DOWNTO 25);
		L_ir <= Qir(31 DOWNTO 0);
		IR <= Qir(39 DOWNTO 29);
		
		Rir <= Qmem(63 DOWNTO 24);
		L_mem <= Qmem(63 DOWNTO 32);
		
		-- Máquina de Estados de Baixo Nível (Fsm)
		mde : fsm PORT MAP(IR, Reset, Clock, Qsr, W, Push, Pop, LDpc, LDir, LDraux, LDru, LDsr, CLRpc, CLRir, CLRraux, CLRru, CLRsr, LD0_7, CLR0_7, SELmem, SELbus, SELalu, SELpc);
		Inc_pc <= STD_LOGIC_VECTOR(UNSIGNED(Qpc) + "0000001");		
		
		------------------------------------------
		
		-- Pilha (Stack)
		pile : stack PORT MAP(Pop, Push, Clock, Qpc, Addr_stack);
		----------------
		
		-- Memória (Memory)
		memory : mem PORT MAP(BusWire, Addr_mem, Clock, W, Qmem);
		-------------------
		
		
		-- Operações lógicas e aritméticas do processador:
		ula : alu PORT MAP (SELalu, Qaux, BusWire, Rsr, Ru);
		--------------------------------------------------
		
		-- Conexões com os muxs do processador:
		mux_pc : mux3to1 PORT MAP(SELpc, Addr_ir, Addr_stack, Inc_pc, Rpc);
		mux_bus : mux11to1 PORT MAP(SELbus, L_ir, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7, Qu, L_mem, BusWire);
		mux_mem : mux2to1 PORT MAP(SELmem, Addr_ir, Qpc, Addr_mem);
		---------------------------------------
		
		-- Conexões com os registradores do processador:
		reg_0 : regn PORT MAP (BusWire, LD0_7(7), Clock, CLR0_7(7), Q0);
		reg_1 : regn PORT MAP (BusWire, LD0_7(6), Clock, CLR0_7(6), Q1);
		reg_2 : regn PORT MAP (BusWire, LD0_7(5), Clock, CLR0_7(5), Q2);
		reg_3 : regn PORT MAP (BusWire, LD0_7(4), Clock, CLR0_7(4), Q3);
		reg_4 : regn PORT MAP (BusWire, LD0_7(3), Clock, CLR0_7(3), Q4);
		reg_5 : regn PORT MAP (BusWire, LD0_7(2), Clock, CLR0_7(2), Q5);
		reg_6 : regn PORT MAP (BusWire, LD0_7(1), Clock, CLR0_7(1), Q6);
		reg_7 : regn PORT MAP (BusWire, LD0_7(0), Clock, CLR0_7(0), Q7);
		reg_u : regn PORT MAP (Ru, LDru, Clock, CLRru, Qu);
		reg_aux : regn PORT MAP (BusWire, LDraux, Clock, CLRraux, Qaux);
		reg_sr : reg_status PORT MAP (Rsr, LDsr, Clock, CLRsr, Qsr);
		reg_pc : regn GENERIC MAP (n => 7) PORT MAP (Rpc, LDpc, Clock, CLRpc, Qpc);
		reg_ir : regn GENERIC MAP (n => 40) PORT MAP (Rir , LDir, Clock, CLRir, Qir);
		------------------------------------------------
	
END Behavior;	
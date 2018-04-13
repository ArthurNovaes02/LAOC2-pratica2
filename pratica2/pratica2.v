//Clocks separados, 1 para memória e Counter, outro para o processador
module pratica2(KEY, SW, LW);
	input [17:00]SW;
	input [2:0]KEY;
	output [17:00]LW;
	assign LW[15:0]=SW[15:0];
	assign LW[17]=SW[17];
	wire [4:0]n;
	wire [15:0]DataIN;
	wire [15:0] Bus;
	wire WREN;
	wire done;
	WREN = 1;

	//KEY[0] = Resetn
	//KEY[1] = MClock
	//KEY[2] = PClock
	//SW[17] = Run
	//SW[14:0] = Dado a ser escrito
	//LW[16:0] = DONE
									//MClock |Resetn
	counter Contador(KEY[1], KEY[0], n);
									//MClock   //dado
	memory Memoria(n, KEY[1], SW[15:0], WREN, DataIN);

	processor Processador(KEY[2], DataIN, KEY[0], SW[17], Bus, Done);

	assign LW[16] = Done;

endmodule

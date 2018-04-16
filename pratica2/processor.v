module proc (DIN, Resetn, Clock, Run, Done, BusWires);
	input [15:0] DIN;
	input Resetn, Clock, Run;
	output Done;
	output [15:0] BusWires;
	wire [15:0]IRout;
	//... declare variables
	wire Clear = 1; //limpa

	regn IR(DIN, IRin, Clock, IRout);

	upcount Tstep (Clear, Clock, Tstep_Q);

	assign I = IR[1:3];

	dec3to8 decX (IR[4:6], 1’b1, Xreg);
	dec3to8 decY (IR[7:9], 1’b1, Yreg);

	//Unidadede controle dos estágios
	always @(Tstep_Q or I or Xreg or Yreg)
		begin
		//... specify initial values
		case (Tstep_Q)
			2’b00: // store DIN in IR in time step 0
				begin
					IRin = 1’b1;
				end
			2’b01: //define signals in time step 1
				case (I)
				endcase
			2’b10: //define signals in time step 2
				case (I)
				endcase
			2’b11: //define signals in time step 3
				case (I)
				endcase
		endcase
	end

	//Instancia os registradores
	regn reg_0 (BusWires, Rin[0], Clock, R0);
	regn reg_0 (BusWires, Rin[1], Clock, R1);
	regn reg_0 (BusWires, Rin[2], Clock, R2);
	regn reg_0 (BusWires, Rin[3], Clock, R3);
	regn reg_0 (BusWires, Rin[4], Clock, R4);
	regn reg_0 (BusWires, Rin[5], Clock, R5);
	regn reg_0 (BusWires, Rin[6], Clock, R6);
	regn reg_0 (BusWires, Rin[7], Clock, R7);
	//... instantiate other registers and the adder/subtracter unit
	//... define the bus
endmodule

//Contador do processador
module upcount(Clear, Clock, Q);
	input Clear, Clock;
	output [1:0] Q;
	reg [1:0] Q;
	always @(posedge Clock)
		if (Clear)
			Q <= 2’b0;
		else
			Q <= Q + 1’b1;
endmodule

//W =
//En =
//Y =
module dec3to8(W, En, Y);
	input [2:0] W;
	input En;
	output [0:7] Y;
	reg [0:7] Y;
	always @(W or En)
	begin
	if (En == 1)
		case (W)
			3’b000: Y = 8’b10000000; //0
			3’b001: Y = 8’b01000000; //1
			3’b010: Y = 8’b00100000; //2
			3’b011: Y = 8’b00010000; //3
			3’b100: Y = 8’b00001000; //4
			3’b101: Y = 8’b00000100; //5
			3’b110: Y = 8’b00000010; //6
			3’b111: Y = 8’b00000001; //7
		endcase
	else
	Y = 8’b00000000;
	end
endmodule

//Instancia um registrador
//R = dado
//Q = saída
//Rin a decisao de atribuicao
module regn(R, Rin, Clock, Q);
	parameter n = 16;
	input [n-1:0] R;
	input Rin, Clock;
	output [n-1:0] Q;
	reg [n-1:0] Q;
	always @(posedge Clock)
		if (Rin)
			Q <= R;
endmodule

module proc (DIN, Resetn, Clock, Run, Done, BusWires);
	input [15:0] DIN;
	input Resetn, Clock, Run;
	output Done;
	output [15:0] BusWires;
	wire [15:0]IRout;
	wire [15:0]Q;
	wire [9:0]IR;
	wire [2:0]I;
	//... declare variables
	wire Clear = 1; //limpa

	regn IRinstance(DIN, 1, Clock, IR);
	assign I = IR[9:6];
	upcount Tstep (Clear, Clock, Tstep_Q);
	
	dec3to8 decX (IR[2:0], 1'b1, Xreg);
	dec3to8 decY (IR[5:3], 1'b1, Yreg);

	//Unidadede controle dos estagios
	always @(Tstep_Q or I or Xreg or Yreg) begin
		//... specify initial values
		case (Tstep_Q)
			2'b00: // store DIN in IR in time step 0
				begin
					IRin = 1'b1;
				end
			2'b01: //define signals in time step 1
				case (I) //qual instrucao sera executada
				Dado1, Dado2, iControl, Clock, Q
					3'b000://soma
						Ula somaInstance(Xreg, Yreg, I, );
					3'b000://sub
						Ula subInstance(Xreg, Yreg, I, );
					3'b000://or
						Ula orInstance(Xreg, Yreg, I, );
					3'b000://slt
						Ula sltInstance(Xreg, Yreg, I, );
					3'b000://sll
						Ula sllsomaInstance(Xreg, Yreg, I, );
					3'b000://srl
						Ula slrsomaInstance(Xreg, Yreg, I, );
					3'b000://mv
						Xreg = Yreg;
					3'b000://mvi
						Xreg = IR[2:0];
						
				endcase
			2'b10: //define signals in time step 2
				case (I)
				endcase
			2'b11: //define signals in time step 3
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
	//Dado1, Dado2, iControl, Clock, Q
endmodule

//Contador do processador
module upcount(Clear, Clock, Q);
	input Clear, Clock;
	output [1:0] Q;
	reg [1:0] Q;
	always @(posedge Clock)
		if (Clear)
			Q <= 2'b0;
		else
			Q <= Q + 1'b1;
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
			3'b000: Y = 8'b10000000; //0
			3'b001: Y = 8'b01000000; //1
			3'b010: Y = 8'b00100000; //2
			3'b011: Y = 8'b00010000; //3
			3'b100: Y = 8'b00001000; //4
			3'b101: Y = 8'b00000100; //5
			3'b110: Y = 8'b00000010; //6
			3'b111: Y = 8'b00000001; //7
		endcase
	else
	Y = 8'b00000000;
	end
endmodule

//Instancia um registrador
//R = dado
//Q = saida
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

//Q = saida
//Dado1 = Registrador 1 da operacao
//Dado2 = Registrador 2 da oepracao
module Ula (Dado1, Dado2, iControl, Clock, Q);
	input [15:0]Dado1;
	input [15:0]Dado2;
	input [2:0]iControl;
	input Clock;
	output reg [15:0]Q;
	wire [15:0]aux; //auxilia nas operacoes

	always @ (posedge Clock) begin
		case(iControl)
			3'b000: //ADD : soma
				Q <= Dado2+Dado1;
			3'b001: //SUB : subtrai
				Q <= (Dado2-Dado1);
			3'b010: //OR coloca no dado1 valor do resultado logico
				if(Dado1 | Dado2 )begin Q = 16'b0000000000000001; end
			3'b011: //SLT valor do resultado logico = 1 se Dado1 < Dado2
				if(Dado1 < Dado2)begin Q = 16'b0000000000000001; end
				else begin Q = 16'b0000000000000000; end
			3'b100: //SLL : desloca a esquerda(multiplica dado1*2^(Dado2))
				Q <= Dado1 << Dado2;
			3'b101: //SRL : desloca a direita(dividi dado1/2^(Dado2)
				Q <= Dado1 >> Dado2;
		endcase
	end
endmodule //Ula
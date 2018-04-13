module processor(PClock, DataIN, Resetn, Run, Bus, Done);
	input PClock, Resetn, Run;
	input [15:0]DataIN;
	output Bus;
	output Done;
endmodule

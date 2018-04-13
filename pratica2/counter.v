module counter(MClock, Resetn, n);
	input MClock, Resetn;
	output [4:0]n;

	always@(posedge MClock)
	begin

	end

	if(Resetn)
	begin
	 n = 5'b00000;
	end

endmodule

module fir_4tap(
        input Clk,
        input signed [7:0] Xin,
        output reg signed [15:0] Yout
        );
    
    //Internal variables.
    wire signed   [7:0] H0,H1,H2,H3;
    wire signed   [15:0] MCM0,MCM1,MCM2,MCM3,add_out1,add_out2,add_out3;
    wire signed     [15:0] Q1,Q2,Q3;
    
//filter coefficient initializations.
//H = [-2 -1 3 4].
    assign H0 = -2;
    assign H1 = -1;
    assign H2 = 3;
    assign H3 = 4;

//Multiple constant multiplications.
    assign MCM3 = H3*Xin;
    assign MCM2 = H2*Xin;
    assign MCM1 = H1*Xin;
    assign MCM0 = H0*Xin;

//adders
    assign add_out1 = Q1 + MCM2;
    assign add_out2 = Q2 + MCM1;
    assign add_out3 = Q3 + MCM0;    

//flipflop instantiations (for introducing a delay).
    DFF dff1 (.Clk(Clk),.D(MCM3),.Q(Q1));
    DFF dff2 (.Clk(Clk),.D(add_out1),.Q(Q2));
    DFF dff3 (.Clk(Clk),.D(add_out2),.Q(Q3));

//Assign the last adder output to final output.
    always@ (posedge Clk)
        Yout <= add_out3;

endmodule

DFF:

module DFF
        (input Clk,
        input [15:0] D,
        output reg [15:0]   Q
        );
    
    always@ (posedge Clk)
        Q = D;
    
endmodule

//


module tb;

    // Inputs
    reg Clk;
    reg signed [7:0] Xin;

    // Outputs
    wire signed [15:0] Yout;

    // Instantiate the Unit Under Test (UUT)
    fir_4tap uut (
        .Clk(Clk), 
        .Xin(Xin), 
        .Yout(Yout)
    );
    
    //Generate a clock with 10 ns clock period.
    initial Clk = 0;
    always #5 Clk =~Clk;

//Initialize and apply the inputs.
    initial begin
          Xin = 0;  #40;
          Xin = -3; #10;
          Xin = 1;  #10;
          Xin = 0;  #10;
          Xin = -2; #10;
          Xin = -1; #10;
          Xin = 4;  #10;
          Xin = -5; #10;
          Xin = 6;  #10;
          Xin = 0;  #10;
    end
      
endmodule

// https://drive.google.com/file/d/1SmAYWyuVE4DYcNrxYqa_z83KmGzEwhSq/view

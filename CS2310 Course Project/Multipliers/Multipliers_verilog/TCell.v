module TCell(input clk, set, reset, set_symbol, output reg valid, symbol);

    initial begin
        valid = 0;
    end

    always @( posedge clk) begin
    
        if(reset) valid=0;
        else if(set & (~valid)) begin
            valid=1;
            symbol = set_symbol;
        end
    end
endmodule

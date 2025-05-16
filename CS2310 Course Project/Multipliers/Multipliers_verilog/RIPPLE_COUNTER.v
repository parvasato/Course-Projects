module D_Latch(input d, input en, input rstn, output reg q);

    always @(*) begin
        
        if(rstn) begin
                q<=1'b0;
        end
        else if(en) begin
                q<=d;
        end
    end
endmodule


module D_FF_MS (input D, input CLK, input RESET, output Q);

    wire p; wire clkn; wire fin;
    wire nCLK;
    not(nCLK, CLK);

    D_Latch aa(D, nCLK, RESET, p);
    D_Latch bb(p, CLK, RESET, Q);
    
endmodule

module RIPPLE_COUNTER (input CLK, input RESET, output [3:0] COUNT);

    wire [3:0] tn;
    not(tn[0], COUNT[0]);
    not(tn[1], COUNT[1]);
    not(tn[2], COUNT[2]);
    not(tn[3], COUNT[3]);

    D_FF_MS aa(tn[0], CLK, RESET, COUNT[0]);
    D_FF_MS bb(tn[1], tn[0], RESET, COUNT[1]);
    D_FF_MS cc(tn[2], tn[1], RESET, COUNT[2]);
    D_FF_MS dd(tn[3], tn[2], RESET, COUNT[3]);
endmodule
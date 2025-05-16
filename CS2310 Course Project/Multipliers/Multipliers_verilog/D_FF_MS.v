module D_Latch(input d, input en, output reg q);

    always @(*) begin

        if(en) begin
                q<=d;
        end
    end

endmodule


module D_FF_MS (input D, input CLK, output Q);

    wire p; wire clkn; wire fin;
    D_Latch aa(D, CLK, p);

    not(clkn, CLK);
    D_Latch bb(p, clkn, fin);
    
    wire ans; buf(ans, fin);
    buf(Q, ans);
endmodule
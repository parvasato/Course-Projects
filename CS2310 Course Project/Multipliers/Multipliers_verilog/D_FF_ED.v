module D_Latch(input d, input en, output reg q);

    always @(*) begin

        if(en) begin
                q<=d;
        end
    end

endmodule

module D_FF_ED (input D, input CLK, output Q);

    wire p; wire clkn; wire fin;
    not(clkn, CLK);
    and(fin, CLK, clkn);
    D_Latch aa(D, fin, Q);

endmodule
module and_mul(input [3:0] a, input b, output [3:0] ans);

    and(ans[0], a[0], b);
    and(ans[1], a[1], b);
    and(ans[2], a[2], b);
    and(ans[3], a[3], b);

endmodule

module full_adder(input x, input y, input cin, output cout, output sum);
    xor(sum, x, y, cin);
    wire j,k,l;
    
    assign cout = x&y | y&cin | x&cin ;

endmodule

module add_row(input [3:0] fir, input [3:0] sec, input [3:0] carr, output [3:0] carr_out, output [3:0] sum);

    full_adder f1(fir[0], sec[0], carr[0], carr_out[0], sum[0]);
    full_adder f2(fir[1], sec[1], carr[1], carr_out[1], sum[1]);
    full_adder f3(fir[2], sec[2], carr[2], carr_out[2], sum[2]);
    full_adder f4(fir[3], sec[3], carr[3], carr_out[3], sum[3]);
    
endmodule

module CLA4 (input [3:0] A,input [3:0] B,input carry_in, output carry_out, output [3:0] sum);

    wire [3:0] p;
    wire [3:0] g;
    wire [3:0] car;
    xor(p[0], A[0], B[0]);
    xor(p[1], A[1], B[1]);
    xor(p[2], A[2], B[2]);
    xor(p[3], A[3], B[3]);

    and(g[0], A[0], B[0]);
    and(g[1], A[1], B[1]);
    and(g[2], A[2], B[2]);
    and(g[3], A[3], B[3]);

    wire u1;
    and(u1, p[0], carry_in);
    or(car[1], u1, g[0]);

    wire a1,a2;
    and(a1, p[1], p[0], carry_in);
    and(a2, p[1], g[0]);
    or(car[2], a1, a2, g[1]);

    wire b1,b2,b3;
    and(b1, p[2], p[1], p[0], carry_in);
    and(b2, p[2], p[1], g[0]);
    and(b3, p[2], g[1]);
    or(car[3], b1, b2, b3, g[2]);

    wire e1,e2,e3,e4;
    and(e1, p[3], p[2], p[1], p[0], carry_in);
    and(e2, p[3], p[2], p[1], g[0]);
    and(e3, p[3], p[2], g[1]);
    and(e4, p[3], g[2]);
    or(carry_out, e1, e2, e3, e4, g[3]);

    xor(sum[0], p[0], carry_in);
    xor(sum[1], p[1], car[1]);
    xor(sum[2], p[2], car[2]);
    xor(sum[3], p[3], car[3]);


endmodule

module carry_save(input [3:0] op1,op2, output [7:0] res);

    wire [3:0]row1; wire [3:0] row2; wire [3:0] row3; wire [3:0] row4;

    and_mul a1(op1, op2[0], row1);
    and_mul a2(op1, op2[1], row2);
    and_mul a3(op1, op2[2], row3);
    and_mul a4(op1, op2[3], row4);

    assign res[0] = row1[0];

    wire [3:0] car; wire [3:0] sum1; wire zero;
    buf(zero,0);

    add_row ww({zer, {row1[3:1]}}, row2, {{row3[2:0]}, zer}, car, sum1);
    assign res[1] = sum1[0];

    wire [3:0] car2, sum2;

    add_row ee({row3[3], {sum1[3:1]}}, {{row4[2:0]}, zer}, car, car2, sum2);
    assign res[2] = sum2[0];

    CLA4 ff({row4[3], {sum2[3:1]}}, car2, zer, res[7], res[6:3]);

    
endmodule
module and_mul #(parameter x=8) (input [x-1:0] a, input b, output [x-1:0] ans);

    genvar i;
    generate
    for( i=0; i<x; i=i+1) begin
        and(ans[i], a[i], b);
    end
    endgenerate

endmodule

module full_adder(input x, input y, input cin, output cout, output sum);
    xor(sum, x, y, cin);
    wire j,k,l;
    
    assign cout = x&y | y&cin | x&cin ;

endmodule

module RCA_n_bit #(parameter x=8) (input [x-1:0] a, input [x-1:0] b, output c_out, output [x-1:0] sumand);

    wire [x-1:0] crr;
    wire extra; buf(extra, 0);

    genvar i;
    for( i=0; i<x; i=i+1) begin
        if(i==0)
            full_adder f(a[i], b[i], extra, crr[i], sumand[i]);
        else
            full_adder e(a[i], b[i], crr[i-1], crr[i], sumand[i]);
    end

    assign c_out = crr[x-1];

endmodule

module N_bit_mul #(parameter N=8) (input[N-1:0] op1,op2, output[2*N-1:0] res);


    wire [N-1:0] row [N-1:0];

    genvar i,j;
    generate
        for(i=0; i<N; i=i+1) begin
            and_mul #(N) a(op1, op2[i], row[i]);
        end
    endgenerate


     assign res[0] = row[0][0];

    wire [N-1:0] fin_sum [N-1:0];
    wire [N-1:0] that_carry;

    //assign that_carry[0] = 0;

    // RCA_n_bit #(N) aa({1'b0, row[0][N-1:1]}, row[1], that_carry[0], fin_sum[0]);
    // assign res[1] = fin_sum[0][0];


    genvar ii;
    generate
    for(ii=1; ii<N; ii=ii+1) begin
        if(ii==1) 
            RCA_n_bit #(N) aa({1'b0, row[0][N-1:1]}, row[1], that_carry[0], fin_sum[0]);
        else
            RCA_n_bit #(N) y1({that_carry[ii-2], fin_sum[ii-2][N-1:1]}, row[ii], that_carry[ii-1], fin_sum[ii-1]);
    end
    endgenerate

    if(N>1) 
        assign res[1] = fin_sum[0][0];
    else
        assign res[1] = 0;

    genvar u;
    generate
        for(u=2; u<N; u=u+1) begin
            assign res[u] = fin_sum[u-1][0];
        end
    endgenerate

    genvar iii;
    generate
    for(iii=N; iii<2*N-1; iii=iii+1) begin
        assign res[iii] = fin_sum[N-2][iii+1-N];
    end
    endgenerate

    if(N>1) assign res[2*N-1] = that_carry[N-2];


endmodule
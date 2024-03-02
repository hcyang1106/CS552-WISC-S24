module BrCond(Z, N, V, neq, eq, gt, lt, gte, lte, ovfl, uncond);

    input Z, N, V;
    output neq, eq, gt, lt, gte, lte, ovfl, uncond;

    assign neq = (Z == 0);
    assign eq = (Z == 1);
    assign gt = neq & (N == 0);
    assign lt = (N == 1);
    assign gte = eq | gt;
    assign lte = eq | lt;
    assign ovfl = (V == 1);
    assign uncond = 1;

endmodule
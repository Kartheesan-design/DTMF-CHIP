function f(a,b);
if (b) f = a;
endfunction

module mod (output reg y, input wire a, input wire b);
always @(a or b)
y = f(a,b);
endmodule


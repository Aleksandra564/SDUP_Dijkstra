`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module dijkstra_tb();

    parameter integer VERTICES = 11;    // vertices
    parameter integer N = 8;
    parameter MAX_VALUE = 2**N -1;

    // INPUT
    reg clk, rst, enable;
    reg [N-1:0] source = 5;
    reg [N-1:0] graph [0:VERTICES-1][0:VERTICES-1] = '{'{0, 5, 0, 0, 3, 0, 0, 0, 0, 0, 0}, '{5, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0}, '{0, 2, 0, 9, 0, 0, 0, 0, 0, 0, 0}, '{0, 1, 9, 0, 3, 0, 2, 5, 0, 0, 0}, '{3, 0, 0, 3, 0, 2, 0, 0, 0, 0, 0}, '{0, 0, 0, 0, 2, 0, 1, 0, 6, 0, 0}, '{0, 0, 0, 2, 0, 1, 0, 3, 0, 0, 0}, '{0, 0, 0, 0, 0, 0, 3, 0, 1, 0, 0}, '{0, 0, 0, 0, 0, 6, 0, 1, 0, 5, 9}, '{0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 3}, '{0, 0, 0, 0, 0, 0, 0, 0, 9, 3, 0}};
    
    // OUTPUT
    reg [N-1:0] distance [0:VERTICES-1] = '{default: MAX_VALUE};
    reg [N-1:0] prev [0:VERTICES-1] = '{default: 0};
    reg done;
    
    
    // Module
    dijkstra_rtl #(
        .VERTICES(VERTICES),
        .N(N),
        .MAX_VALUE(MAX_VALUE)
    ) dijkstra (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .source(source), 
        .graph(graph), 
        .distance(distance), 
        .prev(prev), 
        .done(done)
    );
    
    
    //Clock generator
    initial begin
        clk <= 1'b1;
    end
    
    always begin
        #5 clk <= ~clk;
    end
    
    //Reset signal
    initial begin
        rst <= 1'b1;
        #10 rst <= 1'b0;
    end
    
    //Other signals
    initial begin
        enable <= 1'b0;
        #20 enable <= 1'b1;

        @(posedge done);    // if done == 1
        
        foreach(distance[i]) $display("\t distance[%0d] = %0d", i, distance[i]);
        foreach(prev[i]) $display("\t prev[%0d] = %0d", i, prev[i]);
    end

endmodule

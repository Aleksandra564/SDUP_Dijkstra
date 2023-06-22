`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module dijkstra_tb();
    parameter integer VERTICES = 9;    // vertices
    parameter integer N = 8;
    parameter MAX_VALUE = 2**N -1;
    
    // INPUT
    reg clk, rst, enable;
    reg [N-1:0] source;
    reg [N-1:0] graph [0:VERTICES-1][0:VERTICES-1];
    
    reg enable_beh;
    reg [N-1:0] source_beh;
    reg [N-1:0] graph_beh [0:VERTICES-1][0:VERTICES-1];
    
    // OUTPUT
    reg [N-1:0] distance [0:VERTICES-1] = '{default: MAX_VALUE};
    reg [N-1:0] prev [0:VERTICES-1] = '{default: 0};
    reg done;
    
    reg [N-1:0] distance_beh [0:VERTICES-1] = '{default: MAX_VALUE};
    reg [N-1:0] prev_beh [0:VERTICES-1] = '{default: 0};
    
    
    reg [N-1:0] graph_1 [0:VERTICES-1][0:VERTICES-1] = '{'{0, 1, 1, 8, 0, 3, 0, 0, 0}, '{1, 0, 0, 0, 0, 0, 5, 0, 0}, '{1, 0, 0, 0, 0, 1, 0, 0, 0}, '{8, 0, 0, 0, 2, 0, 0, 0, 0}, '{0, 0, 0, 2, 0, 0, 0, 4, 0}, '{3, 0, 1, 0, 0, 0, 0, 2, 0}, '{0, 5, 0, 0, 0, 0, 0, 1, 1}, '{0, 0, 0, 0, 4, 2, 1, 0, 0}, '{0, 0, 0, 0, 0, 0, 1, 0, 0}};
    reg [N-1:0] graph_2 [0:VERTICES-1][0:VERTICES-1] = '{'{0, 1, 0, 0, 5, 0, 0, 0, 0}, '{1, 0, 1, 7, 0, 0, 0, 0, 0}, '{0, 1, 0, 0, 1, 2, 0, 0, 0}, '{0, 7, 0, 0, 0, 0, 4, 0, 0}, '{5, 0, 1, 0, 0, 0, 0, 3, 0}, '{0, 0, 2, 0, 0, 0, 6, 4, 1}, '{0, 0, 0, 4, 0, 6, 0, 0, 0}, '{0, 0, 0, 0, 3, 4, 0, 0, 0}, '{0, 0, 0, 0, 0, 1, 0, 0, 0}};
    
    // TASK
    task test_rtl(
        input reg [N-1:0] graph_in [0:VERTICES-1][0:VERTICES-1], 
        input reg [N-1:0] source_in
        );
        begin
            graph <= graph_in;
            source <= source_in;
            
            enable <= 1'b0;
            #20 enable <= 1'b1;
            #30 enable <= 1'b0;
    
            @(posedge done);    // if done == 1

            foreach(distance[i]) $display("\t distance[%0d] = %0d", i, distance[i]);
            foreach(prev[i]) $display("\t prev[%0d] = %0d", i, prev[i]);
            $display("");
        end
    endtask
    
    task test_beh(
        input reg [N-1:0] graph_beh_in [0:VERTICES-1][0:VERTICES-1], 
        input reg [N-1:0] source_beh_in
        );
        begin
            graph_beh <= graph_beh_in;
            source_beh <= source_beh_in;
            
            enable_beh <= 1'b0;
            #20 enable_beh <= 1'b1;
            #30 enable_beh <= 1'b0;

            foreach(distance_beh[i]) $display("\t distance_beh[%0d] = %0d", i, distance_beh[i]);
            foreach(prev_beh[i]) $display("\t prev_beh[%0d] = %0d", i, prev_beh[i]);
            $display("");
        end
    endtask
    
    // Module
    // RTL
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
    
    // BEHAV
    dijkstra_behav #(
        .VERTICES(VERTICES),
        .N(N),
        .MAX_VALUE(MAX_VALUE)
    ) behavioral (
        .enable(enable_beh),
        .source(source_beh), 
        .graph(graph_beh), 
        .distance(distance_beh), 
        .prev(prev_beh)
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
        $display("\t RTL:");
        $display("\t GRAPH 1, SOURCE = 0: \n");
        test_rtl(
        graph_1,
        0
        );
        
        $display("\t BEHAVIORAL:");
        $display("\t GRAPH 1, SOURCE = 0: \n");
        test_beh(
        graph_1,
        0
        );
        
        $display("\t RTL:");
        $display("\t GRAPH 1, SOURCE = 5: \n");
        test_rtl(
        graph_1,
        5
        );
        
        $display("\t BEHAVIORAL:");
        $display("\t GRAPH 1, SOURCE = 5: \n");
        test_beh(
        graph_1,
        5
        );
        
        $display("\t RTL:");
        $display("\t GRAPH 2, SOURCE = 0: \n");
        test_rtl(
        graph_2,
        0
        );
        
        $display("\t BEHAVIORAL:");
        $display("\t GRAPH 2, SOURCE = 0: \n");
        test_beh(
        graph_2,
        0
        );
        
        $display("\t RTL:");
        $display("\t GRAPH 2, SOURCE = 7: \n");
        test_rtl(
        graph_2,
        7
        );
        
        $display("\t BEHAVIORAL:");
        $display("\t GRAPH 2, SOURCE = 7: \n");
        test_beh(
        graph_2,
        7
        );
    end

endmodule

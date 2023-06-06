`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module dijkstra_behav();
    parameter integer VERTICES = 11;    // vertices
    parameter integer N = 8;

    // INPUT
    reg [N-1:0] source = 0;
    reg [N-1:0] graph [0:VERTICES-1][0:VERTICES-1] = '{'{0, 5, 0, 0, 3, 0, 0, 0, 0, 0, 0}, '{5, 0, 2, 1, 0, 0, 0, 0, 0, 0, 0}, '{0, 2, 0, 9, 0, 0, 0, 0, 0, 0, 0}, '{0, 1, 9, 0, 3, 0, 2, 5, 0, 0, 0}, '{3, 0, 0, 3, 0, 2, 0, 0, 0, 0, 0}, '{0, 0, 0, 0, 2, 0, 1, 0, 6, 0, 0}, '{0, 0, 0, 2, 0, 1, 0, 3, 0, 0, 0}, '{0, 0, 0, 0, 0, 0, 3, 0, 1, 0, 0}, '{0, 0, 0, 0, 0, 6, 0, 1, 0, 5, 9}, '{0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 3}, '{0, 0, 0, 0, 0, 0, 0, 0, 9, 3, 0}};
    
    // OUTPUT
    reg [N-1:0] distance [0:VERTICES-1] = '{default: 2**N -1};    // max mo¿liwa wartoœæ
    reg [N-1:0] prev [0:VERTICES-1] = '{default: 0};        // 0 zamiast None
    
    // OTHER VARIABLES
    reg visited [0:VERTICES-1] = '{default: 0};
    reg [N-1:0] min_dist = 2**N -1;
    reg [N-1:0] u;
    reg [N-1:0] edge_val;
    reg [N-1:0] alt;
    
    integer i, v, neighbor;
    
//////////////////////////////////////////////////////////////////////////////////
    initial begin
//        foreach(graph[i]) $display("\t graph[%0d] = %0d", i, graph[i]);
//        foreach(distance[i]) $display("\t distance[%0d] = %0d", i, distance[i]);
//        foreach(prev[i]) $display("\t prev[%0d] = %0d", i, prev[i]);
        distance[source] = 0;
        
        for (i = 0; i < VERTICES; i = i + 1) begin
            min_dist = 2**N -1;
            for (v = 0; v < VERTICES; v = v + 1) begin
                if (visited[v] == 0 && distance[v] < min_dist) begin
                    min_dist = distance[v];
                    u = v;
                end
            end
            visited[u] = 1;
            
            for (neighbor = 0; neighbor < VERTICES; neighbor = neighbor + 1) begin
                edge_val = graph[u][neighbor];
                if (edge_val != 0) begin
                    alt = distance[u] + edge_val;
                    if (alt < distance[neighbor]) begin
                        distance[neighbor] = alt;
                        prev[neighbor] = u;
                    end
                end
            end
            
        end
        foreach(distance[i]) $display("\t distance[%0d] = %0d", i, distance[i]);
        foreach(prev[i]) $display("\t prev[%0d] = %0d", i, prev[i]);
    end

endmodule

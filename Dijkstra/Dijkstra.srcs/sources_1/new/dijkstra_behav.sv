`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module dijkstra_behav #(
    parameter integer VERTICES = 11,    // vertices
    parameter integer N = 8,
    parameter MAX_VALUE = 2**N -1
    )(
    // INPUT
    input reg enable,
    input reg [N-1:0] source,
    input reg [N-1:0] graph [0:VERTICES-1][0:VERTICES-1],
    
    // OUTPUT
    output reg [N-1:0] distance [0:VERTICES-1] = '{default: MAX_VALUE},    // max mo¿liwa wartoœæ
    output reg [N-1:0] prev [0:VERTICES-1] = '{default: 0}        // 0 zamiast None
    );
    
    // OTHER VARIABLES
    reg visited [0:VERTICES-1] = '{default: 0};
    reg [N-1:0] min_dist = MAX_VALUE;
    reg [N-1:0] u;
    reg [N-1:0] edge_val;
    reg [N-1:0] alt;
    
    integer i, v, neighbor;
    
//////////////////////////////////////////////////////////////////////////////////
    always_comb begin
        if (enable == 1) begin
            distance = '{default: MAX_VALUE};
            prev = '{default: 0};
            distance[source] = 0;
            visited = '{default: 0};
            
            for (i = 0; i < VERTICES; i = i + 1) begin
                min_dist = MAX_VALUE;
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
        end
    end

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
 
module dijkstra_rtl #(
    parameter integer VERTICES = 11,    // vertices
    parameter integer N = 8,
    parameter MAX_VALUE = 2**N -1
    )(
    // INPUT
    input reg clk, rst, enable,
    input reg [N-1:0] source,
    input reg [N-1:0] graph [0:VERTICES-1][0:VERTICES-1],
    
    // OUTPUT
    output reg [N-1:0] distance [0:VERTICES-1] = '{default: MAX_VALUE},    // max mo¿liwa wartoœæ
    output reg [N-1:0] prev [0:VERTICES-1] = '{default: 0},        // 0 zamiast None
    output reg done = 0
    );
    
    // STATE MACHINE
    typedef enum {IDLE, FIND_NEAREST_UNVISITED_VERTEX, FIND_ALTERNATIVE_PATH} state_t;
    state_t state;
    
    // OTHER VARIABLES
    reg visited [0:VERTICES-1] = '{default: 0};
    reg [N-1:0] min_dist = MAX_VALUE;
    reg [N-1:0] u;
    reg [N-1:0] edge_val;
    reg [N-1:0] alt;
    reg [N-1:0] counter, vertices_counter, neighbors_counter;   // [N-1:0] zamiast [VERTICES-1:0], bo maksymalny mo¿liwy dystans te¿ jest tak ograniczony
    
    //NEXTS
    reg [N-1:0] distance_nxt [0:VERTICES-1] = '{default: MAX_VALUE};    // max mo¿liwa wartoœæ
    reg [N-1:0] prev_nxt [0:VERTICES-1] = '{default: 0};        // 0 zamiast None
    reg visited_nxt [0:VERTICES-1] = '{default: 0};
    reg [N-1:0] min_dist_nxt = MAX_VALUE;
    reg [N-1:0] u_nxt;
    reg [N-1:0] counter_nxt, vertices_counter_nxt, neighbors_counter_nxt;
    reg done_nxt;
    state_t state_nxt;
    
//////////////////////////////////////////////////////////////////////////////////
    always@(posedge clk) begin
        if (rst == 1) begin
            distance <= '{default: MAX_VALUE};
            prev <= '{default: 0};
            visited <= '{default: 0};
            state <= IDLE;
            min_dist <= MAX_VALUE;
            u <= 0;
            counter <= 0;
            vertices_counter <= 0;
            neighbors_counter <= 0;
            done <= 0;
        end
        else begin
            distance <= distance_nxt;
            prev <= prev_nxt;
            visited <= visited_nxt;
            state <= state_nxt;
            min_dist <= min_dist_nxt;
            u <= u_nxt;
            counter <= counter_nxt;
            vertices_counter <= vertices_counter_nxt;
            neighbors_counter <= neighbors_counter_nxt;
            done <= done_nxt;
        end
    end
 
//////////////////////////////////////////////////////////////////////////////////
 
    always_comb begin
        case(state)
            /////////////////////////////////////////////////////////////////////
            IDLE: begin
                if (enable == 1) begin
                    distance_nxt = '{default: MAX_VALUE};
                    prev_nxt = '{default: 0};
                    visited_nxt = '{default: 0};
                    distance_nxt[source] = 0;
                    done_nxt = 0;
 
                    min_dist_nxt = MAX_VALUE;
                    vertices_counter_nxt = 0;
                    neighbors_counter_nxt = 0;
                    counter_nxt = 0;
                    state_nxt = FIND_NEAREST_UNVISITED_VERTEX;
                end
                else begin
                    state_nxt = IDLE;
                end
            end
           /////////////////////////////////////////////////////////////////////
           FIND_NEAREST_UNVISITED_VERTEX: begin
                if (vertices_counter < VERTICES) begin
                    if (visited_nxt[vertices_counter] == 0 && distance[vertices_counter] < min_dist) begin
                        min_dist_nxt = distance[vertices_counter];
                        u_nxt = vertices_counter;    // przypisuje numer nieodwiedzonego wierzcho³ka o najmniejszym dist do zmiennej u
                    end
                    vertices_counter_nxt = vertices_counter + 1;
                    state_nxt = FIND_NEAREST_UNVISITED_VERTEX;
                end
                else begin
                    visited_nxt[u] = 1;
                    vertices_counter_nxt = 0;
                    state_nxt = FIND_ALTERNATIVE_PATH;
                end
            end
            /////////////////////////////////////////////////////////////////////
            FIND_ALTERNATIVE_PATH: begin
                if (neighbors_counter < VERTICES) begin
                    edge_val = graph[u][neighbors_counter];
                    if (edge_val != 0) begin
                        alt = distance[u] + edge_val;
                        if (alt < distance[neighbors_counter]) begin
                            distance_nxt[neighbors_counter] = alt;
                            prev_nxt[neighbors_counter] = u;
                        end
                    end
                    neighbors_counter_nxt = neighbors_counter + 1;
                    state_nxt = FIND_ALTERNATIVE_PATH;
                end
                else if (counter < VERTICES) begin
                    min_dist_nxt = MAX_VALUE;
                    neighbors_counter_nxt = 0;
                    counter_nxt = counter + 1;
                    state_nxt = FIND_NEAREST_UNVISITED_VERTEX;
                end
                else begin
                    counter_nxt = 0;
                    done_nxt = 1;
                    state_nxt = IDLE;
                end
            end
            /////////////////////////////////////////////////////////////////////
        endcase
    end
    
endmodule

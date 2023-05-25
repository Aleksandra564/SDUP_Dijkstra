def Dijkstra(graph, source):
  graph_length = len(graph)
  visited = [False]*graph_length
  counter = 0
  dist = [float("inf")]*graph_length
  prev = [None]*graph_length

  dist[source] = 0

  while counter < graph_length:
    counter += 1
    min_dist = float("inf")

    for v in range(graph_length):
      if not visited[v] and dist[v] < min_dist:
        min_dist = dist[v]
        u = v               # przypisuje numer nieodwiedzonego wierzchołka o najmniejszym dist do zmiennej u
    visited[u] = True

    for neighbor in range(graph_length):
      edge = graph[u][neighbor]
      if edge != 0:
        alt = dist[u] + edge
        if alt < dist[neighbor]:
          dist[neighbor] = alt
          prev[neighbor] = u
  
  return dist, prev


########## TEST ##########
graph = [[0, 1, 1, 8, 0, 3, 0, 0, 0], [1, 0, 0, 0, 0, 0, 5, 0, 0], [1, 0, 0, 0, 0, 1, 0, 0, 0], [8, 0, 0, 0, 2, 0, 0, 0, 0], [0, 0, 0, 2, 0, 0, 0, 4, 0], [3, 0, 1, 0, 0, 0, 0, 2, 0], [0, 5, 0, 0, 0, 0, 0, 1, 1], [0, 0, 0, 0, 4, 2, 1, 0, 0], [0, 0, 0, 0, 0, 0, 1, 0, 0]]
source = graph[0][0]  # rząd, kolumna

dist, prev = Dijkstra(graph, source)

print("dist:", dist)
print("prev:", prev)

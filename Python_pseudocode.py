def Dijkstra(graph, source):
  graph_length = len(graph)
  Q = [0]*graph_length
  counter = 0
  dist = [float("inf")]*graph_length
  prev = [None]*graph_length

  for v in range(graph_length):
    Q[v] = v
  dist[source] = 0

  while counter < graph_length:
    counter += 1
    min_dist = float("inf")
    for v in range(len(Q)):
      vertex = Q[v]
      if dist[v] < min_dist and vertex != 9999:
        min_dist = dist[v]
        u = vertex               # przypisuje numer nieodwiedzonego wierzchołka o najmniejszym dist do zmiennej u
    for i in range(len(Q)):
      if Q[i] == u:
        Q[i] = 9999

    for neighbor in range(graph_length):
      edge = graph[u][neighbor]
      for j in Q:
        if j == neighbor and edge != 0:
          alt = dist[u] + edge
          if alt < dist[neighbor]:
            dist[neighbor] = alt
            prev[neighbor] = u
  
  return dist, prev

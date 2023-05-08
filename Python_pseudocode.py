def Dijkstra(graph, source):
  Q = []
  dist = [float("inf")]*len(graph)
  prev = [None]*len(graph)

  for v in range(len(graph)):
    Q.append(v)
  dist[source] = 0
  # print("dist[source] =", dist[source])       #

  while Q:
    # print("Q =", Q)                           #
    # print("v =", v)                           #
    # print("min_dist =", min_dist)             #

    min_dist = float("inf")
    for v in Q:
    # print("v =", v)                           #
    # print("min_dist =", min_dist)             #
      if dist[v] < min_dist:
        min_dist = dist[v]
        u = v
    # print("dist[v] =", dist[v])               #
    # print("min_dist =", min_dist)             #
    Q.remove(u)

    for neighbor in range(len(graph)):
      # print("neighbor =", neighbor)           #
      edge = graph[u][neighbor]
      # print("edge =", edge)                   #
      if neighbor in Q and edge != 0:
        alt = dist[u] + edge
        if alt < dist[neighbor]:
          dist[neighbor] = alt
          prev[neighbor] = u
  
  return dist, prev



graph = [[0, 1, 1, 8, 0, 3, 0, 0, 0], [1, 0, 0, 0, 0, 0, 5, 0, 0], [1, 0, 0, 0, 0, 1, 0, 0, 0], [8, 0, 0, 0, 2, 0, 0, 0, 0], [0, 0, 0, 2, 0, 0, 0, 4, 0], [3, 0, 1, 0, 0, 0, 0, 2, 0], [0, 5, 0, 0, 0, 0, 0, 1, 1], [0, 0, 0, 0, 4, 2, 1, 0, 0], [0, 0, 0, 0, 0, 0, 1, 0, 0]]
source = graph[0][0]  # rząd, kolumna

dist, prev = Dijkstra(graph, source)

print("dist:", dist)
print("prev:", prev)

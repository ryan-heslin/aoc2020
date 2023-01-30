# Rough idea:
# Map each tile to edge neighbors
# For each tile, note edges of each rotation-flip combination (12 per tile)
# DFS:
# Start with any tile in corner
#
# Try each tile that meets it on left
# Fill first row, then second, stopping if no tile matches all new edges
# Maybe feasible if few neighbors for each tile

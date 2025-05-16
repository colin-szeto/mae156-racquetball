# Input points
points = [
    [309, 124],
    [305, 207],
    [229, 207],
    [226, 283],
    [302, 289],
    [302, 363],
    [379, 364],
    [383, 291],
    [460, 292],
    [463, 216],
    [385, 211],
    [388, 127]
]

# Sort by x-value
points_sorted = sorted(points, key=lambda p: p[0])

# Group by x-value similarity (within 20 units)
groups = []
current_group = [points_sorted[0]]

for point in points_sorted[1:]:
    if abs(point[0] - current_group[-1][0]) <= 20:
        current_group.append(point)
    else:
        groups.append(current_group)
        current_group = [point]

# Append the final group
groups.append(current_group)

# Print grouped points
# for i, group in enumerate(groups):
#     print(f"Group {i + 1}: {group}")
    
    
# Sort groups by their length (ascending)
groups_sorted_by_size = sorted(groups, key=lambda g: len(g))

# Get the two smallest groups
smallest_two_groups = groups_sorted_by_size[:2]

# Print them
for i, group in enumerate(smallest_two_groups, start=1):
    print(f"Smallest Group {i} (size {len(group)}): {group}")


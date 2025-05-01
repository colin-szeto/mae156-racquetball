import ezdxf
import csv

def extract_points_from_dxf(file_path):
    doc = ezdxf.readfile(file_path)
    msp = doc.modelspace()

    points = []

    for entity in msp:
        if entity.dxftype() == 'POINT':
            x, y, z = entity.dxf.location
            points.append((x, y))
        elif entity.dxftype() == 'LINE':
            points.append((entity.dxf.start.x, entity.dxf.start.y))
            points.append((entity.dxf.end.x, entity.dxf.end.y))
        elif entity.dxftype() == 'CIRCLE':
            points.append((entity.dxf.center.x, entity.dxf.center.y))
        elif entity.dxftype() == 'ARC':
            points.append((entity.dxf.center.x, entity.dxf.center.y))

    return points

def save_points_to_csv(points, output_file):
    with open(output_file, 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["X", "Y"])  # CSV header
        writer.writerows(points)

# Example usage
if __name__ == "__main__":
    dxf_file = "20250430.dxf"  # Input DXF file
    csv_file = "20250430.csv"  # Output CSV file

    points = extract_points_from_dxf(dxf_file)
    save_points_to_csv(points, csv_file)

    print(f"Saved {len(points)} points to '{csv_file}'")

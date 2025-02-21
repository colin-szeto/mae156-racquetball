import re
import pandas as pd
import xml.etree.ElementTree as ET

# Load the SVG file
svg_file_path = "IMG_0543 test 4.svg"

# Parse the SVG content
tree = ET.parse(svg_file_path)
root = tree.getroot()

# Namespace handling (if needed)
namespace = {'svg': 'http://www.w3.org/2000/svg'}

# Extract all <path> elements
paths = root.findall('.//{http://www.w3.org/2000/svg}path', namespace)

# Regular expression to find "M x,y" values
move_command_pattern = re.compile(r'M ([\d\.\-]+),([\d\.\-]+)')

# List to store extracted values
data = []

for path in paths:
    d_attr = path.get('d', '')
    matches = move_command_pattern.findall(d_attr)
    for match in matches:
        x, y = float(match[0]), float(match[1])
        data.append((x, y))

# Convert to DataFrame
df = pd.DataFrame(data, columns=['X (pixels)', 'Y (pixels)'])
dfx = df['X (pixels)']
print(df.to_string(index=False, header=False))

#dfy = df['Y (pixels)']
#print(df.to_string(index=False, header=False))


## Display table
#import ace_tools as tools
#tools.display_dataframe_to_user(name="Extracted M Values from SVG", dataframe=df)

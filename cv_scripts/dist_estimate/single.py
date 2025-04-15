import cv2
import numpy as np
import glob
import math

# Load the image
fname = "2025-04-14-181010_142.jpg"
image = cv2.imread(fname)
print(fname)
hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

### === BLACK DETECTION === ###
lower_black = np.array([0, 0, 0])
upper_black = np.array([180, 50, 100])
mask_black = cv2.inRange(hsv, lower_black, upper_black)

### === WHITE DETECTION === ###
lower_white = np.array([0, 0, 180])
upper_white = np.array([180, 60, 255])
mask_white = cv2.inRange(hsv, lower_white, upper_white)
cv2.imshow("mask_white", mask_white)
cv2.waitKey(0)

# Clean noise from both masks
kernel = np.ones((5, 5), np.uint8)
mask_black = cv2.morphologyEx(mask_black, cv2.MORPH_CLOSE, kernel)
mask_black = cv2.morphologyEx(mask_black, cv2.MORPH_OPEN, kernel)
mask_white = cv2.morphologyEx(mask_white, cv2.MORPH_CLOSE, kernel)
mask_white = cv2.morphologyEx(mask_white, cv2.MORPH_OPEN, kernel)

# Store centroids
black_centroids = []
white_centroids = []

### === CONTOURS FOR BLACK === ###
contours_black, _ = cv2.findContours(mask_black, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
for cnt in contours_black:
    area = cv2.contourArea(cnt)
    if area > 1000:
        approx = cv2.approxPolyDP(cnt, 0.02 * cv2.arcLength(cnt, True), True)
        if len(approx) == 12:
            cv2.drawContours(image, [cnt], -1, (0, 255, 0), 3)
            x, y, w, h = cv2.boundingRect(cnt)
            cv2.rectangle(image, (x, y), (x+w, y+h), (255, 0, 0), 2)
            cv2.putText(image, 'Black Cross', (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255, 255, 255), 2)

            # Compute centroid
            M = cv2.moments(cnt)
            if M['m00'] != 0.0:
                c_x = int(M['m10']/M['m00'])
                c_y = int(M['m01']/M['m00'])
                black_centroids.append((c_x, c_y))
                cv2.circle(image, (c_x, c_y), 10, (50, 168, 82), -1)

### === CONTOURS FOR WHITE === ###
contours_white, _ = cv2.findContours(mask_white, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
for cnt in contours_white:
    area = cv2.contourArea(cnt)
    if area > 1000:
        approx = cv2.approxPolyDP(cnt, 0.02 * cv2.arcLength(cnt, True), True)
        if len(approx) >= 4:
            x, y, w, h = cv2.boundingRect(cnt)
            aspect_ratio = float(w) / h
            # if 0.9 < aspect_ratio < 1.1:  # optional: check for square
            cv2.drawContours(image, [cnt], -1, (0, 255, 255), 3)
            cv2.rectangle(image, (x, y), (x+w, y+h), (0, 0, 255), 2)
            cv2.putText(image, 'White Square', (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 0), 2)

            # Compute centroid
            M = cv2.moments(cnt)
            if M['m00'] != 0.0:
                c_x = int(M['m10']/M['m00'])
                c_y = int(M['m01']/M['m00'])
                white_centroids.append((c_x, c_y))
                cv2.circle(image, (c_x, c_y), 10, (50, 168, 82), -1)

### === FIND CLOSEST BLACK CROSS TO WHITE SQUARE === ###
min_distance = float('inf')
closest_black = None

for bc in black_centroids:
    for wc in white_centroids:
        dist = math.hypot(bc[0] - wc[0], bc[1] - wc[1])
        if dist < min_distance:
            min_distance = dist
            closest_black = bc

# Highlight closest match
if closest_black:
    print(f"Closest black cross centroid to a white square is at: {closest_black} (distance: {min_distance:.2f})")
    cv2.circle(image, closest_black, 15, (0, 0, 255), 3)
    cv2.putText(image, 'Closest Cross', (closest_black[0] + 10, closest_black[1]),
                cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 255), 2)

# Show result
cv2.imshow("Detected Shapes", image)
cv2.waitKey(0)
cv2.destroyAllWindows()

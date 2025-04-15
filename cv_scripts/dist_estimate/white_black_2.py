import cv2
import numpy as np
import glob
import math

# === Calibration Constants ===
REAL_WIDTH_INCHES = 18.5           # Real-world width of black cross
FOCAL_LENGTH = 588.3843844         # Replace with your own calibrated focal length

# Read all .jpg images in descending order
images = sorted(glob.glob('*.jpg'), reverse=True)

for fname in images:
    image = cv2.imread(fname)
    print(fname)
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

    ### === BLACK DETECTION === ###
    lower_black = np.array([0, 0, 0])
    upper_black = np.array([180, 50, 100])
    mask_black = cv2.inRange(hsv, lower_black, upper_black)
    cv2.imshow("mask_black", mask_black)
    cv2.waitKey(0)

    ### === WHITE DETECTION === ###
    lower_white = np.array([0, 0, 120])
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

    # Store centroids and shape sizes
    black_info = []         # List of (centroid, width, height)
    black_centroids = []    # Just centroids for drawing
    white_centroids = []

    ### === CONTOURS FOR BLACK === ###
    contours_black, _ = cv2.findContours(mask_black, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    for cnt in contours_black:
        area = cv2.contourArea(cnt)
        if area > 1000:
            approx = cv2.approxPolyDP(cnt, 0.02 * cv2.arcLength(cnt, True), True)
            if len(approx) == 12:
                x, y, w, h = cv2.boundingRect(cnt)
                cv2.drawContours(image, [cnt], -1, (0, 255, 0), 3)
                cv2.rectangle(image, (x, y), (x+w, y+h), (255, 0, 0), 2)
                cv2.putText(image, 'Black Cross', (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255, 255, 255), 2)

                M = cv2.moments(cnt)
                if M['m00'] != 0.0:
                    c_x = int(M['m10'] / M['m00'])
                    c_y = int(M['m01'] / M['m00'])
                    black_centroids.append((c_x, c_y))
                    black_info.append(((c_x, c_y), w, h))
                    cv2.circle(image, (c_x, c_y), 10, (50, 168, 82), -1)

    ### === CONTOURS FOR WHITE === ###
    contours_white, _ = cv2.findContours(mask_white, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    for cnt in contours_white:
        area = cv2.contourArea(cnt)
        if area > 1000:
            approx = cv2.approxPolyDP(cnt, 0.02 * cv2.arcLength(cnt, True), True)
            if len(approx) >= 4:
                x, y, w, h = cv2.boundingRect(cnt)
                cv2.drawContours(image, [cnt], -1, (0, 255, 255), 3)
                cv2.rectangle(image, (x, y), (x+w, y+h), (255, 87, 51), 2)
                cv2.putText(image, 'White Square', (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (0, 0, 0), 2)

                M = cv2.moments(cnt)
                if M['m00'] != 0.0:
                    c_x = int(M['m10'] / M['m00'])
                    c_y = int(M['m01'] / M['m00'])
                    white_centroids.append((c_x, c_y))
                    cv2.circle(image, (c_x, c_y), 10, (191, 64, 191), -1)

    ### === FIND CLOSEST BLACK CROSS TO WHITE SQUARE === ###
    min_distance = float('inf')
    closest_black = None
    closest_w = None
    closest_h = None

    for (bc, bw, bh) in black_info:
        for wc in white_centroids:
            dist = math.hypot(bc[0] - wc[0], bc[1] - wc[1])
            if dist < min_distance:
                min_distance = dist
                closest_black = bc
                closest_w = bw
                closest_h = bh

    # Highlight closest match and estimate distance
    if closest_black:
        estimated_distance = (REAL_WIDTH_INCHES * FOCAL_LENGTH) / closest_w
        print(f"Closest black cross centroid to a white square is at: {closest_black} "
              f"(distance: {min_distance:.2f} px, width: {closest_w}px, height: {closest_h}px, "
              f"estimated distance: {estimated_distance:.2f} inches)")
        
        cv2.circle(image, closest_black, 15, (0, 0, 255), 3)
        label = f'{fname[-7:-4]}: {closest_w}x{closest_h}px, {estimated_distance:.1f}"'
        cv2.putText(image, label, (closest_black[0] + 10, closest_black[1]),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 255), 2)

    # Show result
    cv2.imshow("Detected Shapes", image)
    cv2.waitKey(0)

cv2.destroyAllWindows()

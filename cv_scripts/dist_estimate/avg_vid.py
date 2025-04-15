import cv2
import numpy as np
import math

# === Calibration Constants ===
REAL_WIDTH_INCHES = 18.5
FOCAL_LENGTH = 588.3843844

# Load video
cap = cv2.VideoCapture('2025-02-16-151324.webm')
save_frame = True

# Check if camera opened successfully
if not cap.isOpened():
    print("Error opening video file")
    exit()

# Get frame dimensions
ret, frame = cap.read()
if not ret:
    print("Failed to read first frame.")
    cap.release()
    exit()

height, width, _ = frame.shape

# Setup video writer
if save_frame:
    fourcc = cv2.VideoWriter_fourcc(*'XVID')
    out = cv2.VideoWriter('output2.avi', fourcc, 20.0, (width, height))

# Reset video to beginning
cap.set(cv2.CAP_PROP_POS_FRAMES, 0)

# === Rolling average tracking ===
rolling_window = 100
black_centroid_history = []

# Process video
while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    image = frame.copy()
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

    # HSV Ranges
    lower_black = np.array([0, 0, 0])
    upper_black = np.array([180, 80, 100])
    lower_white = np.array([0, 0, 170])
    upper_white = np.array([180, 60, 255])

    # Masks
    mask_black = cv2.inRange(hsv, lower_black, upper_black)
    mask_white = cv2.inRange(hsv, lower_white, upper_white)

    # Morphology
    kernel = np.ones((5, 5), np.uint8)
    mask_black = cv2.morphologyEx(mask_black, cv2.MORPH_CLOSE, kernel)
    mask_black = cv2.morphologyEx(mask_black, cv2.MORPH_OPEN, kernel)
    mask_white = cv2.morphologyEx(mask_white, cv2.MORPH_CLOSE, kernel)
    mask_white = cv2.morphologyEx(mask_white, cv2.MORPH_OPEN, kernel)

    black_info = []
    white_centroids = []
    contours_white = []

    # === Detect black crosses ===
    contours_black, _ = cv2.findContours(mask_black, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    for cnt in contours_black:
        area = cv2.contourArea(cnt)
        if area > 1000:
            approx = cv2.approxPolyDP(cnt, 0.02 * cv2.arcLength(cnt, True), True)
            if len(approx) == 12:
                x, y, w, h = cv2.boundingRect(cnt)
                M = cv2.moments(cnt)
                if M['m00'] != 0.0:
                    c_x = int(M['m10'] / M['m00'])
                    c_y = int(M['m01'] / M['m00'])
                    black_info.append(((c_x, c_y), w, h, cnt))

    # === Detect white squares ===
    contours_white_all, _ = cv2.findContours(mask_white, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    for cnt in contours_white_all:
        area = cv2.contourArea(cnt)
        if area > 1000:
            approx = cv2.approxPolyDP(cnt, 0.02 * cv2.arcLength(cnt, True), True)
            if len(approx) >= 4:
                M = cv2.moments(cnt)
                if M['m00'] != 0.0:
                    c_x = int(M['m10'] / M['m00'])
                    c_y = int(M['m01'] / M['m00'])
                    white_centroids.append((c_x, c_y))
                    contours_white.append(cnt)

    # === Filter & track closest black cross ===
    closest_black = None
    closest_w = None
    closest_h = None
    closest_black_contour = None
    closest_white = None
    closest_white_contour = None

    if black_info:
        black_info.sort(key=lambda b: b[1], reverse=True)
        (bc, bw, bh, b_contour) = black_info[0]

        # Rolling average
        black_centroid_history.append(bc)
        if len(black_centroid_history) > rolling_window:
            black_centroid_history.pop(0)

        avg_x = sum(pt[0] for pt in black_centroid_history) / len(black_centroid_history)
        avg_y = sum(pt[1] for pt in black_centroid_history) / len(black_centroid_history)
        position_tolerance = 50

        if abs(bc[0] - avg_x) < position_tolerance and abs(bc[1] - avg_y) < position_tolerance:
            closest_black = bc
            closest_w = bw
            closest_h = bh
            closest_black_contour = b_contour

            # Find closest white square
            min_white_dist = float('inf')
            for i, wc in enumerate(white_centroids):
                d = math.hypot(bc[0] - wc[0], bc[1] - wc[1])
                if d < min_white_dist:
                    min_white_dist = d
                    closest_white = wc
                    closest_white_contour = contours_white[i]

            # === Draw BLACK cross ===
            estimated_distance = (REAL_WIDTH_INCHES * FOCAL_LENGTH) / closest_w
            print(f"Stable black cross at {closest_black} | "
                  f"Size: {closest_w}x{closest_h}px | Distance: {estimated_distance:.2f} inches")

            cv2.drawContours(image, [closest_black_contour], -1, (0, 255, 0), 2)
            cv2.circle(image, closest_black, 15, (0, 0, 255), 3)
            label = f'{closest_w}x{closest_h}px, {estimated_distance:.1f}"'
            cv2.putText(image, label, (closest_black[0] + 10, closest_black[1]),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 0, 255), 2)

            # === Draw closest WHITE square ===
            if closest_white_contour is not None:
                cv2.drawContours(image, [closest_white_contour], -1, (0, 255, 255), 2)
                cv2.circle(image, closest_white, 10, (255, 255, 0), 2)
                cv2.putText(image, 'Closest White', (closest_white[0] + 10, closest_white[1]),
                            cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 0), 2)

    # Show and optionally save
    cv2.imshow("Detected Shapes", image)
    if save_frame:
        out.write(image)

    if cv2.waitKey(25) & 0xFF == ord('q'):
        break

# Clean up
cap.release()
if save_frame:
    out.release()
cv2.destroyAllWindows()

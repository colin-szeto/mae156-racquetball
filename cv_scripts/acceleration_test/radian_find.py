import cv2
import numpy as np
import math
import pandas as pd

# Open video
video = cv2.VideoCapture('indexer.mp4')
max_width, max_height = 800, 600

# Reference circle parameters
reference_center = (262, 210)
reference_diameter = 200
reference_radius = reference_diameter / 2

# Physics tracking
last_angle = None
last_angular_velocity = None
frame_time = 1 / 30  # Assuming 30 FPS

save_to_csv = True
csv_data = []

def get_centroid(contour):
    M = cv2.moments(contour)
    if M["m00"] != 0:
        return int(M["m10"] / M["m00"]), int(M["m01"] / M["m00"])
    return None

while True:
    ret, frame = video.read()
    if not ret:
        break

    # Resize frame
    h, w = frame.shape[:2]
    scale = min(max_width / w, max_height / h)
    frame = cv2.resize(frame, (int(w * scale), int(h * scale)))

    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

    # Tape HSV mask
    lower_tape = np.array([18, 30, 200])
    upper_tape = np.array([25, 65, 245])
    mask_tape = cv2.inRange(hsv, lower_tape, upper_tape)

    # Sharpie HSV mask
    lower_sharpie = np.array([10, 40, 100])
    upper_sharpie = np.array([20, 150, 220])
    mask_sharpie = cv2.inRange(hsv, lower_sharpie, upper_sharpie)

    # Find tape
    contours_tape, _ = cv2.findContours(mask_tape, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    tape_centroid = None
    if contours_tape:
        largest_tape = max(contours_tape, key=cv2.contourArea)
        if cv2.contourArea(largest_tape) > 300:
            tape_centroid = get_centroid(largest_tape)

    # Find sharpie
    contours_sharpie, _ = cv2.findContours(mask_sharpie, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    closest_sharpie_contour = None
    closest_sharpie_centroid = None
    min_distance = float('inf')

    for contour in contours_sharpie:
        area = cv2.contourArea(contour)
        if area > 10:
            centroid = get_centroid(contour)
            if centroid and tape_centroid:
                dist = np.linalg.norm(np.array(centroid) - np.array(tape_centroid))
                if dist < min_distance:
                    min_distance = dist
                    closest_sharpie_contour = contour
                    closest_sharpie_centroid = centroid

    # Draw reference circle and crosshairs
    x, y = reference_center
    r = int(reference_radius)
    cv2.circle(frame, reference_center, r, (200, 200, 0), 2)
    cv2.line(frame, (x - r, y), (x + r, y), (200, 200, 0), 1)
    cv2.line(frame, (x, y - r), (x, y + r), (200, 200, 0), 1)

    if closest_sharpie_contour is not None and closest_sharpie_centroid:
        cx, cy = closest_sharpie_centroid
        cv2.drawContours(frame, [closest_sharpie_contour], -1, (0, 255, 0), 2)
        cv2.circle(frame, (cx, cy), 5, (255, 0, 255), -1)
        cv2.putText(frame, f"{(cx, cy)}", (cx + 10, cy), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 255), 2)

        # Calculate angle
        dx = cx - reference_center[0]
        dy = cy - reference_center[1]
        angle = math.atan2(dy, dx)
        angle_deg = math.degrees(angle)
        if angle_deg < 0:
            angle_deg += 360

        # Angular motion
        angular_velocity = angular_acceleration = None
        if last_angle is not None:
            dtheta = angle - last_angle
            angular_velocity = dtheta / frame_time
            if last_angular_velocity is not None:
                angular_acceleration = (angular_velocity - last_angular_velocity) / frame_time

        # Draw angle info
        cv2.putText(frame, f"Angle: {angle_deg:.2f} deg", (10, 30),
                    cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 255, 255), 2)
        if angular_velocity is not None:
            cv2.putText(frame, f"Angular Vel: {math.degrees(angular_velocity):.2f} deg/s", (10, 60),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 200, 255), 2)
        if angular_acceleration is not None:
            cv2.putText(frame, f"Angular Accel: {math.degrees(angular_acceleration):.2f} deg/s²", (10, 90),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.6, (0, 150, 255), 2)

        # Update state
        last_angle = angle
        last_angular_velocity = angular_velocity

        # Save to CSV
        if save_to_csv:
            csv_data.append({
                "frame": int(video.get(cv2.CAP_PROP_POS_FRAMES)),
                "time": video.get(cv2.CAP_PROP_POS_MSEC) / 1000.0,
                "angle_deg": angle_deg,
                "angular_velocity_deg_s": math.degrees(angular_velocity) if angular_velocity else None,
                "angular_acceleration_deg_s2": math.degrees(angular_acceleration) if angular_acceleration else None,
                "centroid_x": cx,
                "centroid_y": cy
            })

    # Display result
    cv2.imshow("Rotational Tracking", frame)
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

video.release()
cv2.destroyAllWindows()

# Save CSV data to file
if save_to_csv and csv_data:
    df = pd.DataFrame(csv_data)
    df.to_csv("sharpie_rotation_data.csv", index=False)
    print("CSV saved as 'sharpie_rotation_data.csv'")

import cv2
import numpy as np

# Open video
video = cv2.VideoCapture('indexer.mp4')

max_width, max_height = 800, 600

def mouse_event(event, x, y, flags, param):
    if event == cv2.EVENT_LBUTTONDOWN:
        hsv_val = param[y, x]
        print(f'HSV at ({x},{y}) = {hsv_val}')

def get_centroid(contour):
    M = cv2.moments(contour)
    if M["m00"] != 0:
        return int(M["m10"] / M["m00"]), int(M["m01"] / M["m00"])
    return None

while True:
    ret, frame = video.read()
    if not ret:
        break

    # Resize
    h, w = frame.shape[:2]
    scale = min(max_width / w, max_height / h)
    frame = cv2.resize(frame, (int(w * scale), int(h * scale)))

    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

    # Tape HSV mask (based on averaged samples)
    lower_tape = np.array([18, 30, 200])
    upper_tape = np.array([25, 65, 245])
    mask_tape = cv2.inRange(hsv, lower_tape, upper_tape)

    # Sharpie HSV mask
    lower_sharpie = np.array([10, 40, 100])
    upper_sharpie = np.array([20, 150, 220])
    mask_sharpie = cv2.inRange(hsv, lower_sharpie, upper_sharpie)

    # Find tape contour
    contours_tape, _ = cv2.findContours(mask_tape, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    tape_centroid = None

    if contours_tape:
        largest_tape = max(contours_tape, key=cv2.contourArea)
        if cv2.contourArea(largest_tape) > 300:
            tape_centroid = get_centroid(largest_tape)
            cv2.drawContours(frame, [largest_tape], -1, (0, 255, 255), 2)
            if tape_centroid:
                cv2.circle(frame, tape_centroid, 6, (0, 255, 255), -1)

    # Find sharpie contours
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

    # Draw closest sharpie mark
    if closest_sharpie_contour is not None:
        cv2.drawContours(frame, [closest_sharpie_contour], -1, (0, 255, 0), 2)
        if closest_sharpie_centroid:
            cx, cy = closest_sharpie_centroid
            cv2.circle(frame, (cx, cy), 5, (255, 0, 255), -1)
            cv2.putText(frame, f"{(cx, cy)}", (cx + 10, cy),
                        cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 255), 2)

    # Show result
    window_name = 'Tape + Closest Sharpie Only'
    cv2.imshow(window_name, frame)
    cv2.setMouseCallback(window_name, mouse_event, param=hsv)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

video.release()
cv2.destroyAllWindows()

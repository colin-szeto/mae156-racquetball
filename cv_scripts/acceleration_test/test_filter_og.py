import cv2
import numpy as np

# Open the video file
video = cv2.VideoCapture('indexer.mp4')

# Set max display size
max_width = 800
max_height = 600

# Mouse callback to inspect HSV values
def mouse_event(event, x, y, flags, param):
    if event == cv2.EVENT_LBUTTONDOWN:
        hsv_val = param[y, x]
        print(f'HSV at ({x},{y}) = {hsv_val}')

while True:
    ret, frame = video.read()
    if not ret:
        break

    # Resize frame to fit max dimensions while keeping aspect ratio
    h, w = frame.shape[:2]
    scale = min(max_width / w, max_height / h)
    frame = cv2.resize(frame, (int(w * scale), int(h * scale)))

    # Convert to HSV
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

    # --- MASK 1: Yellow region ---
    lower_yellow = np.array([20, 100, 100])
    upper_yellow = np.array([30, 255, 255])
    mask_yellow = cv2.inRange(hsv, lower_yellow, upper_yellow)

    # --- MASK 2: Custom color (H=27°, S=39%, V=70%) ---
    #lower_custom = np.array([10, 80, 150])
    #upper_custom = np.array([16, 140, 200])
    #mask_custom = cv2.inRange(hsv, lower_custom, upper_custom)

    # --- MASK 3: Sharpie mark (brown/tan) ---
    #lower_sharpie = np.array([10, 40, 100])
    #upper_sharpie = np.array([20, 150, 220])
    #mask_sharpie = cv2.inRange(hsv, lower_sharpie, upper_sharpie)
    
    
    

    # Combine all masks
    #combined_mask = cv2.bitwise_or(mask_yellow, mask_sharpie)
    #combined_mask = cv2.bitwise_or(combined_mask, mask_sharpie)

    # Find contours
    contours, _ = cv2.findContours(mask_yellow, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    for contour in contours:
        area = cv2.contourArea(contour)
        if area > 500:
            cv2.drawContours(frame, [contour], -1, (0, 255, 0), 2)

            M = cv2.moments(contour)
            if M["m00"] != 0:
                cx = int(M["m10"] / M["m00"])
                cy = int(M["m01"] / M["m00"])
                cv2.circle(frame, (cx, cy), 5, (255, 0, 0), -1)
                cv2.putText(frame, f"({cx}, {cy})", (cx + 10, cy), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 0, 0), 2)

    # Show the output
    window_name = 'HSV Detection'
    cv2.imshow(window_name, frame)
    cv2.setMouseCallback(window_name, mouse_event, param=hsv)

    # Exit on 'q' key
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

video.release()
cv2.destroyAllWindows()

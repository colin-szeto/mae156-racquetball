import cv2
import numpy as np

def create_sun_mask(image):
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)
    value = hsv[:, :, 2]

    # Simple brightness-based detection (adjust threshold)
    threshold = 200
    bright_mask = cv2.threshold(value, threshold, 255, cv2.THRESH_BINARY)[1]

    # Morphological operations
    kernel = np.ones((5,5), np.uint8)
    bright_mask = cv2.dilate(bright_mask, kernel, iterations=2)
    bright_mask = cv2.erode(bright_mask, kernel, iterations=1)

    # Filter regions (e.g., based on size and shape)
    contours, _ = cv2.findContours(bright_mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    sun_regions = []
    for contour in contours:
        area = cv2.contourArea(contour)
        if area > 50: # Adjust based on expected sun size
             sun_regions.append(contour)

    # Adjust HSV bounds for masking the sun based on intensity
    if sun_regions:
        sun_mask = np.zeros_like(bright_mask)
        cv2.drawContours(sun_mask, sun_regions, -1, 255, cv2.FILLED)
        average_sun_value = cv2.mean(value, mask=sun_mask)[0]
        lower_hsv = np.array([0, 0, max(200, int(average_sun_value-20))])
        upper_hsv = np.array([179, 50, 255])
        hsv_mask = cv2.inRange(hsv, lower_hsv, upper_hsv)
        hsv_mask = cv2.bitwise_not(hsv_mask)

    else:
        hsv_mask = np.zeros_like(bright_mask)  # Empty mask if no sun detected

    return hsv_mask


# Example usage
cap = cv2.VideoCapture(0) # Use 0 for default camera

# Load video
#cap = cv2.VideoCapture('2025-02-16-151324.webm')

while True:
  ret, frame = cap.read()
  if not ret:
      break
  mask = create_sun_mask(frame)
  result = cv2.bitwise_and(frame, frame, mask=mask)
  cv2.imshow("Result", result)
  if cv2.waitKey(1) & 0xFF == ord('q'):
      break

cap.release()
cv2.destroyAllWindows()

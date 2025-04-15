import cv2
import numpy as np
import glob


#images = glob.glob('*.jpg')
images = sorted(glob.glob('*.jpg'), reverse=True)

# Load the image
#image = cv2.imread("70_2025-04-14-181428.jpg")

for fname in images:
    image = cv2.imread(fname)
    print(fname)
    hsv = cv2.cvtColor(image, cv2.COLOR_BGR2HSV)

    # Define black color range in HSV
    lower_black = np.array([0, 0, 0])
    upper_black = np.array([180, 50, 100])  # You can adjust this threshold

    # Create mask for black
    mask = cv2.inRange(hsv, lower_black, upper_black)

    # Optional: clean noise
    kernel = np.ones((5,5), np.uint8)
    mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, kernel)
    mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)

    # Find contours
    contours, _ = cv2.findContours(mask, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

    # Loop through contours and filter by shape
    for cnt in contours:
        area = cv2.contourArea(cnt)
        if area > 1000:  # filter out small areas
            approx = cv2.approxPolyDP(cnt, 0.02 * cv2.arcLength(cnt, True), True)
            
            if len(approx) == 12: 
                # Draw the contour
                cv2.drawContours(image, [cnt], -1, (0, 255, 0), 3)

                # Compute bounding box
                x, y, w, h = cv2.boundingRect(cnt)
                cv2.rectangle(image, (x, y), (x+w, y+h), (255, 0, 0), 2)
                cv2.putText(image, 'Cross?', (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.7, (255, 255, 255), 2)

    # Show results
    #cv2.imshow("Original", image)
    cv2.imshow("Mask", image)
    cv2.waitKey(0)
    
cv2.destroyAllWindows()

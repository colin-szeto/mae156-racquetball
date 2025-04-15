import cv2 
import numpy as np 

image = cv2.imread('142_2025-04-14-181010.jpg') 
cv2.imshow('Original Image', image) 
cv2.waitKey(0) 


# _, frame = cap.read() 
frame = image
# It converts the BGR color space of image to HSV color space 
hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) 
cv2.imshow('hsv Image', hsv) 
cv2.waitKey(0) 

# Threshold of blue in HSV space 
lower_blue = np.array([0,0,0])#([60, 35, 140]  ) 
upper_blue = np.array([180,255,150])#([180, 255, 255]) 

# hair_color_low= [0,0,0]
# hair_color_high=[360,255,50]

# preparing the mask to overlay 
mask = cv2.inRange(hsv, lower_blue, upper_blue) 
cv2.imshow('mask Image', mask) 
cv2.waitKey(0) 

# The black region in the mask has the value of 0, 
# so when multiplied with original image removes all non-blue regions 
result = cv2.bitwise_and(frame, frame, mask = mask) 

cv2.imshow('result Image', result) 
cv2.waitKey(0) 
# using a findContours() function 
  
# using a findContours() function 
contours, _ = cv2.findContours(mask, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE) 

print("length contours: "+ str(len(contours)))
i = 0
  
# list for storing names of shapes 
for contour in contours: 
  
    # here we are ignoring first counter because  
    # findcontour function detects whole image as shape 
    if i == 0: 
        i = 1
        continue
  
    # cv2.approxPloyDP() function to approximate the shape 
    approx = cv2.approxPolyDP( 
        contour, 0.01 * cv2.arcLength(contour, True), True) 
      
    # using drawContours() function 
    # cv2.drawContours(Gaussian, [contour], 0, (0, 0, 255), 5) 
  
    # finding center point of shape 
    M = cv2.moments(contour) 
    if M['m00'] != 0.0: 
        x = int(M['m10']/M['m00']) 
        y = int(M['m01']/M['m00']) 
        
    if len(approx) == 12: 
       cv2.drawContours(mask, [contour], 0, (0, 0, 255), 5) 
       cv2.putText(mask, 'Plus', (x, y), 
                   cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2) 

cv2.imshow('shapes', mask)
cv2.waitKey(0) 

cv2.destroyAllWindows() 
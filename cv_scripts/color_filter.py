import cv2 
import numpy as np 

image = cv2.imread('2025-02-16-151324 (242).jpg') 
cv2.imshow('Original Image', image) 
cv2.waitKey(0) 

while(1): 
    # _, frame = cap.read() 
    frame = image
	# It converts the BGR color space of image to HSV color space 
    hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV) 
	
    # Threshold of blue in HSV space 
    lower_blue = np.array([0,0,0])#([60, 35, 140]  ) 
    upper_blue = np.array([360,255,50])#([180, 255, 255]) 
    
    # hair_color_low= [0,0,0]
    # hair_color_high=[360,255,50]
    
    # preparing the mask to overlay 
    mask = cv2.inRange(hsv, lower_blue, upper_blue) 
    
    # The black region in the mask has the value of 0, 
    # so when multiplied with original image removes all non-blue regions 
    result = cv2.bitwise_and(frame, frame, mask = mask) 

    # using a findContours() function 
    contours, _ = cv2.findContours(result, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE) 

    
    cv2.imshow('frame', frame) 
    cv2.imshow('mask', mask) 
    cv2.imshow('result', result) 
    
    cv2.waitKey(0) 

cv2.destroyAllWindows() 
cap.release() 

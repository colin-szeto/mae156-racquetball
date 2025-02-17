# this is the file we will test the filter on 2025-02-16-151324 (242).jpg

# importing libraries 
import cv2 
import numpy as np 

image = cv2.imread('2025-02-16-151324 (242).jpg') 

cv2.imshow('Original Image', image) 
cv2.waitKey(0) 

# Gaussian Blur 
Gaussian = cv2.GaussianBlur(image, (7, 7), 0) 
#cv2.imshow('Gaussian Blurring', Gaussian) 
#cv2.waitKey(0) 

# Use the cvtColor() function to grayscale the image
gray_image_Gaussian = cv2.cvtColor(Gaussian, cv2.COLOR_BGR2GRAY)

cv2.imshow('Gaussian Blurring Grayscale', gray_image_Gaussian)
cv2.waitKey(0)  


# using a findContours() function 

# setting threshold of gray image 
_, threshold = cv2.threshold(gray_image_Gaussian, 127, 255, cv2.THRESH_BINARY) 
  
# using a findContours() function 
contours, _ = cv2.findContours(threshold, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE) 

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
    cv2.drawContours(gray_image_Gaussian, [contour], 0, (0, 0, 255), 5) 
  
    # finding center point of shape 
    M = cv2.moments(contour) 
    if M['m00'] != 0.0: 
        x = int(M['m10']/M['m00']) 
        y = int(M['m01']/M['m00']) 
        
    if len(approx) == 12: 
       cv2.putText(gray_image_Gaussian, 'Plus', (x, y), 
                   cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2) 
  
    # putting shape name at center of each shape 
    #if len(approx) == 3: 
    #    cv2.putText(gray_image_Gaussian, 'Triangle', (x, y), 
    #                cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2) 
    #
    #elif len(approx) == 4: 
    #    cv2.putText(gray_image_Gaussian, 'Quadrilateral', (x, y), 
    #                cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2) 
    #
    #elif len(approx) == 5: 
    #    cv2.putText(gray_image_Gaussian, 'Pentagon', (x, y), 
    #                cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2) 
    #
    #elif len(approx) == 6: 
    #    cv2.putText(gray_image_Gaussian, 'Hexagon', (x, y), 
    #                cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2) 
    #                
    #elif len(approx) == 12: 
    #    cv2.putText(gray_image_Gaussian, 'Plus', (x, y), 
    #                cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2) 
    #
    #else: 
    #    cv2.putText(gray_image_Gaussian, 'circle', (x, y), 
    #                cv2.FONT_HERSHEY_SIMPLEX, 0.6, (255, 255, 255), 2) 
  
# displaying the gray_image_Gaussian after drawing contours 
cv2.imshow('shapes', gray_image_Gaussian) 
  
cv2.waitKey(0) 
cv2.destroyAllWindows() 

# Window shown waits for any key pressing event
cv2.destroyAllWindows()

## Median Blur 
#median = cv2.medianBlur(image, 5) 
#cv2.imshow('Median Blurring', median) 
#cv2.waitKey(0) 
#
#
## Bilateral Blur 
#bilateral = cv2.bilateralFilter(image, 9, 75, 75) 
#cv2.imshow('Bilateral Blurring', bilateral) 
#cv2.waitKey(0) 
#cv2.destroyAllWindows() 

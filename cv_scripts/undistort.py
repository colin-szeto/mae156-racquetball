import cv2
import numpy as np

# Load the image
img = cv2.imread('2025-03-15-174141.jpg')
h, w = img.shape[:2]

# Camera matrix (replace with your calibrated values)
#camera_matrix = np.array([[fx, 0, cx],
#                          [0, fy, cy],
#                          [0, 0, 1]], dtype=np.float32)
                          
camera_matrix = np.array([[1.551910348905314777e+03, 0.000000000000000000e+00, 9.444798317544313022e+02],
                        [0.000000000000000000e+00, 1.541896249301795024e+03, 5.445289452453528156e+02],
                        [0.000000000000000000e+00, 0.000000000000000000e+00, 1.000000000000000000e+00]], dtype=np.float32)

# Distortion coefficients (replace with your calibrated values)
dist_coeffs = np.array([-6.942289206836326221e-01, 2.612462859404101057e+00, -1.199576744524719161e-03, 5.462528959592292260e-03, -4.672766429787830411e+00], dtype=np.float32)

# Get optimal new camera matrix
new_camera_matrix, roi = cv2.getOptimalNewCameraMatrix(camera_matrix, dist_coeffs, (w, h), 1, (w, h))

# Undistort the image
undistorted_img = cv2.undistort(img, camera_matrix, dist_coeffs, None, new_camera_matrix)

# Crop the image if needed
x, y, w, h = roi
cropped_img = undistorted_img[y:y+h, x:x+w]

# Save or display the undistorted image
cv2.imwrite('undistorted_image.jpg', cropped_img)
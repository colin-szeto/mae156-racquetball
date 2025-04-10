import cv2
import numpy as np

def apply_distortion(img, k1, k2, k3):
    h, w = img.shape[:2]
    # Create the distortion maps
    map_x = np.zeros((h, w), np.float32)
    map_y = np.zeros((h, w), np.float32)
    for y in range(h):
        for x in range(w):
            # Normalize coordinates
            nx = (x - w/2) / (w/2)
            ny = (y - h/2) / (h/2)
            # Calculate radius
            r = np.sqrt(nx**2 + ny**2)
            # Apply distortion model
            rd = 1 + k1 * r**2 + k2 * r**4 + k3 * r**6
            nx_d = nx * rd
            ny_d = ny * rd
            # Unnormalize coordinates
            x_d = w/2 + nx_d * (w/2)
            y_d = h/2 + ny_d * (h/2)
            map_x[y, x] = x_d
            map_y[y, x] = y_d
            
    map_x = map_x.astype(np.float32)
    map_y = map_y.astype(np.float32)
    # Apply remap
    distorted_img = cv2.remap(img, map_x, map_y, cv2.INTER_LINEAR)
    return distorted_img

# Example usage:
img = cv2.imread('2025-03-15-174020.jpg')
k1, k2, k3 = 0.1, 0.01, 0.001  # Example distortion coefficients
#k1, k2, k3 = -6.942289206836326221e-01, 2.612462859404101057e+00, -1.199576744524719161e-03  # Example distortion coefficients
distorted_img = apply_distortion(img, k1, k2, k3)
cv2.imwrite('distorted_image.jpg', distorted_img)
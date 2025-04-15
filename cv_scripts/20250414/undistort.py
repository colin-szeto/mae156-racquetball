import cv2
import numpy as np
import glob

# === Step 1: Camera Calibration ===
def calibrate_camera(calibration_images_path, checkerboard_dims=(9, 6)):
    objp = np.zeros((checkerboard_dims[0] * checkerboard_dims[1], 3), np.float32)
    objp[:, :2] = np.mgrid[0:checkerboard_dims[0], 0:checkerboard_dims[1]].T.reshape(-1, 2)

    objpoints = []  # 3D real-world points
    imgpoints = []  # 2D image points

    images = glob.glob(calibration_images_path)

    for fname in images:
        img = cv2.imread(fname)
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        ret, corners = cv2.findChessboardCorners(gray, checkerboard_dims, None)
        if ret:
            objpoints.append(objp)
            imgpoints.append(corners)

    if not objpoints:
        raise ValueError("No calibration pattern found in any image.")

    ret, camera_matrix, dist_coeffs, rvecs, tvecs = cv2.calibrateCamera(
        objpoints, imgpoints, gray.shape[::-1], None, None
    )
    return camera_matrix, dist_coeffs

# === Step 2: Undistort an Image ===
def undistort_image(image_path, camera_matrix, dist_coeffs):
    img = cv2.imread(image_path)
    h, w = img.shape[:2]

    new_camera_matrix, roi = cv2.getOptimalNewCameraMatrix(
        camera_matrix, dist_coeffs, (w, h), 1, (w, h)
    )
    undistorted = cv2.undistort(img, camera_matrix, dist_coeffs, None, new_camera_matrix)

    # Crop if desired
    x, y, w, h = roi
    undistorted = undistorted[y:y+h, x:x+w]
    return undistorted

# === Example Usage ===
if __name__ == "__main__":
    # Path to checkerboard images for calibration
    calibration_images = "C:/Users/Colin/Documents/00_WI_25/mae 156/capstone/mae156-racquetball/cv_scripts/20250414/*.jpg"  # Replace with your folder of checkerboard images

    # Path to the tilted/distorted image you want to correct
    tilted_image_path = "\bouy\2025-04-13-141120.jpg"

    # Calibrate the camera
    camera_matrix, dist_coeffs = calibrate_camera(calibration_images)

    # Undistort the image
    corrected_img = undistort_image(tilted_image_path, camera_matrix, dist_coeffs)

    # Show and save
    cv2.imshow("Undistorted Image", corrected_img)
    cv2.imwrite("undistorted_output.jpg", corrected_img)
    cv2.waitKey(0)
    cv2.destroyAllWindows()

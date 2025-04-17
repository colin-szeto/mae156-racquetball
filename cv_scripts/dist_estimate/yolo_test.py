from ultralytics import YOLO
import cv2

# Load a YOLO model – you can use 'yolov8n.pt', 'yolov8s.pt', etc.
model = YOLO("best_try2.pt")  # Make sure you download or provide the correct path

# Load image
img_path = "2025-04-14-181653_34.jpg"
image = cv2.imread(img_path)

# Inference
results = model(image)

# Draw results on image
annotated_frame = results[0].plot()

# Show result
cv2.imshow("YOLO Detection", annotated_frame)
cv2.waitKey(0)
cv2.destroyAllWindows()

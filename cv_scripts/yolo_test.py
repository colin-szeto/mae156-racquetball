from ultralytics import YOLO
import cv2

# Load YOLOv8 model
# model = YOLO("best (2).pt")  # Replace with your custom or official YOLO model
model = YOLO("best_try2.pt")  # Replace with your custom or official YOLO model

# Load video
#video_path = "2025-04-14-201303.webm"  # Replace with your actual video path
cap = cv2.VideoCapture(0)

# Optional: Save output video
save_output = True
output_path = "yolo_output_outside.avi"

# Get video properties
fps = int(cap.get(cv2.CAP_PROP_FPS))
width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))

if save_output:
    fourcc = cv2.VideoWriter_fourcc(*'XVID')
    out = cv2.VideoWriter(output_path, fourcc, fps, (width, height))

# Process video frames
while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        break

    # Run YOLO inference on frame
    results = model(frame)

    # Draw results
    annotated_frame = results[0].plot()

    # Show frame
    cv2.imshow("YOLO Detection", annotated_frame)

    # Save frame
    if save_output:
        out.write(annotated_frame)

    # Exit on 'q'
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# Cleanup
cap.release()
if save_output:
    out.release()
cv2.destroyAllWindows()

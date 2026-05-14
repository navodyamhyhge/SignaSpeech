import cv2
import time

from ultralytics import YOLO
from speech import speak

from collections import Counter
from datetime import datetime

# =========================
# Load YOLOv8 Model
# =========================
model = YOLO("runs/detect/train-2/weights/best.pt")

# =========================
# Open Webcam
# =========================
cap = cv2.VideoCapture(0)

# Webcam Resolution
cap.set(3, 640)
cap.set(4, 480)

# =========================
# Prediction Settings
# =========================

CONFIDENCE_THRESHOLD = 0.5

# Number of frames used for stable prediction
HISTORY_SIZE = 10

# Store prediction history
history = []

# Track last stable gesture
last_detected = ""

# FPS Calculation
prev_time = 0

# =========================
# Detection History File
# =========================
history_file = open("detection_history.txt", "a")

print("\n✅ Real-Time Sign Gesture Detection Started")
print("Press 'Q' to Quit\n")

# =========================
# Main Loop
# =========================
while True:

    # Read frame
    ret, frame = cap.read()

    if not ret:
        break

    # =========================
    # YOLO Prediction
    # =========================
    results = model(frame, conf=0.4)

    current_labels = []
    current_confidences = []

    # =========================
    # Process Results
    # =========================
    for r in results:

        boxes = r.boxes

        if boxes is not None:

            for box in boxes:

                # Confidence score
                conf = float(box.conf[0])

                # Ignore weak detections
                if conf < CONFIDENCE_THRESHOLD:
                    continue

                # Class index
                cls = int(box.cls[0])

                # Gesture label
                label = model.names[cls]

                current_labels.append(label)
                current_confidences.append(conf)

                # Bounding box coordinates
                x1, y1, x2, y2 = map(
                    int,
                    box.xyxy[0]
                )

                # =========================
                # Draw Bounding Box
                # =========================
                cv2.rectangle(
                    frame,
                    (x1, y1),
                    (x2, y2),
                    (0, 255, 0),
                    2
                )

                # Label text
                text = f"{label} {conf:.2f}"

                cv2.putText(
                    frame,
                    text,
                    (x1, y1 - 10),
                    cv2.FONT_HERSHEY_SIMPLEX,
                    0.7,
                    (0, 255, 0),
                    2
                )

    # =========================
    # Stable Prediction Logic
    # =========================
    if current_labels:

        # Use first detection
        detected_label = current_labels[0]

        # Add to prediction history
        history.append(detected_label)

        # Keep only recent predictions
        if len(history) > HISTORY_SIZE:
            history.pop(0)

        # Most stable prediction
        most_common = Counter(history).most_common(1)[0][0]

        # Confidence score
        confidence = current_confidences[0]

        # =========================
        # Gesture Change Detection
        # =========================
        if most_common != last_detected:

            # Speech Output
            speak(most_common, confidence)

            # =========================
            # Save Detection History
            # =========================
            now = datetime.now().strftime(
                "%Y-%m-%d %H:%M:%S"
            )

            history_entry = (
                f"{now} | "
                f"Gesture: {most_common} | "
                f"Confidence: {confidence:.2f}\n"
            )

            history_file.write(history_entry)

            # Save immediately
            history_file.flush()

            # Update last detected
            last_detected = most_common

        # =========================
        # Display Stable Gesture
        # =========================
        cv2.putText(
            frame,
            f"Stable Gesture: {most_common}",
            (20, 40),
            cv2.FONT_HERSHEY_SIMPLEX,
            1,
            (255, 0, 0),
            2
        )

    # =========================
    # FPS Counter
    # =========================
    current_time = time.time()

    fps = 1 / (current_time - prev_time)

    prev_time = current_time

    cv2.putText(
        frame,
        f"FPS: {int(fps)}",
        (20, 80),
        cv2.FONT_HERSHEY_SIMPLEX,
        0.8,
        (0, 255, 255),
        2
    )

    # =========================
    # Show Window
    # =========================
    cv2.imshow(
        "Advanced Sign Gesture Detection",
        frame
    )

    # =========================
    # Exit Key
    # =========================
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

# =========================
# Cleanup
# =========================
history_file.close()

cap.release()

cv2.destroyAllWindows()

print("\n✅ Detection Stopped Successfully")
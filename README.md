# 🤟 SignaSpeech

<div align="center">

![SignaSpeech Banner](https://img.shields.io/badge/SignaSpeech-Sign%20Language%20to%20Speech-blueviolet?style=for-the-badge&logo=google&logoColor=white)

[![Python](https://img.shields.io/badge/Python-3.9+-3776AB?style=flat-square&logo=python&logoColor=white)](https://python.org)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![YOLOv8](https://img.shields.io/badge/YOLOv8-Ultralytics-FF6F00?style=flat-square&logo=pytorch&logoColor=white)](https://ultralytics.com)
[![TensorFlow](https://img.shields.io/badge/TensorFlow-2.x-FF6F00?style=flat-square&logo=tensorflow&logoColor=white)](https://tensorflow.org)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)

**A real-time sign language recognition system that bridges the communication gap for the deaf and mute community.**

[Features](#features) • [Architecture](#architecture) • [Installation](#installation) • [Usage](#usage) • [Dataset](#dataset) • [Results](#results)

</div>

---

## 📌 Overview

**SignaSpeech** is an individual final year research project that leverages deep learning and computer vision to convert sign language gestures into speech and text in real time. Built with **YOLOv8**, **TensorFlow**, and a **Flutter** mobile application, SignaSpeech aims to empower deaf and mute individuals by enabling seamless communication with the hearing world — no interpreter required.

> *"Breaking the silence, one gesture at a time."*

---

## ✨ Features

- 🎯 **Real-time Sign Detection** — Detects and classifies hand gestures instantly using YOLOv8
- 🔤 **Sign to Text** — Converts recognized gestures into readable text output
- 🔊 **Text to Speech** — Converts translated text into audible speech
- 📱 **Cross-platform Mobile App** — Flutter app for Android & iOS
- 🧠 **Deep Learning Powered** — Trained on a custom dataset using YOLOv8 + TensorFlow
- ⚡ **Optimized Inference** — Lightweight model designed for mobile deployment
- 🌐 **Offline Capable** — Works without internet once the model is loaded

---

## 🏗️ Architecture

```
SignaSpeech/
├── Sign Gesture Detection_YOLOv8/   # YOLOv8 training dataset & configs
│   ├── train/                        # Training images & labels
│   ├── valid/                        # Validation images & labels
│   ├── test/                         # Test images & labels
│   └── data.yaml                     # Dataset configuration
│
├── Signaspecch_YOLOv8/              # Model training scripts & weights
│   ├── train/
│   ├── valid/
│   ├── test/
│   └── data.yaml
│
├── mobile app UI/                    # Flutter mobile application
│   ├── lib/                          # Dart source code
│   ├── assets/                       # App assets
│   └── pubspec.yaml
│
├── Docs/                             # Project documentation
├── native images/                    # Sample/reference images
└── README.md
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| **Object Detection** | YOLOv8 (Ultralytics) |
| **Deep Learning** | TensorFlow / Keras |
| **Mobile App** | Flutter (Dart) |
| **Backend / Inference** | Python 3.9+ |
| **Model Format** | `.pt` / `.tflite` (mobile) |
| **Dataset Annotation** | Roboflow |

---

## 📦 Installation

### Prerequisites

- Python 3.9+
- Flutter SDK 3.x
- CUDA-enabled GPU (recommended for training)

### 1. Clone the Repository

```bash
git clone https://github.com/navodyamhyhge/SignaSpeech.git
cd SignaSpeech
```

### 2. Install Python Dependencies

```bash
pip install ultralytics tensorflow opencv-python numpy
```

### 3. Run Model Training

```bash
cd "Sign Gesture Detetction_YOLOv8"
yolo task=detect mode=train model=yolov8n.pt data=data.yaml epochs=100 imgsz=640
```

### 4. Set Up Flutter App

```bash
cd "mobile app UI"
flutter pub get
flutter run
```

---

## 🚀 Usage

### Run Detection (Python)

```python
from ultralytics import YOLO

model = YOLO("best.pt")  # Load trained model
results = model.predict(source=0, show=True)  # 0 = webcam
```

### Mobile App

1. Open the Flutter app on your device
2. Point the camera at a sign language gesture
3. The app will display the detected sign as text
4. Tap the speaker icon to hear the translation as speech

---

## 📊 Dataset

- **Source:** Custom dataset annotated via [Roboflow](https://roboflow.com)
- **Classes:** Sri Lankan / Standard sign language gestures
- **Split:**
  - 🟢 Train: ~80%
  - 🟡 Validation: ~10%
  - 🔴 Test: ~10%
- **Format:** YOLOv8 (images + `.txt` labels)

---

## 📈 Results

| Metric | Value |
|---|---|
| Model | YOLOv8n |
| Input Size | 640×640 |
| mAP@50 | *To be updated* |
| Inference Speed | *To be updated* |
| Platform | Android / iOS |

---

## 🎯 Project Goals

- [x] Dataset collection and annotation
- [x] YOLOv8 model training
- [x] Flutter mobile app development
- [ ] TFLite model conversion for on-device inference
- [ ] Text-to-Speech integration
- [ ] Full app deployment

---

## 👨‍💻 Author

**Navodya Mihenge**
Final Year Undergraduate — Individual Research Project

[![GitHub](https://img.shields.io/badge/GitHub-navodyamhyhge-181717?style=flat-square&logo=github)](https://github.com/navodyamhyhge)

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<div align="center">

Made with ❤️ to empower the deaf and mute community

⭐ Star this repo if you find it useful!

</div>

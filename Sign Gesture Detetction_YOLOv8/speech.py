import pyttsx3
import threading
import time

# Track previous gesture
last_spoken = ""

# Cooldown timer
last_time = 0

# Minimum delay between speeches
COOLDOWN = 1.5

# Prevent multiple speech overlaps
speech_lock = threading.Lock()


def speak_text(text):
    """
    Create fresh speech engine each time
    """

    with speech_lock:

        try:
            engine = pyttsx3.init()

            engine.setProperty('rate', 140)

            voices = engine.getProperty('voices')
            engine.setProperty('voice', voices[0].id)

            engine.say(text)

            engine.runAndWait()

            engine.stop()

        except Exception as e:
            print("Speech Error:", e)


def speak(label, confidence=1.0):

    global last_spoken
    global last_time

    current_time = time.time()

    # Ignore low confidence
    if confidence < 0.5:
        return

    # Speak when:
    # 1. Gesture changed
    # OR
    # 2. Cooldown completed
    if (
        label != last_spoken
        or current_time - last_time > COOLDOWN
    ):

        print(f"🔊 Speaking: {label}")

        # Start speech thread
        threading.Thread(
            target=speak_text,
            args=(label,),
            daemon=True
        ).start()

        # Update tracking
        last_spoken = label
        last_time = current_time
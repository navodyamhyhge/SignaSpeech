import os
import random
import shutil

images_path = "train/images"
labels_path = "train/labels"

images = os.listdir(images_path)
random.shuffle(images)

val_split = 0.2
test_split = 0.1

val_count = int(len(images) * val_split)
test_count = int(len(images) * test_split)

val_images = images[:val_count]
test_images = images[val_count:val_count+test_count]

def move_files(file_list, split):
    for img in file_list:
        name = os.path.splitext(img)[0]
        label = name + ".txt"

        shutil.move(f"{images_path}/{img}", f"{split}/images/{img}")
        shutil.move(f"{labels_path}/{label}", f"{split}/labels/{label}")

move_files(val_images, "valid")
move_files(test_images, "test")

print("✅ Split completed successfully!")
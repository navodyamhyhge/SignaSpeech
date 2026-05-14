import os

folders = ["train/labels", "valid/labels"]

remove_classes = {'8', '9'}

for labels_path in folders:
    for filename in os.listdir(labels_path):
        file_path = os.path.join(labels_path, filename)

        if not filename.endswith(".txt"):
            continue

        with open(file_path, "r") as f:
            lines = f.readlines()

        new_lines = []
        for line in lines:
            class_id = line.split()[0]
            if class_id not in remove_classes:
                new_lines.append(line)

        # If empty → delete file (becomes background image)
        if len(new_lines) == 0:
            os.remove(file_path)
        else:
            with open(file_path, "w") as f:
                f.writelines(new_lines)

print("✅ Cleaning completed!")
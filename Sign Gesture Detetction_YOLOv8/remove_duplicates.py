import os

folders = ["train/labels", "valid/labels"]

for folder in folders:
    for filename in os.listdir(folder):
        if not filename.endswith(".txt"):
            continue
        
        path = os.path.join(folder, filename)
        
        with open(path, "r") as f:
            lines = f.readlines()
        
        # Remove duplicate lines
        unique_lines = list(set(lines))
        
        with open(path, "w") as f:
            f.writelines(unique_lines)

print("✅ Duplicates removed!")
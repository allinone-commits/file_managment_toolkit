# === Feature 1: Batch Rename Files in a Folder ===
def batch_rename_in_folder(folder, prefix):
    files = [os.path.join(folder, item) for item in os.listdir(folder) if os.path.isfile(os.path.join(folder, item))]
    
    for number, full_file_path in enumerate(files, 1):
        folder_of_file, original_file_name = os.path.split(full_file_path)
        file_extension = os.path.splitext(original_file_name)[1]
        new_file_name = f"{prefix}_{number}{file_extension}"
        new_full_path = os.path.join(folder_of_file, new_file_name)
        os.rename(full_file_path, new_full_path)
        print(f"Renamed: {original_file_name} -> {new_file_name}")

# === Feature 2: Organize Files by Type ===
def organize_files_by_type(folder_path):
    file_type_folders = {
        "txt": "Text Files",
        "pdf": "PDFs",
        "doc": "Word Documents",
        "docx": "Word Documents",
        "jpg": "Images",
        "jpeg": "Images",
        "png": "Images",
        "gif": "Images",
        "mp3": "Audio Files",
        "wav": "Audio Files",
        "mp4": "Videos",
        "avi": "Videos",
        "zip": "Archives",
        "rar": "Archives",
        "py": "Python Files",
        "exe": "Executables",
        "csv": "Spreadsheets",
        "xlsx": "Spreadsheets",
        "pptx": "Presentations",
        "env": "Environment Files",
        "no_extension": "Other Files"
    }

    for file_name in os.listdir(folder_path):
        full_path = os.path.join(folder_path, file_name)
        if os.path.isfile(full_path):
            ext = os.path.splitext(file_name)[1][1:].lower()
            ext = ext if ext else "no_extension"
            folder_name = file_type_folders.get(ext, "Other Files")
            target_folder = os.path.join(folder_path, folder_name)
            os.makedirs(target_folder, exist_ok=True)
            shutil.move(full_path, os.path.join(target_folder, file_name))

    print("Files organized successfully.")
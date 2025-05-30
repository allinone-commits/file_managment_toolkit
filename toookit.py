import os
import hashlib
import shutil
from PIL import Image
from docx2pdf import convert
import bcrypt

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
# === Feature 3: Convert File Extensions ===
def convert_files(folder_path, choice=None):
    if choice is None:
        print("Choose an option:")
        print("1. Convert images to a single PDF")
        print("2. Convert documents (doc, docx) to individual PDFs")
        choice = input("Enter 1 or 2: ").strip()

    if not os.path.isdir(folder_path):
        print(" Invalid folder path.")
        return

    if choice == '1':
        supported_exts = ('.png', '.jpg', '.jpeg')
        image_files = [os.path.join(folder_path, f) for f in os.listdir(folder_path) if f.lower().endswith(supported_exts)]
        image_files.sort()
        if not image_files:
            print("No images found.")
            return
        images = [Image.open(f).convert("RGB") for f in image_files]
        output_pdf = os.path.join(folder_path, "combined_images.pdf")
        images[0].save(output_pdf, save_all=True, append_images=images[1:])
        print(f"Combined images into PDF: {output_pdf}")

    elif choice == '2':
        supported_exts = ('.doc', '.docx')
        doc_files = [os.path.join(folder_path, f) for f in os.listdir(folder_path) if f.lower().endswith(supported_exts)]
        if not doc_files:
            print("No documents found.")
            return
        output_folder = os.path.join(folder_path, "Converted_PDFs")
        os.makedirs(output_folder, exist_ok=True)
        for doc in doc_files:
            name = os.path.splitext(os.path.basename(doc))[0]
            output_pdf = os.path.join(output_folder, f"{name}.pdf")
            convert(doc, output_pdf)
            print(f"Converted: {doc} -> {output_pdf}")
    else:
        print("Invalid choice.")

# === Feature 4: Detect and Handle Duplicate Files ===
def handle_duplicates(folder):
    duplicates_folder = os.path.join(folder, "duplicates")
    os.makedirs(duplicates_folder, exist_ok=True)
    files_checked = []
    duplicates = []

    for filename in os.listdir(folder):
        file_path = os.path.join(folder, filename)
        if os.path.isfile(file_path):
            with open(file_path, "rb") as f:
                content = f.read()
            if any(content == saved for saved, _ in files_checked):
                shutil.move(file_path, os.path.join(duplicates_folder, os.path.basename(file_path)))
                print(f"Moved duplicate: {file_path}")
            else:
                files_checked.append((content, file_path))etect and Handle Duplicate Files ===
# === Feature 5: Encrypt a File (XOR Encryption) ===
def encrypt_file(file_path, password):
    key = ord(password[0])
    with open(file_path, "rb") as f:
        data = f.read()
    encrypted = bytearray([b ^ key for b in data])
    enc_path = file_path + ".enc"
    with open(enc_path, "wb") as f:
        f.write(encrypted)
    os.remove(file_path)
    print(f"Encrypted and removed original: {file_path}")

# === Feature 6: Decrypt a File (XOR Decryption) ===
def decrypt_file(file_path, password):
    if not file_path.endswith(".enc"):
        raise ValueError("File must end with '.enc'")
    key = ord(password[0])
    with open(file_path, "rb") as f:
        data = f.read()
    decrypted = bytearray([b ^ key for b in data])
    orig_path = file_path[:-4]
    with open(orig_path, "wb") as f:
        f.write(decrypted)
    print(f"Decrypted to: {orig_path}")

# === Feature 7: Lock File (XOR + bcrypt) ===
def lock_file(file_path, password):
    key = ord(password[0])
    password_bytes = password.encode("utf-8")
    hashed_pw = bcrypt.hashpw(password_bytes, bcrypt.gensalt())

    with open(file_path, "rb") as f:
        data = f.read()

    encrypted = bytearray([b ^ key for b in data])
    
    enc_path = file_path + ".enc"
    hash_path = file_path + ".hash"

    with open(enc_path, "wb") as f:
        f.write(encrypted)
    with open(hash_path, "wb") as f:
        f.write(hashed_pw)

    os.remove(file_path)
    print(f" Locked: {enc_path}\n Hash saved: {hash_path}\n Original removed.")
# === Feature 8: Unlock File (XOR + bcrypt verification) ===
def unlock_file(hash_file_path, password):
    if not hash_file_path.endswith(".hash"):
        raise ValueError("Input must be a '.hash' file.")

    base_path = hash_file_path[:-5]  # removes .hash
    enc_path = base_path + ".enc"
    orig_path = base_path  # original file name to restore

    if not os.path.exists(enc_path):
        raise FileNotFoundError(f"Missing encrypted file: {enc_path}")

    with open(hash_file_path, "rb") as f:
        stored_hash = f.read()

    if not bcrypt.checkpw(password.encode("utf-8"), stored_hash):
        raise ValueError("❌ Incorrect password.")

    with open(enc_path, "rb") as f:
        data = f.read()

    key = ord(password[0])
    decrypted = bytearray([b ^ key for b in data])

    with open(orig_path, "wb") as f:
        f.write(decrypted)

    print(f"🔓 Unlocked and restored: {orig_path}")


#main fuction to run the app
if __name__ == "__main__":
    print("📂File Management Toolkit📂")
    print("Choose an option:")
    print("1. Batch Rename Files")
    print("2. Organize Files by Type")
    print("3. Convert Files")
    print("4. Detect and Handle Duplicates")
    print("5. Encrypt File ")
    print("6. Decrypt File ")
    print("7. Lock File ")
    print("8. Unlock File ")

    choice = input("Enter your choice (1-8):👉>>>> ").strip()

    try:
        if choice == '1':
            print("--------wellcome to batch renaming-------------")
            folder = input("Enter folder path:>>>> ").strip()
            prefix = input("Enter file name prefix: ")
            batch_rename_in_folder(folder, prefix)
        elif choice == '2':
            print("--------wellcome to file organization-------------")
            folder = input("Enter folder path:>>>> ").strip()
            organize_files_by_type(folder)
        elif choice == '3':
            print("--------wellcome to file extension tool-------------")
            file = input("Enter file: ").strip()
            convert_files(file)
        elif choice == '4':
            print("--------wellcome to file duplicate finder-------------")
            folder = input("Enter folder path:>>>> ").strip()
            handle_duplicates(folder)
        elif choice == '5':
            print("--------wellcome to file encripter finder-------------")
            file = input("Enter file path >>>>: ").strip()
            password = input("Enter encryption password: ")
            encrypt_file(file, password)
        elif choice == '6':
            print("--------wellcome to file depricter -------------")
            file = input("Enter file path>>>: ").strip()
            password = input("Enter decryption password: ")
            decrypt_file(file, password)
        elif choice == '7':
            print("--------wellcome to file locker -------------")
            file = input("Enter file path ").strip()
            password = input("Enter lock password: ")
            lock_file(file, password)
        elif choice == '8':
            print("--------wellcome to file unloacker -------------")
            file = input("Enter file path ").strip()
            password = input("Enter unlock password: ")
            unlock_file(file, password)
        else:
            print("❌ Invalid choice.")
    except Exception as e:
        print(f"Error: {e}")


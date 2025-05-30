#important modules
import os
import hashlib
import shutil
from PIL import Image
from docx2pdf import convert
import bcrypt

# === Feature 1: Batch Rename Files in a Folder ===
def batch_rename_in_folder(folder, prefix):
    files = [] 
    for item in os.listdir(folder):  
    full_path = os.path.join(folder, item) 
    if os.path.isfile(full_path):  
        files.append(full_path)
    
    for number, full_file_path in enumerate(files, 1):

        folder_of_file, original_file_name = os.path.split(full_file_path)

        file_extension = os.path.splitext(original_file_name)[1]

        new_file_name = f"{prefix}_{number}{file_extension}"

        new_full_path = os.path.join(folder_of_file, new_file_name)

        os.rename(full_file_path, new_full_path)

        print(f"Renamed😎😎😎: {original_file_name} -> {new_file_name}")

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
            split_name_ext = os.path.splitext(file_name)
            extension_with_dot = split_name_ext[1]

            ext = extension_with_dot[1:].lower()
            if not ext:
                ext = "no_extension"
            
            folder_name = file_type_folders.get(ext, "Other Files")

            target_folder = os.path.join(folder_path, folder_name)

            os.makedirs(target_folder, exist_ok=True)

            new_location_file = os.path.join(target_folder, file_name)
            shutil.move(full_path, new_location)

    print("Files organized successfully.😊😊😊")
# === Feature 3: Convert File Extensions ===
def convert_files(folder_path, choice=None):
    if choice is None:
        print("Choose an option:")
        print("1. ------📒Convert images to a single PDF📒")
        print("2.-------📒 Convert documents (doc, docx) to individual PDFs📒")
        choice = input("Enter 1 or 2:>>>>> ").strip()

    if not os.path.isdir(folder_path):
        print(" Invalid folder path.")
        return

    if choice == '1':
        supported_exts = ('.png', '.jpg', '.jpeg')
        image_files = []
         for f in os.listdir(folder_path):
            if f.lower().endswith(supported_exts):
                image_files.append(os.path.join(folder_path, f))
        image_files.sort()
        if not image_files:
            print("No images found.")
            return
        images=[]
        for img_path in image_files:
        img = Image.open(img_path)
        rgb_img = img.convert("RGB")
        images.append(rgb_img)

        output_pdf = os.path.join(folder_path, "combined_images.pdf")
        first_image=images[0]:
        Other_image=images[1:]
        first_image.save(
            output_pdf,          # File path to save the PDF
            save_all=True,       # Save all images, not just the first
            append_images=other_images  # Add the other images as extra pages
            )
        print(f"😎😎😎cmbined images into PDF: {output_pdf}")

    elif choice == '2':
        supported_exts = ('.doc', '.docx')
        output_folder = os.path.join(folder_path, "Converted_PDFs")
        os.makedirs(output_folder, exist_ok=True)
        doc_files = []
        for f in os.listdir(folder_path):
            filename_lower = f.lower()
        if filename_lower.endswith(supported_exts):
                # Create the full path of the file and add it to the list
                full_path = os.path.join(folder_path, f)
                doc_files.append(full_path)
        if not doc_files:
            print("No documents found.")
            return

        for doc in doc_files:
            name = os.path.splitext(os.path.basename(doc))[0]
            output_pdf = os.path.join(output_folder, f"{name}.pdf")
            convert(doc, output_pdf)
            print(f"😎😎😎Converted: {doc} -> {output_pdf}")
    else:
        print("⚠️Invalid choice.")

# === Feature 4: Detect and Handle Duplicate Files ===
def handle_duplicates(folder):
    duplicates_folder = os.path.join(folder, "duplicates")
    os.makedirs(duplicates_folder, exist_ok=True)  
    duplicates = []     
    for filename in os.listdir(folder):   
        file_path = os.path.join(folder, filename)

        if os.path.isfile(file_path):     
            with open(file_path, "rb") as f:
                content = f.read()         

          
            duplicate_found = False
            for saved_content, saved_path in files_checked:
                if content == saved_content:
                    duplicates.append(file_path)   
                    duplicate_found = True
                    break                         

            if not duplicate_found:
                files_checked.append((content, file_path))  
    if not duplicates:
        print("No duplicate files found.")
        return
    for full_path in duplicates:
        dest_path = os.path.join(duplicates_folder, os.path.basename(full_path))
        shutil.move(full_path, dest_path)
        print("duplicate file moved to duplicated folder 😊😊😊")
# === Feature 5: Encrypt a File (XOR Encryption) ===
def encrypt_file(file_path, password):
    with open(file_path, "rb") as f:
        data = f.read()
    encrypted = bytearray() 
    key = ord(password[0])
    for b in data:                         
    encrypted_byte = b ^ key             
    encrypted.append(encrypted_byte)
    enc_path = file_path + ".enc"
    with open(enc_path, "wb") as f:
        f.write(encrypted)
    os.remove(file_path)
    print(f"🔒Encrypted and removed original: {file_path}")

# === Feature 6: Decrypt a File (XOR Decryption) ===
def decrypt_file(file_path, password):
    if not file_path.endswith(".enc"):
        raise ValueError("File must end with '.enc'")
    key = ord(password[0])
    with open(file_path, "rb") as f:
        data = f.read()
    decrypted = bytearray()            
    key = ord(password[0])             
    for b in data:                   
        decrypted_byte = b ^ key      
        decrypted.append(decrypted_byte)
    orig_path = file_path[:-4]
    with open(orig_path, "wb") as f:
        f.write(decrypted)
    print(f"🔓Decrypted to: {orig_path}")

# === Feature 7: Lock File (XOR + bcrypt) ===
def lock_file(file_path, password):
    with open(file_path, "rb") as f:
        data = f.read()

    key = password.encode() 
    salt = bcrypt.gensalt()  
    hash_key = bcrypt.hashpw(key, salt)  
    print(hash_key)
   
    xor_key = hash_key[0]  

    encrypted = bytearray()
    for b in data:
        encrypted_byte = b ^ xor_key
        encrypted.append(encrypted_byte)

    enc_path = file_path + ".hash"
    with open(enc_path, "wb") as f:
        f.write(encrypted)

    os.remove(file_path)
    print(f"🔒 Locked and removed original: {file_path}")
# === Feature 8: Unlock File (XOR + bcrypt verification) ===
def unlock_file(file_path, password):
    with open(file_path, "rb") as f:
        data = f.read()

    key = password.encode()
    salt = bcrypt.gensalt()
    hash_key = bcrypt.hashpw(key, salt)

    xor_key = hash_key[0]  

    decrypted = bytearray()
    for b in data:
        decrypted_byte = b ^ xor_key
        decrypted.append(decrypted_byte)

    original_path = file_path.replace(".hash", "")
    with open(original_path, "wb") as f:
        f.write(decrypted)

    print(f"🔓 Unlocked and restored: {original_path}")




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


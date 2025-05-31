#important modules
import os
import hashlib
import shutil
from PIL import Image
from docx2pdf import convert
from pdf2docx import Converter

import bcrypt

# === Feature 1: Batch Rename Files in a Folder ===
def batch_rename_in_folder(folder, prefix):
    files = [] 
    for item in os.listdir(folder): 
        #to get the full length of the file location 
        full_path = os.path.join(folder, item) 
        if os.path.isfile(full_path):  
            files.append(full_path)
    # Loop through all files in the list, with a count starting from 1
    #(enumerate does assign the list number and the name respectivly)
    for number, full_file_path in enumerate(files, 1):

        folder_of_file, original_file_name = os.path.split(full_file_path)
    # Get the file extension (like ".txt", ".jpg") from the file name 
    #from the last name it finds the . and at 1 is ext
        file_extension = os.path.splitext(original_file_name)[1]

        new_file_name = f"{prefix}_{number}{file_extension}"

        new_full_path = os.path.join(folder_of_file, new_file_name)
        #renaming the oldfile by new one
        os.rename(full_file_path, new_full_path)

        print(f"Renamed😎😎😎: {original_file_name} -> {new_file_name}")

# === Feature 2: Organize Files by Type ===
def organize_files_by_type(folder_path):
    # Map file extensions to folder names and there folder name
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
            # Split the filename into name and extension parts
            split_name_ext = os.path.splitext(file_name)
            extension_with_dot = split_name_ext[1]

            ext = extension_with_dot[1:].lower()
            #example like README
            if not ext:
                ext = "no_extension"
            #finds the name of folder to creat it from the dictionary
            folder_name = file_type_folders.get(ext, "Other Files")

            target_folder = os.path.join(folder_path, folder_name)

            os.makedirs(target_folder, exist_ok=True)

            new_location_file = os.path.join(target_folder, file_name)
            shutil.move(full_path, new_location_file)

    print("Files organized successfully.😊😊😊")
# === Feature 3: Convert File Extensions ===
def convert_files(folder_path, choice=None):
     # If choice is not provided, ask user
    if choice is None:
        print("Choose an option:")
        print("1. ------📒Convert images to a single PDF📒")
        print("2.-------📒 Convert documents (doc, docx) to individual PDFs📒")
        print("3.-------📒 Convert pdfs  to individual doc📒")
        choice = input("Enter 1 or 2 or 3:>>>>> ").strip()

    if not os.path.isdir(folder_path):
        print(" Invalid folder path.")
        return

    if choice == '1':
        supported_exts = ('.png', '.jpg', '.jpeg')
        # List image files
        #here we have basename
        image_files = []
        for f in os.listdir(folder_path):
            if f.lower().endswith(supported_exts):
                image_files.append(os.path.join(folder_path, f))
        image_files.sort()
        if not image_files:
            print("No images found.")
            return
             # Open and convert images to RGB the only way to generate pdf files 
        images=[]
        for img_path in image_files:
            img = Image.open(img_path)
            rgb_img = img.convert("RGB")
            images.append(rgb_img)
        # Save as a single PDF
        output_pdf = os.path.join(folder_path, "combined_images.pdf")
        first_image=images[0]
        Other_images=images[1:]
        first_image.save(
            output_pdf,          
            save_all=True,       # Save all images, not just the first
            append_images=Other_images 
            )
        print(f"😎😎😎cmbined images into PDF: {output_pdf}")

    elif choice == '2':
        supported_exts = ('.doc', '.docx')
        output_folder = os.path.join(folder_path, "Converted_PDFs")
        os.makedirs(output_folder, exist_ok=True)
        doc_files = []
        # Loop through all files in the folder
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
            file_name = os.path.basename(doc)
            # Get the filename without its extension
            #"." splits filename and 1 is number of splits and 0 index
            file_name_without_ext = file_name.rsplit('.', 1)[0]

            # Add the new '.pdf' extension
            new_file_name = file_name_without_ext + '.pdf'

            # Join the output folder path with the new filename to get the full output PDF path
            output_pdf = os.path.join(output_folder, new_file_name)
            
            convert(doc, output_pdf)
            print(f"Converted to PDF 😎😎😎")
    elif choice == '3':
    supported_exts = ('.pdf',)
    output_folder = os.path.join(folder_path, "Converted_DOCs")
    os.makedirs(output_folder, exist_ok=True)
    pdf_files = []

    for f in os.listdir(folder_path):
        filename_lower = f.lower()
        if filename_lower.endswith(supported_exts):
            full_path = os.path.join(folder_path, f)
            pdf_files.append(full_path)

    if not pdf_files:
        print("No PDF files found.")
        return

    for pdf in pdf_files:
        file_name = os.path.basename(pdf)
        file_name_without_ext = file_name.rsplit('.', 1)[0]
        new_file_name = file_name_without_ext + '.docx'
        output_doc = os.path.join(output_folder, new_file_name)

        # Convert PDF to DOCX
        try:
            cv = Converter(pdf)
            cv.convert(output_doc, start=0, end=None)
            cv.close()
            print(f"Converted {file_name} to DOCX 😎😎😎")
        except Exception as e:
            print(f"Failed to convert {file_name}: {e}")

    else:
        print("⚠️Invalid choice.")

# === Feature 4: Detect and Handle Duplicate Files ===
def handle_duplicates(folder):
    duplicates_folder = os.path.join(folder, "duplicates")
    os.makedirs(duplicates_folder, exist_ok=True)   # Create duplicates folder if not exists
    files_checked = []
    duplicates = []     
    for filename in os.listdir(folder):   
        file_path = os.path.join(folder, filename)
        #checks whether it is file or not
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
    # Create an empty bytearray to store encrypted bytes
    encrypted = bytearray() 
    # Get ASCII value of the first character of the password
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
        # XOR the byte with the key to decrypt it             
        decrypted_byte = b ^ key      
        decrypted.append(decrypted_byte)
         # Remove ".enc"
    orig_path = file_path[:-4]
    with open(orig_path, "wb") as f:
        f.write(decrypted)
    print(f"🔓Decrypted to: {orig_path}")

# === Feature 7: Lock File (XOR + bcrypt) ===
def lock_file(file_path, password):
    with open(file_path, "rb") as f:
        data = f.read()    
    salt = os.urandom(8)
    # Derive a 1-byte key from PBKDF2 (using SHA256)
    key = hashlib.pbkdf2_hmac('sha256', password.encode(), salt, 100000, dklen=1)[0]
    encrypted = bytearray()
    for b in data:
        encrypted.append(b ^ key)
    enc_path = file_path + ".lock"
    with open(enc_path, "wb") as f:
        f.write(salt + encrypted)
    os.remove(file_path)
    print(f"🔒 Locked and removed original: {file_path}")
# === Feature 8: Unlock File (XOR + bcrypt verification) ===
def unlock_file(file_path, password):
    if not file_path.endswith(".lock"):
        raise ValueError("File must end with '.lock'")
    with open(file_path, "rb") as f:
        file_data = f.read()
    salt = file_data[:8]
    encrypted = file_data[8:]
    key = hashlib.pbkdf2_hmac('sha256', password.encode(), salt, 100000, dklen=1)[0]
    decrypted = bytearray()
    for b in encrypted:
        decrypted.append(b ^ key)
        # Remove ".lock"
    orig_path = file_path[:-5]  
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
            print("--------welcome to batch renaming-------------")
            folder = input("Enter folder path:>>>> ").strip()
            prefix = input("Enter file name prefix: ")
            batch_rename_in_folder(folder, prefix)
        elif choice == '2':
            print("--------welcome to file organization-------------")
            folder = input("Enter folder path:>>>> ").strip()
            organize_files_by_type(folder)
        elif choice == '3':
            print("--------welcome to file extension tool-------------")
            file = input("Enter file: ").strip()
            convert_files(file)
        elif choice == '4':
            print("--------welcome to file duplicate finder-------------")
            folder = input("Enter folder path:>>>> ").strip()
            handle_duplicates(folder)
        elif choice == '5':
            print("--------welcome to file encryptor-------------")
            file = input("Enter file path >>>>: ").strip()
            password = input("Enter encryption password: ")
            encrypt_file(file, password)
        elif choice == '6':
            print("--------welcome to file decrypter -------------")
            file = input("Enter file path>>>: ").strip()
            password = input("Enter decryption password: ")
            decrypt_file(file, password)
        elif choice == '7':
            print("--------welcome to file locker -------------")
            file = input("Enter file path ").strip()
            password = input("Enter lock password: ")
            lock_file(file, password)
        elif choice == '8':
            print("--------welcome to file unlocker -------------")
            file = input("Enter file path ").strip()
            password = input("Enter unlock password: ")
            unlock_file(file, password)
        else:
            print("⚠️Invalid choice.")
    except Exception as e:
        print(f"Error: {e}")


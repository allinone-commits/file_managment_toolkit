if __name__ == "__main__":
    print("=== File Management Toolkit ===")
    print("Choose an option:")
    print("1. Batch Rename Files")
    print("2. Organize Files by Type")
    print("3. Convert Files")
    print("4. Detect and Handle Duplicates")
    print("5. Encrypt File")
    print("6. Decrypt File")
    print("7. Lock File")
    print("8. Unlock File")

    choice = input("Enter your choice (1-8): ").strip()

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
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

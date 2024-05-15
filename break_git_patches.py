import os
import re
import sys

def break_patch(patch_file):
    print(patch_file)
    with open(patch_file, 'r') as f:
        patch_contents = f.read()

    # Split the patch into individual files
    files = re.split(r'diff --git a/(.*?) b/(.*?)\n', patch_contents)[1:]
    
    # Create a directory to store the individual patches
    patch_dir = 'patches'
    os.makedirs(patch_dir, exist_ok=True)

    print(f'Number of Files : {len(files)}')
    # Create a patch file for each file
    for i in range(0, len(files),3):
        print(f"Iteration no {i}  >>>>>>>>>>>>>> : {files[i]}")
        print(f"Iteration no {i}  >>>>>>>>>>>>>> : {files[i+2]}")
        file_name = files[i].split('/')[-1]
        print(f"file_name: {file_name}")

        patch_content = 'diff --git a/' + file_name + ' b/' + file_name + '\n' + files[i+2]
        with open(os.path.join(patch_dir, file_name + '.patch'), 'w') as f:
            f.write(patch_content)

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: python (link unavailable) <patch_file>")
        sys.exit(1)

    break_patch(sys.argv[1])

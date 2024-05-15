import os
import subprocess
import sys

def apply_patches(patch_dir):
    successes = []
    failures = []
    for file in os.listdir(patch_dir):
        if file.endswith('.patch'):
            patch_file = os.path.join(patch_dir, file)
            try:
                subprocess.run(['git', 'apply', patch_file], check=True)
                successes.append(patch_file)
            except subprocess.CalledProcessError:
                failures.append(patch_file)
    return successes, failures

if __name__ == '__main__':
    if len(sys.argv) != 2:
        print("Usage: python (link unavailable) <patch_dir>")
        sys.exit(1)

    patch_dir = sys.argv[1]
    successes, failures = apply_patches(patch_dir)

    print("Successful patches:")
    for patch in successes:
        print(patch)

    print("\nPatches with issues:")
    for patch in failures:
        print(patch)

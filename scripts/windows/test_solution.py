import glob
import os
import subprocess
import sys


def compare_files(file1, file2):
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        content1 = f1.readlines()
        content2 = f2.readlines()

    def normalize_content(file):
        return [line.rstrip() for line in file if line.strip()]

    normalized_content1 = normalize_content(content1)
    normalized_content2 = normalize_content(content2)

    return normalized_content1 == normalized_content2

def print_file_content(file_path):
    try:
        with open(file_path, 'r') as file:
            content = file.read()
            print(content)
    except FileNotFoundError:
        print(f"File not found: {file_path}")
    except Exception as e:
        print(f"An error occurred: {e}")

def print_io_file(input_file, actual_file, expected_file):
    print("\033[93mInput:\033[0m")
    print_file_content(input_file)
    print("\033[93mOutput:\033[0m")
    print_file_content(actual_file)
    print("\033[93mExpected:\033[0m")
    print_file_content(expected_file)

def test_all_files(subfolder, lang, is_debug, file_pattern="sample-{index}"):
    # Remove all .res files before test
    res_files = glob.glob(subfolder + "\\test\\" + "*.res")
    for file in res_files:
        os.remove(file)

    file_name = subfolder + "\\" + subfolder
    execute_file = file_name + "." + lang

    # Compile if needed
    if lang == "cpp":
        try:
            command = f"build.cmd {file_name}.cpp"
            result = subprocess.run(command, shell=True)
            if result.returncode != 0:
                return
        except subprocess.CalledProcessError as e:
            print(f"Error running: {e}")
            return

        execute_file = file_name + ".exe"
    elif lang == "java":
        try:
            command = f"build_java.cmd {file_name}.java"
            result = subprocess.run(command, shell=True)
            if result.returncode != 0:
                return
        except subprocess.CalledProcessError as e:
            print(f"Error running: {e}")
            return

        execute_file = "java -cp " + subfolder + " " + subfolder

    index = 1

    while True:
        input_file = os.path.join(subfolder + "\\test", file_pattern.format(index=index) + ".in")
        expected_file = os.path.join(subfolder + "\\test", file_pattern.format(index=index) + ".out")
        actual_file = os.path.join(subfolder + "\\test", file_pattern.format(index=index) + ".res")

        if not os.path.isfile(expected_file) and not os.path.isfile(actual_file):
            break

        try:
            command = f"{execute_file} < {input_file} > {actual_file}"
            result = subprocess.run(command, shell=True)
            if result.returncode != 0:
                return
        except subprocess.CalledProcessError as e:
            print(f"Error running: {e}")
            return


        if not os.path.isfile(expected_file) or not os.path.isfile(actual_file):
            print("Something wrong !!! File doesn't match between actual and expected output")
            return

        if compare_files(expected_file, actual_file):
            print(f"Test case {index}:\033[92mAccepted\033[0m")
            if is_debug != 0:
                print_io_file(input_file, actual_file, expected_file)
        else:
            print(f"Test case {index}:\033[91mWrong Answer\033[0m")
            print_io_file(input_file, actual_file, expected_file)

        index += 1

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Please specify problem name and language to run")
        sys.exit(1)

    subfolder = sys.argv[1]
    lang = sys.argv[2]
    debug = 0
    if len(sys.argv) == 4:
        debug = int(sys.argv[3])
    file_name = subfolder + "/" + subfolder + "."
    test_all_files(subfolder, lang, debug)

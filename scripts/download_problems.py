#!/usr/bin/env python3
"""Download and setup problems using oj_api
Usage:
    download_problems.py --contest <url>
    download_problems.py --problem <url>
    download_problems.py --make_problem <name>...
    download_problems.py --clean

Options:
    -h, --help          Show this screen.
    -ct, --contest      get contest data by url
    -p, --problem       get problem data by url
    -m, --make_problem  Make problem folder only
    -c, --clean         clean problem data except source code

"""

from docopt import docopt
from pathlib import Path
import json
import validators
import subprocess
import sys
import re
import os
import shutil

lang = "cpp"  # default language

NAME_PATTERN = re.compile(r"^(?:Problem )?([A-Z][0-9]*)\b")


def get_prob_name(data):
    if "USACO" in data["group"]:
        if "fileName" in data["input"]:
            names = [
                data["input"]["fileName"].rstrip(".in"),
                data["output"]["fileName"].rstrip(".out"),
            ]
            if len(set(names)) == 1:
                return names[0]

    if "url" in data and data["url"].startswith("https://www.codechef.com"):
        return data["url"].rstrip("/").rsplit("/")[-1]

    patternMatch = NAME_PATTERN.search(data["name"])
    if patternMatch is not None:
        return patternMatch.group(1)

    print(f"For data: {json.dumps(data, indent=2)}")
    return input("What name to give? ")


def save_samples(data, prob_dir, name):
    for i, t in enumerate(data["tests"], start=1):
        with open(prob_dir / f"{name}_sample{i}.in", "w") as f:
            f.write(t["input"])
        with open(prob_dir / f"{name}_sample{i}.out", "w") as f:
            f.write(t["output"])


def make_prob(data, name=None):
    global lang
    if name is None:
        name = get_prob_name(data)
        if data is None:
            print("Unexpected error...")
            return

    # Using current dir, set sample name by problem in save_samples
    prob_dir = Path(".")

    file_name = name + "." + lang
    if os.path.exists(file_name):
        print(f"Already created problem {name}...")
    else:
        print(f"Creating problem {name}...")

        MAKE_PROB = Path(sys.path[0]) / "make_problem.sh"
        try:
            subprocess.check_call(
                [MAKE_PROB, name, lang], stdout=sys.stdout, stderr=sys.stderr
            )
        except subprocess.CalledProcessError as e:
            print(f"Got error {e}")
            return

    if data is not None:
        print("Saving samples...")
        save_samples(data, prob_dir, name)


def get_problem(url_problem):
    print(f"link problem: {url_problem}")
    f = open("problem.json", "w")
    problem_data = None
    subprocess.call(["oj-api", "get-problem", "--compatibility", url_problem], stdout=f)
    problem_data = json.load(open("problem.json", "r"))
    if problem_data is not None and problem_data["status"] == "ok":
        print(f"Got data {json.dumps(problem_data)}")
        make_prob(problem_data["result"])


def get_contest(url_contest):
    if validators.url(url_contest):
        contest_data = None
        f = open("links.json", "w")
        subprocess.call(["oj-api", "get-contest", url_contest], stdout=f)
        contest_data = json.load(open("links.json", "r"))
        if contest_data is None:
            print("Got no data")
        elif contest_data["status"] == "ok":
            print(f"Got data {json.dumps(contest_data)}")
            for data in contest_data["result"]["problems"]:
                get_problem(data["url"])

        else:
            error_status = contest_data["status"]
            print(f"Error status: {error_status}")
    else:
        print("Invalid URL contest")


def prepare_build():
    if (Path(".") / "build").exists():
        print("Exists folder build")
    else:
        os.mkdir("build")

    os.chdir("build")
    os.system("cmake .. && make template")


def main():
    arguments = docopt(__doc__)
    global lang

    if arguments["--clean"]:
        for filename in os.listdir("./"):
            if (
                filename.endswith(".in")
                or filename.endswith(".out")
                or filename.endswith(".res")
            ):
                os.remove(filename)
        if os.path.isdir("build"):
            shutil.rmtree("build")
        print("Done clean all")
        return
    if arguments["--make_problem"]:
        if names := arguments["<name>"]:
            for name in names:
                make_prob(None, name)
        return

    print("Enter language: ", end="")
    lang = input()
    if lang == "":
        lang = "cpp"

    if url := arguments["<url>"]:
        if arguments["--contest"]:
            get_contest(url)
        else:
            get_problem(url)

    if lang == "cpp":
        prepare_build()


if __name__ == "__main__":
    main()

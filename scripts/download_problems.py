#!/usr/bin/env python3
"""Download and setup problems using oj_api
Usage:
    download_problems.py --contest <url>
    download_problems.py --problem <url>
    download_problems.py -n <number>
    download_problems.py --make_problem <name>...
    download_problems.py --clean

Options:
    -h, --help                      Show this screen.
    -a, --contest                   Get all problems data in contest by url
    -o, --problem                   Get one problem data by url
    -n COUNT, --number COUNT        Number of problems
    -m, --make_problem              Make problem folder only
    -c, --clean                     clean problem data except source code

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
import http.server

lang = "cpp"  # default language

NAME_PATTERN = re.compile(r"^(?:Problem )?([A-Z][0-9]*)\b")

defaultPorts = (
    1327,  # cpbooster
    4244,  # Hightail
    6174,  # Mind Sport
    10042,  # acmX
    10043,  # Caide and AI Virtual Assistant
    10045,  # CP Editor
    27121,  # Competitive Programming Helper
)


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


def listen_once(*, second=None):
    json_data = None

    class CompetitiveCompanionHandler(http.server.BaseHTTPRequestHandler):
        def do_POST(self):
            nonlocal json_data
            json_data = json.load(self.rfile)

    with http.server.HTTPServer(
        ("127.0.0.1", defaultPorts[0]), CompetitiveCompanionHandler
    ) as server:
        server.second = second
        server.handle_request()

    if json_data is not None:
        print(f"Got data {json.dumps(json_data)}")
    else:
        print("Got no data")
    return json_data


def listen_many(*, num_items=None, num_batches=None, second=None):
    if num_items is not None:
        res = []
        for _ in range(num_items):
            cur = listen_once(second=None)
            res.append(cur)
        return res

    if num_batches is not None:
        res = []

        batches = {}
        while len(batches) < num_batches or any(need for need, tot in batches.values()):
            print(f"Waiting for {num_batches} batches:", batches)
            cur = listen_once(second=None)
            if cur is not None:
                res.append(cur)

                cur_batch = cur["batch"]
                batch_id = cur_batch["id"]
                batch_cnt = cur_batch["size"]
                if batch_id not in batches:
                    batches[batch_id] = [batch_cnt, batch_cnt]
                assert batches[batch_id][0] > 0
                batches[batch_id][0] -= 1

        return res

    res = [listen_once(second=None)]
    while True:
        cnd = listen_once(second=second)
        if cnd is None:
            break
        res.append(cnd)
    return res


def make_prob(data, name=None):
    global lang
    if name is None:
        name = get_prob_name(data)
        if data is None:
            print("Unexpected error...")
            return

    # Using current dir, set sample name by problem in save_samples
    prob_dir = Path("./"+name)

    # file_name = name + "." + lang
    # alter_name = name + "."
    # if lang == "cpp":
    #     alter_name += "cc"
    # if os.path.exists(file_name) or os.path.exists(alter_name):
    #     print(f"Already created problem {name}...")
    # else:
    # print(f"Creating problem {name}...")

    print("Running make_problem.sh ...")
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
    subprocess.call(
        ["oj-api", "get-problem", "--compatibility", url_problem], stdout=f)
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
        shutil.rmtree("build")
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

    print("Enter language: ", end="")
    lang = input()
    if lang == "":
        lang = "cpp"

    if arguments["--make_problem"]:
        if names := arguments["<name>"]:
            for name in names:
                make_prob(None, name)
    elif url := arguments["<url>"]:
        if arguments["--contest"]:
            get_contest(url)
        else:
            get_problem(url)
    elif cnt := arguments["--number"]:
        cnt = int(cnt)
        datas = listen_many(num_items=cnt)
        for data in datas:
            make_prob(data)

    # if lang == "cpp":
    #     prepare_build()


if __name__ == "__main__":
    main()

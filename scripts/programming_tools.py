#!/usr/bin/env python3
import argparse
import logging
import sys
import json
import subprocess
import re
from pathlib import Path
from http.server import SimpleHTTPRequestHandler, HTTPServer

VERSION = '2.0'
logger = logging.getLogger(__name__)
NAME_PATTERN = re.compile(r"^(?:Problem )?([A-Z][0-9]*)\b")
SUPPORTED_LANGUAGE_EXTENSION = ['cpp', 'py']
LOG_FORMAT = '%(asctime)s [%(levelname)s] %(funcName)s(): %(lineno)d  %(message)s'

RED = '\033[0;31m'
GREEN = '\033[0;32m'
YELLOW = '\033[0;33m'
RESET = '\033[0m'  # No Color

HOST = "127.0.0.1"
PORT = 10043


class ColoredFormatter(logging.Formatter):
    COLORS = {
        'WARNING': YELLOW,
        'ERROR': RED
    }

    def format(self, record):
        level = record.levelname
        if level in self.COLORS:
            record.levelname = f'{self.COLORS[level]}{level}{RESET}'
        return super().format(record)


def init_logger(log_file=None):
    logger.setLevel(logging.DEBUG)
    if log_file is None:
        log_handler = logging.StreamHandler()
    else:
        log_handler = logging.FileHandler(log_file)
    log_handler.setFormatter(ColoredFormatter(LOG_FORMAT))
    logger.addHandler(log_handler)


def get_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description='Tool for competitive programming')

    parser.add_argument('--version', '-v', action='store_true',
                        help='show tool version number')

    parser.add_argument('--prepare', '-p', nargs='+',
                        help='create problem folder')

    parser.add_argument('--number', '-n', type=int,
                        help='number of problems to download')

    return parser


def get_problem_name(data) -> str:
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

    print(f"Data: {json.dumps(data, indent=2)}")
    return input('Enter name for this problem: ')


def save_samples(json_data, problem_path):
    for i, t in enumerate(json_data["tests"], start=1):
        with open(problem_path / f"sample-{i}.in", "w") as f:
            f.write(t["input"])
        with open(problem_path / f"sample-{i}.out", "w") as f:
            f.write(t["output"])


def create_problem_folder(json_data=None, problem_name=None) -> bool:
    if problem_name is None:
        if json_data is None:
            logger.error(
                'Both data and folder name are invalid. Cannot create folder')
            return False

        problem_name = get_problem_name(json_data)

    logger.info('Problem name: %s', problem_name)

    MAKE_PROBLEM = Path(sys.path[0]) / "make_problem.sh"
    for extension in SUPPORTED_LANGUAGE_EXTENSION:
        try:
            subprocess.check_call(
                [MAKE_PROBLEM, problem_name,
                    extension], stdout=sys.stdout, stderr=sys.stderr
            )
        except subprocess.CalledProcessError as e:
            logger.error('Got error %s', e)
            return False

    problem_path = Path("./"+problem_name+'/test')
    if json_data is not None:
        logger.info('Saving samples...')
        save_samples(json_data, problem_path)

    print(GREEN + problem_name + ' is created' + RESET)

    return True


def prepare_problems(names: list[str]) -> bool:
    res = True
    for name in names:
        if not create_problem_folder(problem_name=name):
            logger.warning('Cannot create folder %s', name)
            res = False

    return res


# Use extension from https://github.com/jmerle/competitive-companion
def listen_from_competitive_companion(max_requests: int):
    received_json_data = []
    request_count = 0

    class CompetitiveCompanionHandler(SimpleHTTPRequestHandler):
        def do_POST(self):
            nonlocal received_json_data, request_count
            request_count += 1
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
            json_data = json.loads(post_data.decode('utf-8'))

            logger.info('Received json data')
            logger.info(json_data)
            received_json_data.append(json_data)

            self.send_response(200)
            self.send_header('Content-type', 'application/json')
            self.end_headers()
            response = json.dumps({"status": "success"})
            self.wfile.write(response.encode('utf-8'))

    server_address = (HOST, PORT)
    httpd = HTTPServer(server_address, CompetitiveCompanionHandler)

    try:
        while request_count < max_requests:
            httpd.handle_request()
    except KeyboardInterrupt:
        pass
    finally:
        httpd.server_close()
        logger.info('Server stopped!!!')

    if len(received_json_data) != max_requests:
        logger.warning('Something wrong !!!. Data size: %d, total request: %d', len(
            received_json_data), max_requests)

    return received_json_data


def download_by_number(total_problems: int) -> bool:
    datas = listen_from_competitive_companion(total_problems)
    res = True
    for data in datas:
        if not create_problem_folder(json_data=data):
            logger.warning('Cannot create folder with this data')
            res = False

    return res


def run(parser: argparse.ArgumentParser) -> int:
    args = parser.parse_args()

    if args.version:
        print('programming_tool version', VERSION)
    elif args.prepare:
        if not prepare_problems(args.prepare):
            return 1
    elif args.number:
        if not download_by_number(args.number):
            return 1
    else:
        parser.print_help()
        return 1

    return 0


def main():
    init_logger()
    sys.exit(run(get_parser()))


if __name__ == '__main__':
    main()

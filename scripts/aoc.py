import argparse
import pathlib

project_root = pathlib.Path(__file__).parent.parent.resolve()

def parse_target(text: str) -> tuple[str, str]: # (path to that folder, solution name)
    year, rest = text.split("/")
    day, solution = rest.split(".")

    if len(year) == 2:
        year = f"20{year}" # 24 -> 2024
    day = f"{int(day):02d}"

    solution_path = project_root.joinpath() / year / day / solution
    print(solution_path)

def get_input(target: str):
    pass

def run(target: str):
    # if no input -> get_input()
    pass
    

parser = argparse.ArgumentParser(
    prog="Advent of Code Utility",
)

parser.add_argument('command', choices=('get-input', 'run'), help='action to perform')
parser.add_argument('target', type=str, help='solution to run in the format "{year}/{day}.{solution}" e.g. 2024/01.1')

parser.add_argument('-v', "--verbose", help='show output', action='store_true')

args = parser.parse_args()
# parser.print_help()

command = args.command
target = parse_target(args.target)
if command == "run":
    # run()
    pass
elif command == "get-input":
    pass
    # get_input()

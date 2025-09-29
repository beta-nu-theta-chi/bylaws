from collections.abc import Iterator
import re
import random
import string
from pathlib import Path

HEADER_PATTERN = re.compile(r'^(##? .+?)(\s*\{#.*\})?\s*$')
TAG_TEMPLATE = ' {#sec-art-%s}'
ID_LENGTH = 8

def generate_id() -> str:
    return ''.join(random.choices(string.ascii_uppercase + string.digits, k=ID_LENGTH))

def process_file(filepath: Path):
    changed = False
    new_lines: list[str] = []

    with filepath.open("r") as f:
        for line in f:
            match = HEADER_PATTERN.match(line)
            if match:
                header_text, existing_tag = match.groups()
                if not existing_tag:
                    new_tag = TAG_TEMPLATE % generate_id()
                    line = header_text + new_tag + '\n'
                    changed = True
            new_lines.append(line)

    if changed:
        with filepath.open("w") as f:
            f.writelines(new_lines)
        print(f"Updated: {filepath}")

def main():
    pathes: Iterator[Path] = Path('.').glob("**/*.qmd")
    for path in pathes:
        process_file(path)

if __name__ == '__main__':
    main()

import glob
from typing import TypedDict
import yaml

class Item(TypedDict):
    term: str
    definition: str

Glossary = list[Item]

def load_glossary(file_path: str) -> Glossary:
    glossary = []
    with open(file_path) as stream:
        try:
            glossary: Glossary = yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            print(exc)
    return glossary

def get_sec_name(item: Item) -> str:
    sec_name = "-".join("".join([i for i in item['term'] if i.isalpha() or i == " "]).split(" ")).lower()
    sec_name += ""

    return sec_name

def generate_glossary(glossary: Glossary, acronyms: Glossary) -> str:
    glossary_str = "# Glossary\n\n"
    glossary_str += "\n".join(f"## {item['term']} {"{#sec-"}{get_sec_name(item)}{"}"}\n\n{item['definition']}" for item in glossary)
    glossary_str += "\n# Acronyms\n\n"
    glossary_str += "\n".join(f"## {item['term']} {"{#sec-"}{get_sec_name(item)}{"}"}\n\n{item['definition']}\n" for item in acronyms)

    return glossary_str

def generate_env(glossary: Glossary, acronyms: Glossary) -> str:
    gloss = {}
    acron = {}
    for item in glossary:
        gloss[get_sec_name(item)] = f"[{item['term']}](glossary.qmd#sec-{get_sec_name(item)})"

    for item in acronyms:
        acron[get_sec_name(item)] = f"[{item['term']}](glossary.qmd#sec-{get_sec_name(item)})"

    return yaml.dump({"glossary": gloss, "acronyms": acron})

glossary = load_glossary("glossary.yaml")
acronyms = load_glossary("acronyms.yaml")

with open("glossary.qmd", "w") as f:
    _ = f.write(generate_glossary(glossary, acronyms))

with open("_variables.yml", "a") as f:
    _ = f.write(generate_env(glossary, acronyms))

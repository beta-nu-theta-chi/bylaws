files <- strsplit(Sys.getenv("QUARTO_PROJECT_INPUT_FILES")[1], "\n")[[1]]
glossary <- readLines("glossary.qmd")
terms <- glossary[stringr::str_detect(glossary, "^## ")] |>
  stringr::str_remove_all("## ") |>
  stringi::stri_replace_all_regex("\\{*\\}", "")
print(files)

for (f in files) {
  if (f != "glossary.qmd") {
    co <- readLines(f)
    if (any(stringr::str_detect(co, paste0(terms, collapse = "|")))) {
      print(f)
      print(terms)
      co <- stringi::stri_replace_all_regex(co, paste0("(?<![:#])", terms),
        paste0("[:", terms, "](/glossary.html#", terms, ")"), vectorize_all = FALSE)
      writeLines(co, f)
    }
  }
}
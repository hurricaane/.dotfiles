<!-- markdownlint-disable MD025 -->

# Title: Sort YAML dictionaries alphabetically

# Category: Edit

# Tags: sort, yaml, dictionaries, files

---

To sort YAML dictionaries from Neovim, use `yq` directly :

```vim
:%!yq -o=yaml '.DICTIONARY_NAME |= sort_keys(.)' -
```

Change `DICTIONARY_NAME` with the name of the dictionary

===

# Lightest Ostis Pancake

## Installation

Clone repository:

```sh
git clone https://github.com/semantic-pie/lightest-ostis-pancake
```

To install the necessary components (sc-web, sc-machine, kb), run the following command:

```bash
./pancake.sh install
```

## Running OSTIS

To run ostis, use following command:

```bash
./pancake.sh run
```

## Cleaning Knowledge Bases

To remove all installed knowledge base folders, execute the following command:

```bash
./pancake.sh clean
```

(it doesn't remove repos from requirements)

## Adding a Knowledge Base

To add a new knowledge base from a git repository, use the following command:

```bash
./pancake.sh add <repo_url>:<repo_name> 
```

Replace <repo_url> with the URL of the git repository and <repo_name> with the desired name for the repository. If <repo_name> is not provided, it will default to the repository's base name.

You can provide:

```bash
./pancake.sh add <repo_url>
```

## Help

To display the usage information and available options, run the following command:

```bash
./pancake.sh --help
```

# The floating git banner

Manages a banner image of pixel art on the git commit graph by hacking some commit times

### Requirements:
* git 
  - This code uses git commit history editting to set up commits a certain points to color the graph
* touch 
  - Any touch implementation *SHOULD* do
  - Versions that are currently tested:
    * GNU coreutils

### Install:
After cloning this repository, you will need to initialize a seperate repoistory for managing banner commits.

```
rm -rf .git
git init
git remote add origin <your new repo name>
```
It's important that when you create this repo, you don't track the scripts and other files, as changes are repeatedly applied/rolled back. Instead the script manipulates one file: `launched`

```
touch launched
git add launched
git commit -m 'And so it begins'
```

### Usage
There isn't much to it, just run the script at `./scripts/changelog`

This will write a sizeable number of commits to each of the days specified in the scripts, and your pixel art will go live.

### Maintenance
For updating the script, the only way to erase commits from your commit history is to delete the repository and re-create it (with the same name).

Then re-run the script.

The Confirmation setup for the git API is not easily, automatible, stay tuned for better solutions.
 



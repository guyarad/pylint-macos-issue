# pylint-macos-issue

This repository demonstrated what seems like at least one bug with `pylint` and MacOS.

## TL;DR
No virtual environment neceesary. Simply run `./run` from the repository root.

If you see 

    TEST COMPLETED SUCCESSFULLY

The bug was reproduced successfully on your machine.

## Background
I identify the issue when my code had a slightly complex import hierarchy.

Consider module `module1` that exposes both `Base` and `Derived` via its `__init__.py` file (see the file structure in the repo).
`Derived` class is using `Base`, importing it from the module itself (and not directly).

Essentially, this might be considered a circular import, but the code works and is legal Python structure.

What we found is that `pylint` works just fine running a MacOS, but fails inside a linux docker.
Testing the issue locally, I found that pylint has an inconsistent behavior running inside the docker.
I created a docker with code, but also mounted the code when running the docker. 
Essentially, we now have 2 identical folders, one is a docker local folder, and the other is a mounted folder.
Running pylint in the local folder **fails** but running it in the mounted folder **succeeds**.
Everything is identical - the files, the environment variables etc.
I also checked 


## What `run` does?
1. Builds a docker where all the repository content is copied to `code` folder.
2. Runs the docker, while mounting the repository onto `mounted_code`, which runs `./bug-repro`.

### What `bug-repro` does?
1. Shows that `pylint` fails on the docker local code folder.
2. Shows that `pylint` succeeds on the mounted folder.
3. Shows that the mounted folder and the docker local folder are identical (to prove pylint was supposed to behave exactly the same).
4. Issue resolution 1: shows that adding an empty `__init__.py` in the code root will make `pylint` succeeds on the local folder as well.
5. Issue resolution 2: "fix" the cirular dependency to statisfy `pylint` on the local folder as well.


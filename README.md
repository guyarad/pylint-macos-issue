# pylint-macos-issue

This repository demonstrated what seems like at least one bug with `pylint` and MacOS.

## TL;DR
No virtual environment neceesary. Simply use the provided `Makefile`.

    make bug_repro

    make verify_resolutions
    
## Summary of the issues

1. Inconsistency of `pylint` behavior when running inside a docker, but once on a mounted folder and once in a docker local folder.
2. One of the resolutions to the failure isn't supposed to really solve it.

## Background
I identify the issue when my code had a slightly complex import hierarchy.

Consider module `module1` that exposes both `Base` and `Derived` via its `__init__.py` file (see the file structure in the repo).
`Derived` class is using `Base`, importing it from the module itself (and not directly).

Essentially, this might be considered a circular import, but the code works and is legal Python structure.

What we found is that `pylint` works just fine running a MacOS, but fails inside a linux docker.

Testing the issue locally, I found that pylint has an inconsistent behavior running inside the docker.

I created a docker with the code, but also mounted the code when running the docker. 
Essentially, we now have 2 identical folders, one is a docker local folder, and the other is a mounted folder.

Running pylint in the local folder **fails** but running it in the mounted folder **succeeds**.
Everything is identical - the files, the environment variables etc. 
I also checked the "report" `pylint` produces what asked. The stats of files and lines checked are identical.

Still, in the mounted folder it passes, but fails in the docker local folder.

### Resolutions

Demostrated in

    make verify_resolutions

1. Avoid the aledged circular dependency by importing `Base` directly from it's contained file.
2. Add empty `__init__.py` to the repository root.

Where resolution #1 indeed avoids the circular dependency, resolution #2 does not. 
So except for the inconsistency between the local and mounted folders, there's an unexpected resolution to the issue.

### What `bug-repro` does?
1. Shows that `pylint` fails on the docker local code folder.
2. Shows that `pylint` succeeds on the mounted folder.
3. Shows that the mounted folder and the docker local folder are identical (to prove pylint was supposed to behave exactly the same).

### What `verify-resolutions` does?
1. Double-check `pylint` is still failing on the docker local folder.
2. Issue resolution 1: shows that adding an empty `__init__.py` in the code root will make `pylint` succeeds on the local folder as well.
5. Issue resolution 2: "fix" the cirular dependency to statisfy `pylint` on the local folder as well.


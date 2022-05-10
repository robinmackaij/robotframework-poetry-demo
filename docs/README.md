# Robot Framework poetry demo
This repo demonstrates how poetry can be used to distribute Robot Framework
resources between repos and also show some tips and tricks that can help you
in managing your Robot Framework projects.

## `poetry` and the `pyproject.toml` file
The cornerstone for `poetry` is the `pyproject.toml` file.
This file holds the information needed to ensure a suitable Python version is
used when creating the virtual environment for the repo, which dependencies
should be installed in that virtual environment, etc.
It also provides the information needed when you want to build and distribute
the code in the repo; things like the version number, the author(s) and / or
maintainers, a description of the project, etc.

## A minimal `pyproject.toml` file
Let's take a look at a (close to) minimal `pyproject.toml` file:
```toml
[tool.poetry]
name="the name of the package"
version = "1.0.0"
description = "a short description of the package"
authors = ["name of the author <email of the author>"]
packages = [
    { include = "RobotFrameworkResources", from = "src" },
]
include = ["*.resource"]

[tool.poetry.dependencies]
python = "^3.8"
robotframework = ">=4"

[build-system]
requires = ["poetry-core>=1.0.0"]
build-backend = "poetry.core.masonry.api"

```

### The `[tool.poetry]` section
In this section, we can find some general information about the project / package.
The `name`, `description` and `authors` tell us what the package is for and who
wrote it.

The `version` is used is used by tools like `pip` (and `poetry`!) when checking
for updates of the `dependencies` of a project.
If you use `poetry` to manage the environment and dependencies of your Robot
Framework tests, the `version` is not used directly.

The `packages`, like `version`, may not be used but it is required and it's a
good idea to think of a proper (folder) structure for your repo even if you don't
distribute it.
In this example, the `src` (short for source) folder holds the `RobotFrameworkResources`
package to be included in the distribution.
But even if you don't need to distribute your project, it's a good idea to have a
folder at the root of the repo that makes it clear where the main content of your
repo can be found to separate that from supporting files such as configuration files
(e.g. `pyproject.toml` and `poetry.lock`) and documentation (e.g. 'README.md`).

The `include` is not part of a minimum `pyproject.toml` configuration but I've
included it here since we'll need to define it if we want to make a Robot Framework
Resource distribution.
By default, only Python files (e.g. `.py` and related extensions) are included when
building a distribution.
To include files with other extensions, such as `.resource` or `.robot`, we need
to specify them.

### The `[tool.poetry.dependencies]` section
This section defines two things:
*   The Python version(s) required to use the repo.
*   The packages / libraries and their acceptable version that are needed by the
code in the package.

### The `[build-system]` section
The section as shown is automatically generated if you create a new `pyproject.toml`
file using `poetry new` or `poetry init`.
Unless you have a reason to change it (and then you'll know why), we can just leave
this as is.

## The basic `poetry` commands
There are many `poetry` commands (full documentation can be found
[here](https://python-poetry.org/docs/cli/)).
To get started with `poetry`, the most important ones are the following ones:
*   `install <package>`: If you're working in a repo with either a `pyproject.toml`
or `poetry.lock` file in it, this will install all the dependencies and the
project itself.
*   `add <package>`: To add a package to your project.
This is the equivalent of `pip install` but with one major difference:
After you `add` a package, `poetry` will first check that all packages and their
dependencies that are in the project are compatible with each other.
This means that `poetry` will try to find a combination of package versions that
satisfies all the version requirements / restrictions of all packages in the project.
If such a combination is found, `poetry` generate / update the `poetry.lock` file
file that "pins" these exact versions.
*   `remove <package>`: Remove a package from your project. This is similar
to `pip uninstall` but with an important difference: dependencies of the removed
package that are no longer referenced will also be removed.
After this is done, the `poetry.lock` file is updated.
*   `update [<package>]`: Updates a package (if provided) or all packages in the
project and their dependencies to the highest versions that satisfies the version
requirements of all packages in the project.
After resolving the dependencies, the `poetry.lock` file is updated.
*   `show`: Similar to `pip list`, `poetry show` will show which packages and their
version that are installed in the active (virtual) environment.
The optional `--tree` flag is interesting here: instead of a flat list of installed
packages, the dependencies tree of the installed packages is shown.
This can give you insight in what packages are used "under water" and which packages
are depended on by multiple packages in the project.

## Building and distributing a Robot Framework resources package
In addition to managing the dependencies of a repo / project, `poetry` also supports
building and publishing projects.
When you run the `poetry build` command, `poetry` will create a `wheel` (`.whl`) and
a `sdist` (`.tar.gz`) file in the `/dist` folder in the project root.
These files can be used to install the project package in another environment or to
distribute the package using a tracker such as pypi.

### Publishing using a tracker
To distribute the package through a tracker, the `poetry publish` command is used.
Using this command will prompt for a (pypi) user name and password.

If the package is an internal package that should not be publicly available, pypi is
not the tracker that should be used but an organisation may have its own internal
tracker available.
You can configure such an internal (private) tracker in the `pyproject.toml` file:
```
[[tool.poetry.source]]
name = 'private'
url = 'http://example.com/simple'
```
To publish to such a tracker, use the `poetry publish -r private` command.

In addition, you can add the following classifier to the `[tool.poetry]` section:
```
classifiers = [
    "Private :: Do Not Upload",
]
```
Adding a classifier with `Private ::` will prevent accidental uploads to pypi.

### Publishing on GitHub
Another way to distribute a package that's build from a GitHub repo is to create a
release on GitHub and upload the `.whl` and `.tar.gz` files.
Doing this will make the package available to be added in another repo:
`poetry add git+https://github.com/robinmackaij/robotframework-poetry-demo.git`

If the repo being published is a private repo, only those with access to the repo can
add the package to their own project.

## Using a Robot Framework resource distribution in a test project


## The `pyproject.toml` and tool settings

## The `[tool.poetry.dev-dependencies]` section and `invoke`

## Using `poetry` with Docker and / or Jenkins

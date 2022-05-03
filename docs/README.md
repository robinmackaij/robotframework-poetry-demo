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

## Using `poetry` commands

## Building and distributing a Robot Framework resources package

## Using a Robot Framework resource distribution in a test project

## `pyproject.toml` and tool settings

## The `[tool.poetry.dev-dependencies]` section and `invoke`

## Using `poetry` with Docker and / or Jenkins

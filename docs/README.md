# Robot Framework packaging demo
This repo demonstrates how tools like uv or poetry can be used to distribute Robot Framework resources between repos and also show some tips and tricks that can help you in managing your Robot Framework projects.

## The `pyproject.toml` file
The cornerstone for distributing the Robot Framework resources is the `pyproject.toml` file.
This file holds the information needed to ensure a suitable Python version is used when creating the virtual environment for the repo, which dependencies should be installed in that virtual environment, etc.
It also provides the information needed when you want to build and distribute the code in the repo; things like the version number, the author(s) and / or maintainers, a description of the project, etc.

There are a number of tools you can choose from to install and / or build the project but the essence is the same.
If you're not already using a certain tool, I would suggest either `uv` or `poetry`.
> The install instructions for `uv` can be found [here](https://docs.astral.sh/uv/getting-started/installation/)

> The install instructions for `poetry` can be found [here](https://python-poetry.org/docs/#installation)

> Tip: when `poetry` has been installed, you can configure it to create the virtual environment for repos in the repo itself (instead of somewhere in the user data). Note that `uv` does this by default.
> This makes it easier to inspect the content of the `.venv` or delete the `.venv` (for example to update the Python version used).
> The command to do this is the following:
> ```
> poetry config virtualenvs.in-project true
> ```

## A minimal `pyproject.toml` file
> All the information about the `pyproject.toml` can be found [here](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/#writing-your-pyproject-toml)

Let's take a look at a (close to) minimal `pyproject.toml` file.

```toml
[build-system]
requires = ["hatchling >= 1.26"]
build-backend = "hatchling.build"

[tool.hatch.build.targets.sdist]
include = ["*.resource"]

[tool.hatch.build.targets.wheel]
packages = ["src/RobotFrameworkResources"]

[project]
name = "name-of-the-package"
version = "1.0.0"
description = "a short description of the package"
readme =  "README.md"
authors = [{name = "name of the author", email = "email address"}]
requires-python = ">= 3.10"
dependencies = [
    "robotframework>=7.0.0",
]

[tool.poetry]
packages = [
    {include = "RobotFrameworkResources", from = "src"},
]

```

### The `[build-system]` section
The build-system is responsible for creating a distribution that can be used by other repos.
Both `uv` and `poetry` have their own build-system that could be used, but both tools can work with `hatchling`.
You can read more about this [here](https://packaging.python.org/en/latest/guides/writing-pyproject-toml/#declaring-the-build-backend)

### The `[tool.hatch.build.targets.sdist]` and `[tool.hatch.build.targets.wheel]` sections
These sections are specific for `hatch`/`hatchling` and define what part of the repo is meant to be distributed and what files / file types should be included in the distribution.
You can find more information [here](https://hatch.pypa.io/latest/config/build/#build-system)
If you use a different build system, consult the appropriate documentation for the details.

> The main point of attention here is the inclusion of `*.resource` files since those are not regular Python files that most build backend will include by default.

The `packages` defines which folders are part of the distribution and it's a good idea to think of a proper (folder) structure for your repo even if you don't distribute it.
In this example, the `src` (short for source) folder holds the `RobotFrameworkResources` package to be included in the distribution.
Even if you don't need to distribute your project, it's a good idea to have a folder at the root of the repo that makes it clear where the main content of your repo can be found to separate that from supporting files such as configuration files (e.g. `pyproject.toml`, `.gitignore`, etc.) and documentation (e.g. `README.md`).

> Note that this repo does not use a `src` folder but instead demonstrates three different ways of how you could structure your repo.
> The `flat` structure is the most basic, while `nested` and `split` are increasingly complex.
> Refer to the `pyproject.toml` of this repo to see how to include these different ways of organizing the project into a distribution.

### The `[project]` section
In this section, we can find some general information about the project / package.
The `name`, `description`, `authors` and `readme` tell us what the package is for and who wrote it.

The `version` is used is used by tools like `pip`, `poetry` and `uv` when checking for updates of the `dependencies` of a project.

The `requires-python` field determines the supported Python versions for the distribution.

Finally the `dependencies` defines the packages (libraries) and their acceptable version that are needed by the code in the package.

### The `[tool.poetry]` section
While `uv` supports the `[tool.hatch.build]` sections to read the package structure, `poetry` does not (at the time of writing) and needs a tool-specific section to make the package (locally) installable.
Depending on the exact tools you use for your project, you may find / need other `[tool.abc]` sections in the `pyproject.toml`.

## The basic `uv` and `poetry` commands
There are many `uv`/`poetry` commands but the most important ones are very similar.

*  `uv sync`/`poetry install`: If you're working in a repo with either a `pyproject.toml` or `uv.lock`/`poetry.lock` file in it, this will install all the dependencies and the project itself.
*   `uv/poetry add <package>`: To add a package to your project.
    This is the equivalent of `pip install` but with one major difference:
    After you `add` a package, `uv`/`poetry` will first check that all packages and their dependencies that are in the project are compatible with each other.
    This means that `uv`/`poetry` will try to find a combination of package versions that satisfies all the version requirements / restrictions of all packages in the project.
    If such a combination is found, `uv`/`poetry` generate / update the `uv.lock`/`poetry.lock` file file that "pins" these exact versions.
*   `remove <package>`: Remove a package from your project.
    This is similar to `pip uninstall` but with an important difference: dependencies of the removed package that are no longer referenced will also be removed.
    After this is done, the lock file is updated.
*   `uv lock --upgrade`/`uv lock --upgrade-package <package>`/`poetry update [<package>]`: Updates a package (if provided) or all packages in the project and their dependencies to the highest versions that satisfies the version requirements of all packages in the project.
    After resolving the dependencies, the lock file is updated.
*   `uv tree`/`poetry show --tree`: Similar to `pip list`, this will show which packages and their version that are installed in the active (virtual) environment.
    Instead of a flat list of installed packages, the dependencies tree of the installed packages is shown.
    This can give you insight in what packages are used "under the hood" and which packages are used by multiple packages in the project.

## Building and distributing a package
In addition to managing the dependencies of a repo / project, `uv`/`poetry` also supports building and publishing projects.
When you run the `uv/poetry build` command, `uv`/`poetry` will create a `wheel` (`.whl`) and a `sdist` (`.tar.gz`) file in the `/dist` folder in the project root.
These files can be used to install the project package in another environment or to distribute the package using a tracker such as pypi.

### Publishing using a tracker
To distribute the package through a tracker, the `uv/poetry publish` command is used.
Using this command will (by default) prompt for a (pypi) user name and password.

If the package is an internal package that should not be publicly available, pypi is not the tracker that should be used but an organisation may have its own internal tracker available.
You can configure such an internal (private) tracker in the `pyproject.toml` file:
```toml
[[tool.uv.index]]
name = "private"
url = "http://example.com/simple"
publish-url = "http://example.com/simple"
explicit = true

[[tool.poetry.source]]
name = "private"
url = "http://example.com/simple"
```
To publish to such a tracker, use the `uv publish --index private`/`poetry publish -r private` command.

In addition, you can add the following classifier to the `[project]` section:
```toml
classifiers = [
    "Private :: Do Not Upload",
]
```
Adding a classifier with `Private ::` will prevent accidental uploads to pypi.

### Publishing on GitHub
Another way to distribute a package that's build from a GitHub repo is to create a release on GitHub and upload the `.whl` and `.tar.gz` files.
Doing this will make the package available to be added in another repo by using the following command in the other repo:
```
poetry add git+https://github.com/robinmackaij/robotframework-poetry-demo.git#main
```

If the repo being published is a private repo, only those with access to the repo can add the package to their own project.

## Using a Robot Framework resource distribution in a test project
After a Robot Framework resource package how been published and added to a repo, its Keywords and / or Variables can be used by importing them in the `*** Settings ***`:
```robotframework
*** Settings ***
Resource    Flat/Keywords.resource

*** Test Cases ***
Can Get Url
    ${url}=    Get Main Site Url
```
In this example project, `Keywords.resource` imports `Variables.resource` so the variables are also available.

> For examples for the different repo structures, refer to the test suites in the `tests` folder.

## The `[dependency-groups]` section and `invoke`
In addition to the `dependencies` in the `[project]` section, there is also supports for the  `[dependency-groups]` section that can be used to define which supporting packages can (or should) be used when working on the project.
Packages typically found in this section are tools to increase code quality (e.g. `black`, `mypy`, `tidy`, `robocop`) and to run the tests for the project and measure code coverage (e.g. `pytest`, `coverage`, `robotframework`).
More information on this can be found [here](https://packaging.python.org/en/latest/specifications/dependency-groups/)

Another interesting package I'd like to highlight here is `invoke`.
This is a package that is used to run tasks from the `tasks.py` from the shell.
Since `invoke` is a pure Python package, the tasks from the `tasks.py` are cross-platform (as long as no platform-specific Python is used in the tasks) and thus can be ran on Window, Linux and Mac without any additional installs other than the Python version as required by the repo.
This eliminates the need to keep both Bash and PowerShell (or batch) versions of scripts for support tasks in the repo.
A single `tasks.py` in the repo root is sufficient for all tasks that are needed, for all platorms.

An additional nice feature of `invoke` is that you can easily chain tasks together, for example to ensure that when you run the `build` task, first the `format-code` and `lint` tasks are executed.
And that after you run the `bump-version` task, the `build` task runs (which in turn will first run `format-code`).

It's of course also possible to run your Robot Framework tests using a task, or run several suites and then run `rebot` afterwards to merge the logging.

An example of how a `tasks.py` may look can be found in the root of the repo.
If you're working with an IDE that automatically runs your shell command in the virtual environment of the repo, running an `invoke` tasks straightforward:
```shell
(.venv) PS path\to\repo\root>inv tests
```
> Note: If the `pyproject.toml` and `tasks` are both in the repo root and the virtual environment of the repo is not activated, running `uv/poetry run inv <task>` will still execute the task within the virtual environment of the repo.

## The `pyproject.toml` and tool settings
In addition to managing a (Python) project, the `pyproject.toml` file also serves another purpose:
More and more (developer) tools in the Python eco-system now support the `pyproject.toml` file as source for their settings.

This complements the `[dependency-groups]` (that defines which development tools should be used when working on the repo) by also storing the configuration that should be used by those tools.

Among those tools are Python linters and formatters like `black`, `isort`, `mypy` and `pylint`.
When it comes to Robot Framework, we have `tidy` and `robocop` that can read their configuration from the `pyproject.toml`.
How exactly the entries for a certain tool should look, can normally be found in the documentation for the particular tool.
I've added a selection of tool configurations that I commonly use within repos to the `pyproject.toml` in this repo.

## Using `uv`/`poetry` with Docker and / or Jenkins
The great benefit from using `uv`/`poetry` in a repo is that is ensures that "if it works on my machine, it works on your machine".
This benefit can easily be carried over to CI/CD environments.
The only thing that is really needed is that the required Python version for running the repo is present on the target machine / host / Jenkins node (which can be a Docker container).
While it is not advisable to use `pip install uv/poetry` for local development, this is not normally a problem on CI/CD machines since the agents are often already isolated and / or not persistent.

----
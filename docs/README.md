# Robot Framework poetry demo
This repo demonstrates how poetry can be used to distribute Robot Framework resources between repos and also show some tips and tricks that can help you in managing your Robot Framework projects.

## `poetry` and the `pyproject.toml` file
The cornerstone for `poetry` is the `pyproject.toml` file.
This file holds the information needed to ensure a suitable Python version is used when creating the virtual environment for the repo, which dependencies should be installed in that virtual environment, etc.
It also provides the information needed when you want to build and distribute the code in the repo; things like the version number, the author(s) and / or maintainers, a description of the project, etc.
> The install instructions for poetry can be found [here](https://python-poetry.org/docs/master/#installation)

> Tip: when `poetry` has been installed, you can configure it to create the virtual environment for repos in the repo itself (instead of somewhere in the user data).
> This makes it easier to inspect the content of the `.venv` or delete the `.venv` (for example to update the Python version used).
> The command to do this is the following:
> ```
> poetry config virtualenvs.in-project true
> ```

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
The `name`, `description` and `authors` tell us what the package is for and who wrote it.

The `version` is used is used by tools like `pip` (and `poetry`!) when checking for updates of the `dependencies` of a project.
If you use `poetry` to manage the environment and dependencies of your Robot Framework tests, the `version` is not used directly.

The `packages`, like `version`, may not be used but it is required and it's a good idea to think of a proper (folder) structure for your repo even if you don't distribute it.
In this example, the `src` (short for source) folder holds the `RobotFrameworkResources` package to be included in the distribution.
But even if you don't need to distribute your project, it's a good idea to have a folder at the root of the repo that makes it clear where the main content of your repo can be found to separate that from supporting files such as configuration files (e.g. `pyproject.toml` and `poetry.lock`) and documentation (e.g. `README.md`).

> Note that this repo does not use a `src` folder but instead demonstrates three different ways of how you could structure your repo.
> The `flat` structure is the most basic, while `nested` and `split` are increasingly complex.
> Refer to the `pyproject.toml` of the repo to see how to include these different ways of organizing the project into a distribution.

The `include` is not part of a minimum `pyproject.toml` configuration but I've included it here since we'll need to define it if we want to make a Robot Framework Resource distribution.
By default only Python files (e.g. `.py` and related extensions) are included when building a distribution.
To include files with other extensions, such as `.resource` or `.robot`, we need to specify them.

### The `[tool.poetry.dependencies]` section
This section defines two things:
*   The Python version(s) required to use the repo.
*   The packages / libraries and their acceptable version that are needed by the code in the package.

### The `[build-system]` section
The section as shown is automatically generated if you create a new `pyproject.toml` file using `poetry new` or `poetry init`.
Unless you have a reason to change it (and then you'll know why) you can just leave this as is.

## The basic `poetry` commands
There are many `poetry` commands (full documentation can be found [here](https://python-poetry.org/docs/cli/)).
To get started with `poetry`, the most important ones are the following ones:

*   `install <package>`: If you're working in a repo with either a `pyproject.toml` or `poetry.lock` file in it, this will install all the dependencies and the project itself.
*   `add <package>`: To add a package to your project.
    This is the equivalent of `pip install` but with one major difference:
    After you `add` a package, `poetry` will first check that all packages and their dependencies that are in the project are compatible with each other.
    This means that `poetry` will try to find a combination of package versions that satisfies all the version requirements / restrictions of all packages in the project.
    If such a combination is found, `poetry` generate / update the `poetry.lock` file file that "pins" these exact versions.
*   `remove <package>`: Remove a package from your project.
    This is similar to `pip uninstall` but with an important difference: dependencies of the removed package that are no longer referenced will also be removed.
    After this is done, the `poetry.lock` file is updated.
*   `update [<package>]`: Updates a package (if provided) or all packages in the project and their dependencies to the highest versions that satisfies the version requirements of all packages in the project.
    After resolving the dependencies, the `poetry.lock` file is updated.
*   `show`: Similar to `pip list`, `poetry show` will show which packages and their version that are installed in the active (virtual) environment.
    The optional `--tree` flag is interesting here: instead of a flat list of installed packages, the dependencies tree of the installed packages is shown.
    This can give you insight in what packages are used "under the hood" and which packages are used by multiple packages in the project.

## Building and distributing a package
In addition to managing the dependencies of a repo / project, `poetry` also supports building and publishing projects.
When you run the `poetry build` command, `poetry` will create a `wheel` (`.whl`) and a `sdist` (`.tar.gz`) file in the `/dist` folder in the project root.
These files can be used to install the project package in another environment or to distribute the package using a tracker such as pypi.

### Publishing using a tracker
To distribute the package through a tracker, the `poetry publish` command is used.
Using this command will prompt for a (pypi) user name and password.

If the package is an internal package that should not be publicly available, pypi is not the tracker that should be used but an organisation may have its own internal tracker available.
You can configure such an internal (private) tracker in the `pyproject.toml` file:
```toml
[[tool.poetry.source]]
name = 'private'
url = 'http://example.com/simple'
```
To publish to such a tracker, use the `poetry publish -r private` command.

In addition, you can add the following classifier to the `[tool.poetry]` section:
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

## The `[tool.poetry.dev-dependencies]` section and `invoke`
In addition to the `[tool.poetry.dependencies]` section, `poetry` also supports the `[tool.poetry.dev-dependencies]` section that can be used to define which supporting packages can (or should) be used when working on the project.
Packages typically found in this section are tools to increase code quality (e.g. `black`, `mypy`, `tidy`, `robocop`) and to run the tests for the project and measure code coverage (e.g. `pytest`, `coverage`, `robotframework`).

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
> Note: If the `pyproject.toml` and `tasks` are both in the repo root and the virtual environment of the repo is not activated, running `poetry run inv <task>` will still execute the task within the virtual environment of the repo.

## The `pyproject.toml` and tool settings
In addition to managing a (Python) project, the `pyproject.toml` file also serves another purpose:
More and more (developer) tools in the Python eco-system now support the `pyproject.toml` file as source for their settings.

This complements the `[tool.poetry.dev-dependencies]` (that defines which development tools should be used when working on the repo) by also storing the configuration that should be used by those tools.

Among those tools are Python linters and formatters like `black`, `isort`, `mypy` and `pylint`.
When it comes to Robot Framework, we have `tidy` and `robocop` that can read their configuration from the `pyproject.toml`.
How exactly the entries for a certain tool should look, can normally be found in the documentation for the particular tool.
I've added a selection of tool configurations that I commonly use within repos to the `pyproject.toml` in this repo.

## Using `poetry` with Docker and / or Jenkins
The great benefit from using `poetry` in a repo is that is ensures that "if it works on my machine, it works on your machine".
This benefit can easily be carried over to CI/CD environments.
The only thing that is really needed is that the required Python version for running the repo is present on the target machine / host / Jenkins node (which can be a Docker container).
While it is not advisable to use `pip install poetry` for local development, this is not normally a problem on CI/CD machines since the agents are often already isolated and / or not persistent.

Adding `poetry` to a Python-based Docker image is straightforward:
```dockerfile
# Install poetry into the default Python install
RUN find / -name pip
RUN pip install poetry
```

If `poetry` is available on an agent, installing the dependencies and running the Robot Framework suites is also simple:
```bash
# install the dependencies
poetry install --no-dev --remove-untracked

# run the suite(s)
poetry run robot --variable ROOT:${WORKSPACE} ${WORKSPACE}/Suites/
```
> The `--removed-untracked` flag is mostly a precaution.
This will remove all packages from the (virtual) environment that are not in the `poetry.lock` file.

----
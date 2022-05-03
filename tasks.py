# pylint: disable=missing-function-docstring, unused-argument
import pathlib
import subprocess

from invoke import task


ROOT = pathlib.Path(__file__).parent.resolve().as_posix()


@task
def tests(context):
    cmd = [
        "python",
        "run",
        "-m",
        "robot",
        f"--variable=root:{ROOT}",
        f"--outputdir={ROOT}/tests/logs",
        "--loglevel=TRACE:DEBUG",
        f"{ROOT}/tests/suites",
    ]
    subprocess.run(" ".join(cmd), shell=True, check=False)


@task
def lint(context):
    subprocess.run(f"mypy {ROOT}", shell=True, check=False)
    subprocess.run(f"pylint {ROOT}/src/OpenApiDriver", shell=True, check=False)
    subprocess.run(f"robocop {ROOT}", shell=True, check=False)


@task
def format_code(context):
    subprocess.run(f"black {ROOT}", shell=True, check=False)
    subprocess.run(f"isort {ROOT}", shell=True, check=False)
    subprocess.run(f"robotidy {ROOT}", shell=True, check=False)


@task(format_code)
def build(context):
    subprocess.run("poetry build", shell=True, check=False)


@task(post=[build])
def bump_version(context, rule):
    subprocess.run(f"poetry version {rule}", shell=True, check=False)
    subprocess.run("poetry install", shell=True, check=False)

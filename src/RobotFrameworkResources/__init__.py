from importlib.metadata import version

try:
    __version__ = version("robotframework-poetry-demo")
except Exception:  # pragma: no cover
    pass

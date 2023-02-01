import click


@click.group()
def cli() -> None:
    """A toolchain to securely store and access sensitive files."""
    pass


@cli.command()
def create():
    """Create a new tomb to store files in."""
    pass


@cli.command()
def open():  # noqa
    """Open a tomb in an process-isolated shell."""
    pass


@cli.command()
def mount():
    """Mount a tomb in a non-isolated directory for use in other programs."""
    pass


if __name__ == "__main__":
    cli()

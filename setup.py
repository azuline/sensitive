import setuptools

setuptools.setup(
    name="sensitive",
    version="0.1.0",
    description="A toolchain to securely store and access sensitive files.",
    python_requires="==3.*,>=3.10.0",
    author="blissful",
    author_email="blissful@sunsetglow.net",
    license="GPL-3.0",
    entry_points={"console_scripts": ["sensitive = sensitive.__main__:cli"]},
    packages=["sensitive"],
    install_requires=["click"],
)

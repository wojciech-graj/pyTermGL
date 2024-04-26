from setuptools import Extension, setup, find_packages
from Cython.Build import cythonize
import numpy


define_macros = [
    ("NPY_NO_DEPRECATED_API", "NPY_1_7_API_VERSION"),
    ("TERMGL3D", None),
    ("TERMGLUTIL", None),
]


with open("README.md") as f:
    raw_long_description = f.read()
    long_description = raw_long_description.partition("## Gallery")[0]


setup(
    name="termgl",
    description="TermGL wrapper in Cython",
    long_description=long_description,
    long_description_content_type="text/markdown",
    version="0.1.1",
    author="Wojciech Graj",
    url="https://github.com/wojciech-graj/pyTermGL",
    license="MIT",
    ext_modules=cythonize(
        [
            Extension(
                "termgl",
                sources=["termgl.pyx", "TermGL/src/termgl.c"],
                include_dirs=[
                    "TermGL/lib",
                    numpy.get_include()
                ],
                define_macros=define_macros,
            )
        ],
        language_level=3
    ),
    packages=find_packages("termgl"),
    classifiers=[
        "Development Status :: 4 - Beta",
        "Intended Audience :: Developers",
        "Environment :: Console",
        "Topic :: Multimedia :: Graphics",
        "Topic :: Multimedia :: Graphics :: 3D Rendering",
        "Topic :: Terminals",
        "License :: OSI Approved :: MIT License",
        "Programming Language :: Python :: 3.7",
        "Programming Language :: Python :: 3.8",
        "Programming Language :: Python :: 3.9",
        "Programming Language :: Python :: 3.10",
        "Programming Language :: Python :: 3.11",
        "Programming Language :: Python :: 3.12",
        "Programming Language :: C",
        "Programming Language :: Cython",
    ],
    keywords="graphics terminal render rendering text ascii",
    install_requires=['numpy>=1.20'],
)

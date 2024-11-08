"""
Copyright (c) 2022-2024 Wojciech Graj

Licensed under the MIT license: https://opensource.org/licenses/MIT
Permission is granted to use, copy, modify, and redistribute the work.
Full license information available in the project LICENSE file.
"""

import sys

import numpy
from Cython.Build import cythonize
from setuptools import Extension, find_packages, setup

define_macros = [
    ("TERMGL3D", None),
]

if sys.platform in ("win32", "linux"):
    define_macros.append(("TERMGLUTIL", None))

setup(
    ext_modules=cythonize([
        Extension(
            "termgl",
            sources=["termgl.pyx", "TermGL/src/termgl.c"],
            include_dirs=["./TermGL/lib", numpy.get_include()],
            define_macros=define_macros,
        )
    ],
                          language_level=3),
    packages=find_packages("termgl"),
)

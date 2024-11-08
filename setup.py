"""
Copyright (c) 2022-2024 Wojciech Graj

Licensed under the MIT license: https://opensource.org/licenses/MIT
Permission is granted to use, copy, modify, and redistribute the work.
Full license information available in the project LICENSE file.
"""

from setuptools import Extension, setup, find_packages
from Cython.Build import cythonize
import numpy


define_macros = [
    ("TERMGL3D", None),
    ("TERMGLUTIL", None),
]

setup(
    ext_modules=cythonize(
        [
            Extension(
                "termgl",
                sources=["termgl.pyx", "TermGL/src/termgl.c"],
                include_dirs=[
                    "./TermGL/lib",
                    numpy.get_include()
                ],
                define_macros=define_macros,
            )
        ],
        language_level=3
    ),
    packages=find_packages("termgl"),
)

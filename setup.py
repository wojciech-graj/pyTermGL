"""
Copyright (c) 2022-2024 Wojciech Graj

Licensed under the MIT license: https://opensource.org/licenses/MIT
Permission is granted to use, copy, modify, and redistribute the work.
Full license information available in the project LICENSE file.
"""

import sys

import numpy
from Cython.Build import cythonize
from setuptools import Extension, setup

define_macros = [
    ("TERMGL3D", None),
]

if sys.platform in ("win32", "linux"):
    define_macros.append(("TERMGLUTIL", None))

setup(
    ext_modules=cythonize([
        Extension(
            "termgl",
            sources=["./termgl/termgl.pyx", "./vendor/src/termgl.c"],
            include_dirs=["./vendor/lib", numpy.get_include()],
            define_macros=define_macros,
        )
    ],
                          build_dir="build",
                          language_level=3),
    package_data={"termgl": ["py.typed", "__init__.pyi"]},
    packages=["termgl"],
)

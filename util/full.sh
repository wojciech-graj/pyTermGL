#!/bin/bash
export PYTHONPATH=.
python setup.py build_ext --inplace
pytest
flake8 .
make html
mv -r docs/html/* docs/
rm -rf docs/html

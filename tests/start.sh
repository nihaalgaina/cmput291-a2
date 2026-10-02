#!/bin/bash

# A script to run all tests.
# Author: Brian Lin
# Date: 2025-09-23
# Updated: 2026-09-20

RED='\033[0;31m';
GREEN='\033[0;32m';
NC='\033[0m'; # No Color

DIVIDER_BOLD="===========================";
DIVIDER="---------------------------";

echo $DIVIDER_BOLD;
echo "Setting up environment...";
echo $DIVIDER_BOLD;
python3.13 -m venv query-runner-venv || exit 1;
source query-runner-venv/bin/activate || exit 1;
python --version;
python -m pip install --upgrade pip || exit 1;
python -m pip install sqlparse==0.6.0 || exit 1;
python -m pip install SQLAlchemy==2.0.54 || exit 1;

echo $DIVIDER_BOLD;
echo "Running tests...";
echo $DIVIDER_BOLD;

QUESTIONS="| 01 | 02 | 03 | 04 | 05 | 06 | 07 | 08 | 09 | 10 |";
queries="";

for q_num in $(seq 1 10); do
    echo $DIVIDER;
    echo "Running tests for q${q_num}...";
    python3 tests/query_tester.py ${q_num};
    if [ $? -eq 0 ]; then
        echo -e "${GREEN} ✔ Success!${NC}";
        queries=("${queries}|  ${GREEN}✔${NC} ");
    else
        echo -e "${RED} ✘ failed!${NC}";
        queries=("${queries}|  ${RED}✘${NC} ");
    fi
done
queries=("${queries}|");

echo $DIVIDER_BOLD;
echo "Cleaning up...";
echo $DIVIDER_BOLD;
deactivate
rm -rf tests/temp_dbs

echo $DIVIDER_BOLD$DIVIDER_BOLD;
echo "Public Tests Summary:";
echo "${QUESTIONS}";
echo -e "${queries}";
echo $DIVIDER_BOLD$DIVIDER_BOLD;

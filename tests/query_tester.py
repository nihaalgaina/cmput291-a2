"""
Author by: Brian Lin
Date: 2026-09-20
"""

import evaluation
import argparse
from pathlib import Path
from os.path import isfile, join
import re
import sqlparse
import sqlite3
from shutil import copytree, rmtree

BASE_PATH = str(Path(__file__).absolute().parent.parent.absolute())
ORIGINAL_DBS_PATH = join(BASE_PATH, "tests/dbs/")
DBS_PATH = join(BASE_PATH, "tests/temp_dbs/")
GT_BASE_PATH = join(BASE_PATH, "tests/ground_truth/")
PRE_RUNNER_BASE_PATH = join(BASE_PATH, "tests/prerunner/")

CREATE_VIEW_CHECK = [9]
NEST_NOT_ALLOWED = [1, 2, 3]
NEST_KEYWORDS = [r"GROUP\s{1,}BY", r"HAVING", r"IN", r"EXISTS", r"WITH"]
NEST_FUNCTIONS = [r'COUNT', r'SUM', r'AVG', r'MIN', r'MAX']
NEED_PRE_RUNNER = [10]
ORDER_MATTERS_QUESTIONS = [4, 8]
MAX_MULTIPLE_ANSWERS = 1
QUESTION_INDEPENDENT_PREFIX = "indiv"


def db_initialization():
    '''
    Initialize test databases by copying from tests/dbs to tests/run_dbs
    '''
    if Path(DBS_PATH).exists():
        rmtree(DBS_PATH)
    if Path(DBS_PATH).exists():
        raise Exception(f"  Failed to remove existing {DBS_PATH}")
    copytree(ORIGINAL_DBS_PATH, DBS_PATH)

def create_view_create_table_check(raw_query_string: str) -> int:
    '''
    Check if the query string contains any create view or create table statements.
    Return 0 if create view found, no create table
    Return 1 if create table found
    Return 2 if neither found
    Return 3 if both found
    '''
    queries = sqlparse.format(raw_query_string, strip_comments=True).strip()
    queries = queries.upper()
    queries = sqlparse.split(queries)

    view_found = False
    table_found = False
    for query in queries:
        has_create_view = re.search(r'\bCREATE\s+VIEW\b', query, re.IGNORECASE)
        has_create_table = re.search(r'\bCREATE\s+TABLE\b', query, re.IGNORECASE)
        if has_create_view:
            view_found = True
        if has_create_table:
            table_found = True
    if view_found and table_found:
        return 3
    elif view_found:
        return 0
    elif table_found:
        return 1
    return 2

def insert_check(raw_query_string: str) -> bool:
    '''
    Check if the query string contains any insert statements.
    Return True if it does, False otherwise
    '''
    queries = sqlparse.format(raw_query_string, strip_comments=True).strip()
    queries = queries.upper()
    queries = sqlparse.split(queries)
    for query in queries:
        if re.search(r'\bINSERT\b', query, re.IGNORECASE):
            return True
    return False

# Author: Brian Lin
# Date: 2025-09-21
# Updated: 2025-10-03
#   - Added to clean query before regex check
#   - Added check for if there are multiple queries
def check_nest(raw_query_string: str) -> bool:
    '''
    Check if the query string contains any nesting, aggregation, grouping, or multiple queries.
    Return True if it does, False otherwise
    '''
    queries = sqlparse.format(raw_query_string, strip_comments=True).strip()
    queries = queries.upper()
    queries = sqlparse.split(queries)
    # Multiple queries check
    if len(queries) > 1:
        return True
    for query in queries:
        for kw in NEST_KEYWORDS:
            if re.search(r'\b' + kw + r'\b', query, re.IGNORECASE):
                return True
        for func in NEST_FUNCTIONS:
            if re.search(r'\b' + func + r'\s*\(', query, re.IGNORECASE):
                return True
        # Check for subqueries using parentheses
        if re.search(r'\(\s*SELECT\b', query, re.IGNORECASE):
            return True
    return False

def main():
    parser = argparse.ArgumentParser(description='')
    parser.add_argument('pos_arg', type=int, help='Query number')
    parser.add_argument('--db_name', type=str, default=None, help='Specific database to test (without .db extension)')
    args = parser.parse_args()
    q_num = args.pos_arg
    q_path = join(BASE_PATH, f"q{q_num:02}.sql")
    gt_path = join(GT_BASE_PATH, f"q{q_num:02}/")

    # Check for answer file existence
    if not isfile(q_path):
        print(f"  Test failed: q{q_num:02}.sql does not exist")
        exit(1)
    
    query = ""
    with open(q_path, 'r') as f:
        query = f.read()

    if len(sqlparse.format(query, strip_comments=True).strip()) == 0:
        print(f"  Test failed: Query file is empty")
        exit(1)

    if q_num in NEST_NOT_ALLOWED and check_nest(query):
        print(f"  Test failed: Aggregation, grouping, or nesting is not allowed in Q{q_num:02}")
        exit(1)

    create_view = create_view_create_table_check(query)
    
    if q_num in CREATE_VIEW_CHECK and create_view != 0:
        if create_view == 1 or create_view == 3:
            print(f"  Test failed: CREATE TABLE statement is not allowed in Q{q_num:02}")
        elif create_view == 2:
            print(f"  Test failed: CREATE VIEW statement is required in Q{q_num:02}")
        exit(1)

    if insert_check(query):
        print(f"  Test failed: INSERT statements are not allowed in Q{q_num:02}")
        exit(1)

    final_res = True
    final_res_with_indexes = dict()
    db_initialization()
        
    # For each database file
    for db_path in sorted(Path(ORIGINAL_DBS_PATH).glob('*.db')):
        if args.db_name and db_path.stem != args.db_name:
            continue
        file_name = db_path.stem

        # Check for individual dbs
        if file_name.startswith(QUESTION_INDEPENDENT_PREFIX) and not file_name.startswith(f"{QUESTION_INDEPENDENT_PREFIX}-{q_num:02}"):
            continue

        db_file_path = str(DBS_PATH + f"/{file_name}.db")
        
        # Updated: 2026-01-29
        # Updated by: Brian Lin
        # Check for multiple possible answer queries with the same database
        res = True
        for answer_idx in range(MAX_MULTIPLE_ANSWERS):
            jsonl_path = gt_path + f"{file_name}_v_{answer_idx}.jsonl"
            if not isfile(jsonl_path):
                continue

            db_initialization()
            # Run pre-runner if needed
            if q_num in NEED_PRE_RUNNER and isfile(PRE_RUNNER_BASE_PATH + f"/q{q_num:02}/{file_name}.sql"):
                conn = sqlite3.connect(db_file_path)
                cursor = conn.cursor()
                with open(PRE_RUNNER_BASE_PATH + f"/q{q_num:02}/{file_name}.sql", 'r') as f:
                    cursor.executescript(f.read())
                cursor.close()
                conn.commit()
                conn.close()

            res = evaluation.evaluate(db_file_path, query, jsonl_path, order_matters=(q_num in ORDER_MATTERS_QUESTIONS))
            final_res_with_indexes[answer_idx] = final_res_with_indexes.get(answer_idx, True) and res
            if res:
                print (f"  Test on db {file_name} version {answer_idx} Passed...")
            else:
                print (f"  Test on db {file_name} version {answer_idx} Failed...")
        
        final_res = final_res and res
            
    if True in final_res_with_indexes.values():
        if len(final_res_with_indexes) > 1:
            for idx, res in final_res_with_indexes.items():
                if res:
                    print(f"All query tests on version {idx} passed")
        else:
            print("All query tests passed")
        exit(0)
    else:
        print("Query tests Failed")
        exit(1)

if __name__ == "__main__":
    main()

"""
Extracts teahouse link addition events from XML database dump files.

Usage:
    extract_teahouse_link_additions <dump-file>...

Options:
    <dump-file>   Path to an XML dump file to process.
"""
import sys
from collections import defaultdict

import docopt
import mwxml
import mysqltsv

from .extractors import teahouse_links

HEADERS = [
    'page_id',
    'page_namespace',
    'page_title',
    'rev_id',
    'rev_timestamp',
    'rev_comment',
    'link',
    'diff'
]


def main():
    args = docopt.docopt(__doc__)

    dump_files = args['<dump-file>']

    run(dump_files)


def run(dump_files):

    def process_dump(dump, path):
        for page in dump:
            if page.namespace != 3:
                continue

            last_links = defaultdict(lambda: 0)
            for revision in page:
                if revision.text is None:
                    continue

                current_links = defaultdict(lambda: 0)
                for link in teahouse_links.extract(revision.text):
                    current_links[link] += 1

                for link, count in current_links.items():
                    diff = current_links[link] - last_links[link]
                    if diff > 0:
                        yield (page.id, page.namespace, page.title,
                               revision.id, revision.timestamp,
                               revision.comment, link, diff)

                last_links = current_links

    writer = mysqltsv.Writer(sys.stdout, headers=HEADERS)

    for values in mwxml.map(process_dump, dump_files):
        sys.stderr.write(".")
        writer.write(values)

    sys.stderr.write("\n")

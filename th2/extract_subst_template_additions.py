"""
Extracts subst template comment addition events from XML database dump files.

Usage:
    extract_subst_template_additions <dump-file>...

Options:
    <dump-file>   Path to an XML dump file to process.
"""
import sys
from collections import defaultdict

import docopt
import mwxml
import mysqltsv

from .extractors import subst_templates

HEADERS = [
    'page_id',
    'page_namespace',
    'page_title',
    'rev_id',
    'rev_timestamp',
    'rev_comment',
    'template',
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

            last_templates = defaultdict(lambda: 0)
            for revision in page:
                if revision.text is None:
                    continue

                current_templates = defaultdict(lambda: 0)
                for template in subst_templates.extract(revision.text):
                    current_templates[template] += 1

                for template, count in current_templates.items():
                    diff = current_templates[template] - \
                           last_templates[template]
                    if diff > 0:
                        yield (page.id, page.namespace, page.title,
                               revision.id, revision.timestamp,
                               revision.comment, template, diff)

                current_templates = last_templates

    writer = mysqltsv.Writer(sys.stdout, headers=HEADERS)

    for values in mwxml.map(process_dump, dump_files):
        sys.stderr.write(".")
        writer.write(values)

    sys.stderr.write("\n")

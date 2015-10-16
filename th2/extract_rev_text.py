"""
Extracts the text of revisions.  Expects user_id, rev_id pairs in a TSV format.
Writes user_id, text pairs in TSV format.

Usage:
    extract_rev_text --api-host=<url>

Options:
    --api-host=<url>   The URL of an MW API host to use
"""
import getpass
import sys
from itertools import islice

import docopt
import mwapi
import mwapi.errors
import mysqltsv

HEADERS = ['user_id', 'talk_text']


def main():
    args = docopt.docopt(__doc__)
    host = args['--api-host']

    my_agent = 'Teahouse experiment text extractor <ahalfaker@wikimedia.org>'
    session = mwapi.Session(host, user_agent=my_agent)

    rows = mysqltsv.Reader(sys.stdin, types=[int, int])

    run(session, rows)


def run(session, rows):
    sys.stderr.write("Log into " + session.host + "\n")
    sys.stderr.write("Username: ")
    sys.stderr.flush()
    username = open('/dev/tty').readline().strip()
    password = getpass.getpass("Password: ")
    session.login(username, password)

    sys.stderr.write("whoami?\n")
    sys.stderr.write(str(session.get(action='query', meta='userinfo')) + "\n")

    user_map = {r.rev_id: r.user_id for r in rows}

    writer = mysqltsv.Writer(sys.stdout, headers=HEADERS)

    for rev_id, text in get_text_for_ids(session, user_map.keys()):
        sys.stderr.write(".")
        sys.stderr.flush()
        user_id = user_map[rev_id]
        writer.write([user_id, text])

    sys.stderr.write("\n")


def get_text_for_ids(session, revids, batch=50):

    revids = list(revids)
    missing_ids = set(revids)

    rev_docs = query_revisions_by_revids(session, revids, prop="revisions",
                                         rvprop=['ids', 'content'])

    for rev_doc in rev_docs:
        missing_ids.remove(rev_doc['revid'])

        yield rev_doc['revid'], rev_doc.get('*')

    drev_docs = query_revisions_by_revids(session, missing_ids,
                                          prop="deletedrevisions",
                                          rvprop=['ids', 'content'])

    for rev_doc in drev_docs:
        yield rev_doc['revid'], rev_doc.get('*')


def query_revisions_by_revids(session, revids, batch=50, prop="revisions",
                              **params):

    revids_iter = iter(revids)
    while True:
        batch_ids = list(islice(revids_iter, 0, batch))
        if len(batch_ids) == 0:
            break
        else:
            doc = session.post(action='query', prop=prop,
                               revids=batch_ids, **params)

            for page_doc in doc['query'].get('pages', {}).values():
                page_meta = {k: v for k, v in page_doc.items()
                             if k != 'revisions'}
                if 'revisions' in page_doc:
                    for revision_doc in page_doc['revisions']:
                        revision_doc['page'] = page_meta
                        yield revision_doc


if __name__ == "__main__":
    main()

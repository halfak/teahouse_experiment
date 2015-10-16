"""
Labels the template types that appear in the talk page text.

Usage:
    label_templates -h | --help
    label_templates
"""
import logging
import re
import sys

import docopt
import mysqltsv

logger = logging.getLogger(__name__)

TEMPLATE_RE = [(type, re.compile(r'Template:({0})'.format(exp)))
               for type, exp in
               [('vandal_warning', r'uw-vandalism([1-4])?(im)?'),
                ('spam_warning', r'uw-spam([1-4])?(im)?'),
                ('copyright_warning', r'uw-copyright(-([a-z]+))?([1-4])?'),
                ('general_warning', r'uw-.+?([1-4])?(im)?'),
                ('block', r'.*?block.*?|uw-[a-z]*block[a-z]*'),
                ('welcome', r'w-[a-z]+|welcome|First article'),
                ('csd', r'.*?csd|db-|speedy.*?'),
                ('deletion', r'proposed del.*?|prod|afd|.*?delet.*?'),
                ('afc', r'afc.*?'),
                ('teahouse', r'teahouse.*?')]]

HEADERS = ['user_id'] + list(t for t, _ in TEMPLATE_RE)


def main():
    args = docopt.docopt(__doc__)
    user_texts = mysqltsv.Reader(sys.stdin, types=[int, str])

    run(user_texts)


def run(user_texts):

    writer = mysqltsv.Writer(sys.stdout, headers=HEADERS)

    for user_id, text in user_texts:
        if text is None:
            continue
        flags = flag_templates(text)

        writer.write([user_id] + [flags[t] for t, _ in TEMPLATE_RE])


def flag_templates(text):
    template_flags = {type: False for type, _ in TEMPLATE_RE}
    for type, exp in TEMPLATE_RE:
        match = exp.search(text)
        if match is not None:
            start = max(match.span()[0]-20, 0)
            end = min(match.span()[1]+20, len(text))
            logger.debug("Matched {0}: ...{1}..."
                         .format(type, text[start:end]))
            template_flags[type] = True

    return template_flags


if __name__ == "__main__":
    main()

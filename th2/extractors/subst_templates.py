import re

SUBST_TEMPLATE_RE = re.compile(
    r'<!--\s*' +
    r'(' +
        r'((Template|Wikipedia|WP):)' +
        r'([\w\-\d\ ]{1,50})' +
    r')' +
    r'\s*-->', re.I)


def extract(text):
    return (m.group(1).lower().strip()
            for m in SUBST_TEMPLATE_RE.finditer(text.replace("_", " ")))

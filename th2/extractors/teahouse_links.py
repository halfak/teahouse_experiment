import re

# from http://quarry.wmflabs.org/query/6149
TEAHOUSE_SYNONYMS = [
    "[Tt]eahouse",
    "[Tt]EAHOUSE",
    "[Tt]ea Room",
    "[Ii]MNEW",
    "[wW]ikipedia Teahouse",
    "[Tt]ea House",
    "[Tt]EAROOM",
    "[Tt]ea house",
    "[Tt]he Teahouse",
    "[Tt]he Tea House",
    "[Tt]earoom",
    "[Tt]HH",
    "[lL]OUNGE",
    "[Tt]HQ",
    "[Tt]H",
    "[Tt]eahouse questions",
    "[Tt]ea\?",
    "[Tt]EA",
    "[Tt]/Q"
]

TEAHOUSE_LINK_RE = re.compile(
    r'(\[\[|link=)\s*' +  # Start link -- also matches links form images
    r'((w?:)?en:)?' +  # Cross wiki prefix
    r'(' +  # Link title
        r'(Wikipedia|WP):' +  # Wikipedia namespace
        r'(' + '|'.join(TEAHOUSE_SYNONYMS) + r')' +  # Some teahouse page name
        r'(/[^\]|\n]+)?' +  # Something appended with a "/"
    r')'
)


def extract(text):
    return (m.group(4).lower().strip()
            for m in TEAHOUSE_LINK_RE.finditer(text.replace("_", " ")))

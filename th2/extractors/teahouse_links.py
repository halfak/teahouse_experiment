import re

# from http://quarry.wmflabs.org/query/6149
TEAHOUSE_SYNONYMS = [
    r"[Tt]eahouse",
    r"[Tt]EAHOUSE",
    r"[Tt]ea Room",
    r"[Ii]MNEW",
    r"[wW]ikipedia Teahouse",
    r"[Tt]ea House",
    r"[Tt]EAROOM",
    r"[Tt]ea house",
    r"[Tt]he Teahouse",
    r"[Tt]he Tea House",
    r"[Tt]earoom",
    r"[Tt]HH",
    r"[lL]OUNGE",
    r"[Tt]HQ",
    r"[Tt]H",
    r"[Tt]eahouse questions",
    r"[Tt]ea\?",
    r"[Tt]EA",
    r"[Tt]/Q"
]

TEAHOUSE_LINK_RE = re.compile(
    r'(\[\[|link=)\s*' +  # Start link -- also matches links form images
    r'((w?:)?en:)?' +  # Cross wiki prefix
    r'(' +  # Link title
        r'(Wikipedia|WP):' +  # Wikipedia namespace
        r'(' + '|'.join(TEAHOUSE_SYNONYMS) + r')' +  # Some teahouse page name
        r'(/[^\]\|\n#]+)?' +  # Something appended with a "/"
        r'(\||\]\])' +  # Closing the link or 
    r')'
)


def extract(text):
    return (m.group(4).lower().strip()
            for m in TEAHOUSE_LINK_RE.finditer(text.replace("_", " ")))

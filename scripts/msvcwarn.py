import re
from collections import Counter

_warning_matcher = re.compile('^.*: warning C([0-9]{4}): (.*)$')

def warning_parser(stream):
    for line in stream:
        matcher = _warning_matcher.search(line)
        if matcher:
            group = matcher.groups()
            yield group[0], group[1]

def summarize_warnings(stream):
    counts = Counter()
    examples = {}
    for warning, example in warning_parser(stream):
        counts.update([warning])
        examples[warning] = example
    return sorted((warning, count, examples[warning]) for warning, count in counts.items())

if __name__ == '__main__':
    import sys
    summary = summarize_warnings(sys.stdin)
    print('\n'.join('%s: count=%d, example=\"%s\"' % warning_details for warning_details in summary))

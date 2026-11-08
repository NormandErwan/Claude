def parse(line):
    """Parse 'key=value' into a (key, value) tuple, stripping spaces."""
    key, value = line.split("=")
    return key, value


def format_pair(key, value):
    return f"{key}={value}"

class _NumberTokens(object):
    def __init__(self, tokens):
        self.tokens = tokens

    @property
    def type(self):
        return self.tokens[0]

    @property
    def nums(self):
        for token in self.tokens:
            if isinstance(token, list):
                return token

    @property
    def unsigned(self):
        return 'unsigned'.upper() in self.tokens


def _split_token_of_date_type_string(string):
    result = []
    tmp = ''
    i = 0
    while i < len(string):
        c = string[i]
        if c in [' ', ',', ')']:
            if tmp:
                result.append(tmp)
                tmp = ''
        elif c == '(':
            if tmp:
                result.append(tmp)
                tmp = ''
            subset = ''
            _i = None
            for _i, s in enumerate(string[i + 1:]):
                subset += s
                if s == ')':
                    break
            result.append(_split_token_of_date_type_string(subset))
            i += _i + 1
        else:
            tmp += c
        i += 1
    if tmp:
        result.append(tmp)

    return [item.upper() if isinstance(item, str) else item for item in result]


def split_token_of_date_type_string(string):
    return _NumberTokens(_split_token_of_date_type_string(string))

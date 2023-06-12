class IterWrapper(object):
    def __init__(self, obj):
        self._obj = obj
        self._i = None
        self._max_i = None

    def __iter__(self):
        self._i = -1
        self._max_i = len(self._obj)
        return self

    def __next__(self):
        self._i += 1
        if self._i >= self._max_i:
            raise StopIteration

        return self._obj[self._i]


def clean_name(name):
    if len(name) < 1:
        return name
    if name[0] in ['`', '"', "'"]:
        return name[1: -1]
    return name

from typing import Union, List


class Format(object):
    def __init__(self, data: Union[str, List[str], "Format"]):
        self.data = None
        if isinstance(data, str):
            data = [data]
        if isinstance(data, Format):
            data = data.data
        self.data = data

    def print(self, split='\n\n\n'):
        print(split.join(self.data))

    def save(self, path, split='\n\n\n'):
        with open(path, 'w', encoding='utf8') as f:
            f.write(split.join(self.data))

    def __repr__(self):
        return self.data

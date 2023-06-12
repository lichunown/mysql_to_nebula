import time
import warnings
from typing import Union, List


class Codes(str):

    def print(self):
        print(self)

    def save_to(self, path):
        with open(path, 'w', encoding='utf8') as f:
            f.write(self)

    def add_to(self, path, split='\n\n\n'):
        with open(path, 'a', encoding='utf8') as f:
            f.write(split)
            f.write(self)
    
    def __add__(self, *args, **kwargs):
        return Codes(super().__add__(*args, **kwargs))

    def __repr__(self):
        if len(self) > 80:
            return f'<Codes>: {self[:80]} ...'
        return f'<Codes>: {self}'

    def execute_on(self, cursor):
        return cursor.execute(self)

    def execute_on_nebula(self, cursor, delay=0.5):
        if '\\' in self:
            warnings.warn('`\\` in the code. may be not executed without error message.')
        res = ''
        if delay > 0:
            for item in self.split(';'):
                res = cursor.execute(item + ';')
                time.sleep(delay)
        else:
            res = cursor.execute(self)
        return res

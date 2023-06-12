class AutoChangeTypeMixin(object):

    def __post_init__(self):
        for k, v in self.__dict__.items():
            if k in self.__annotations__:
                if v is not None:
                    func = self._get_default_type_class(k)
                    if func is not None:
                        v = func(v)
                        setattr(self, k, v)

    def _get_default_type_class(self, name):
        anno = self.__annotations__[name]

        # int, float, or str
        if isinstance(anno, type):
            if anno in [int, str, float]:
                return anno

        # for Optional or Union
        if anno.__args__[0] in [int, str, float]:
            return anno.__args__[0]

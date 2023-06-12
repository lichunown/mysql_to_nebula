class FindFieldMixin:
    @staticmethod
    def find_fields(name, fields):
        for field in fields:
            if name == field.name:
                return field

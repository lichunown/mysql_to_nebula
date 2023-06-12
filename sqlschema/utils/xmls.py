def py_to_xml_type(objects):
    if objects is None:
        return ''
    if isinstance(objects, (list, tuple)):
        return '|'.join([py_to_xml_type(item) for item in objects])
    if isinstance(objects, bool):
        if objects:
            return 'true'
        else:
            return 'false'
    return objects


def xml_to_py_type(objects: str):
    if '|' in objects:
        return [xml_to_py_type(objects) for item in objects.split('|')]
    if objects == '':
        return None
    if objects == 'true':
        return True
    if objects == 'false':
        return False
    return objects

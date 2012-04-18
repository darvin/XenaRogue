from items_patched import ItemStock, Item
from monsters_patched import MonsterStock, Monster
import plistlib
monsters = MonsterStock()
items = ItemStock()


def remove_nones(collection):
    if collection.__class__ is dict:
        return dict((k, remove_nones(v)) for k, v in collection.iteritems() if v is not None)
    elif collection.__class__ in (tuple, list):
        return [remove_nones(i) for i in collection if i is not None]
    else:
        return collection

def dump_plist(filename, item_class):
    result = dict(((item.underdict()["name"], remove_nones(item.underdict())) for item in item_class.all_items()))
    plistlib.writePlist(result, filename)
    
dump_plist("../monsters.plist", Monster)
dump_plist("../items.plist", Item)
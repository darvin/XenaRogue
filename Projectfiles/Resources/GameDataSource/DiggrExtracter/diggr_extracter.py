

class DiggrExtracterItem(object):
    def __init__(self):
        if not hasattr(self.__class__, "items"):
            self.__class__.items = []
        
        self.__class__.items.append(self)
        
    def __setattr__(self, key, value):
        if not hasattr(self, "_underdict"):
            super(DiggrExtracterItem, self).__setattr__("_underdict", {})
        self._underdict[key] = value
        
    def underdict(self):
        return self._underdict
        
    @classmethod
    def all_items(cls):
        return cls.items
        
    
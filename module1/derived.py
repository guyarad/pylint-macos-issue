from module1 import Base


class Derived(Base):
    def __init__(self):
        super().__init__()
        print("hello from derived")

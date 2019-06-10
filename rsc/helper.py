import numpy as np
import matplotlib.pyplot as plt

def get_color(index):
    color_list = ['#5374a2', '#a0a0a0']
    return color_list[index % len(color_list)]

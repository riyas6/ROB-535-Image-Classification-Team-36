README

This repository is specifically created for Umich instructors for ROB 535 class. Please follow the following steps to successfully run this project. 
Download the zip. The mainFile is in .ipynb format and hence can be run on Jupyter Notebook. The MATLAB code creating_bbox.m is given to convert the 
11-element bbox.bin file to a 5-element bbox2D.bin file containing 2-D coordinates of the bounding boxes for training data. The MATLAB file should be kept 
in the same folder as the training data. The name of the folder inside the code can be changed based on your specific naming scheme.

Step 1: Ensure you have the following modules downloaded:

import os
import sys
import csv
import time
import torch
import numpy as np
import cv2
import matplotlib.pyplot as plt
from torchvision import datasets, transforms
from PIL import Image
import glob
%matplotlib inline
import torchvision

Step 2: Download the training and test files from the google drive.
Step 3: Open mainFile.ipynb. Change the directory of the training and the test data under the sections marked Train Val image filtering list and 
Test image filtering list for your computer specific locations. Run the code. 

Step 3: To check your results, you can open the outputs_final.csv after the code is fully run. This will be saved in the same folder as your main file. 

Optional: If you train the model for more or less than 40 epochs, to use the last saved model, change the name of the file in the last cell of the code as 
this_model_epochxx.pth where xx is the number of epochs.
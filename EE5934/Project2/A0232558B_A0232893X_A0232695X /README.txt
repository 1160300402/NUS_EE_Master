If you have any question, please always email us. (E0724692@u.nus.edu)

1.Part 1 & Part 4
Important libraries:
  -Python: 3.7.10
  -TensorFlow: 2.4.1

2. Part 2 & Part 5
# When running code, please set the "part2&5" as root directory. The code all in the "Code" directory.
Important libraries:
  -Python:  3.7.11
  -Pytorch: 1.11.0
  -torchvision: 0.12.0
  -scikit-image:  0.19.2
Usage: 
  -You can run the main function in 'Saliency_map' to get the result of part2&part5
  -You can run the main function in 'Get_similarity' to get the difference between two images.


3. Part 3
Dependencies:
You need to install opencv [pip install opencv-python]

Path:
picture_part2
   |____  xxx.jpg   Image to be applied graphcut
graphcut.ipynb

Usage:
Change the path inside cv.imread() according to your own folder name.
Press 'ESC' to close the pop-up window
1. Bounding the foreground by mouse click
	After a window poped up, click and ONLY click the top left and down right points of the object to give a rough bounding box
	Press 'ESC' to close the window
2. After the mask showing up, press 'ESC' to close the window.

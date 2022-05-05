from skimage.metrics import structural_similarity as ssim
from skimage.metrics import mean_squared_error as mse
from PIL import Image
import numpy as np

def get_ssim(X, Y):
    X = np.array(X)
    Y = np.array(Y)
    (score, diff) = ssim(X, Y, full=True)
    diff = (diff * 255).astype("float32")
    return score, diff

def get_mse(X, Y):
    X = np.array(X)
    Y = np.array(Y)
    score = mse(X, Y)
    return score


if __name__ == '__main__':
    file1 = "../results/5834_improvedSal.jpg"
    file2 = "../results/5834or_improvedSal.jpg"
    img1 = Image.open(file1).convert('L')
    img2 = Image.open(file2).convert('L')
    score1 = get_mse(img1, img2)
    score2, diff = get_ssim(img1, img2)
    print("MSE:",score1)
    print("SSIM:",score2)
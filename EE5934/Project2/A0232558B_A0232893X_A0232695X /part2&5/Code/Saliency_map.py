import torch
import torchvision
import torchvision.transforms as transforms
import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
import os

#load pretrained resnet50 model
model = torchvision.models.resnet50(pretrained=True)

#Normalrize function for input images
normalize = transforms.Normalize(mean=[0.485, 0.456, 0.406],
                                     std=[0.229, 0.224, 0.225])
#inverse Normalrize to get image back to original image
inv_normalize = transforms.Normalize(
    mean=[-0.485/0.229, -0.456/0.224, -0.406/0.255],
    std=[1/0.229, 1/0.224, 1/0.255]
)

#transform the image
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    normalize,
])


def get_saliency(img, model, class_index):
    # Remove the gradient of model weight
    for param in model.parameters():
        param.requires_grad = False

    model.eval()
    input = transform(img)
    input.unsqueeze_(0)

    # set grad of input images
    input.requires_grad = True
    # Forward pass to calculate predictions of the label we use.
    # and use the max probability as class or the class_index we input
    preds = model(input)  # [1, 1000]
    if class_index==-1:
        score, indices = torch.max(preds, 1)
    else:
        score = preds[0, class_index]

    score.backward()
    grad = input.grad[0]
    # get the max gradients along channel axis(write by paper)
    slc, _ = torch.max(torch.abs(input.grad[0]), dim=0)
    # normalize to [0..1]
    slc = (slc - slc.min()) / (slc.max() - slc.min())

    with torch.no_grad():
        input_img = inv_normalize(input[0])
    return input_img, slc, grad

def show_pictures(img, simg, grad, filename):
    # plot image and its saleincy map
    plt.figure(figsize=(10, 10))
    plt.subplot(1, 3, 1)
    plt.imshow(np.transpose(img.detach().numpy(), (1, 2, 0)))
    plt.xticks([])
    plt.yticks([])
    plt.subplot(1, 3, 2)
    plt.imshow(simg.numpy(), cmap=plt.cm.gray) #yy
    save_saliency_images(simg.numpy(), filename, '_originSal')
    plt.xticks([])
    plt.yticks([])
    plt.subplot(1, 3, 3)
    simg_conv = convert_to_grayscale(grad.numpy(), max_percentage=99.9)[0]
    plt.imshow(simg_conv, cmap=plt.cm.gray)  # yy
    save_saliency_images(simg_conv, filename, '_improvedSal')
    plt.xticks([])
    plt.yticks([])
    plt.show()

def get_index(picturename):
    dict = {}
    filename = "../images/imagenet_class_to_idx_torch_hub.txt"
    with open(filename, 'r', encoding='utf-8') as f:
        for line in f.readlines():
            line1 = line.split("	")
            key = line1[0]
            value = line1[1].replace('\n','')
            dict[key] = int(value)
    a = picturename.split("/")
    k = a[-2]
    index = dict.get(k, -1)
    if(index==-1):
        print("Don't find the corresponding index!!!")
    return index

def convert_to_grayscale(im_as_arr, max_percentage):

    grayscale_im = np.sum(np.abs(im_as_arr), axis=0)
    im_max = np.percentile(grayscale_im, max_percentage)
    im_min = np.min(grayscale_im)
    grayscale_im = (np.clip((grayscale_im - im_min) / (im_max - im_min), 0, 1))
    grayscale_im = np.expand_dims(grayscale_im, axis=0)
    return grayscale_im

def save_saliency_images(img, file_name, suffix):

    if not os.path.exists('../results'):
        os.makedirs('../results')
    path_to_file = os.path.join('../results', file_name + suffix+ '.jpg')
    if isinstance(img, (np.ndarray, np.generic)):
        img = Image.fromarray(img*255)
    img.convert('L').save(path_to_file)


if __name__ == '__main__':
    filename = "../images/part1/5834or.jpg"
    idx = get_index(filename)
    input_img = Image.open(filename).convert('RGB')
    img, sal_img, grad = get_saliency(input_img, model,idx)
    show_pictures(img, sal_img, grad, filename.split('/')[-1][0:-4])
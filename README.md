# Vision Truth
![large_visiontruth_0](https://user-images.githubusercontent.com/83014418/153699208-8a375698-6fda-4fbe-a826-979ca4c77505.png)

Vision Truth is an intuitive mobile application that classifies between real and GAN-generated or doctored images.

## Achievements

- First Runner Up at [AI Stars Competition](https://youtu.be/KBcNdfY0gQw) by AI Club

## Problem Statement

In today's world of social media there is a great amount of fake news being spread. Quite a few times doctored images or AI generated images are also sent, making people believe the fake news. People are often naive and believe what they see in these doctored photos. These images soon become viral on social media and the internet. These images could cause political and social issues. 

## Solution

- An AI-based mobile app that can classify between real and doctored images
- The user gets an option to select if their image has faces or not
- The user selects an image and the app intelligently classifies it and gives the user the result

## Dataset

### Images with Faces

- Total of 100,000 images
- 10000 for validation and 90000 for training
- [Credit](https://www.kaggle.com/xhlulu/140k-real-and-fake-faces)

### Images without Faces

- Total of 1000 images
- 100 for validation and 900 for training
- [Credit](https://www.sciencedirect.com/science/article/pii/S2352340919312193)

## Machine Learning Model

- Used MobileNetv2 CNN Algorithm
- Experimented with ResNet50 CNN Algorithm
- Accuracy for the model without faces - 72%
- Accuracy for the model with faces - 78%

## App Development

- Built the app using Flutter, a multiplatform mobile app framework
- Used Tensorflow Lite for machine learning on mobile

## Future Plans

- Further improve the accuracy of the model
- Make the app publicly available
- Classify video deep fakes
- Build a Chrome extension

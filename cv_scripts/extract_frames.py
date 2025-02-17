import cv2 

print("start extraction")
vidcap = cv2.VideoCapture('2025-02-16-151324.webm')
success,image = vidcap.read()
count = 0
while success:
  cv2.imwrite("frame%d.jpg" % count, image)     # save frame as JPEG file      
  success,image = vidcap.read()
  print('Read a new frame: ', success)
  count += 1
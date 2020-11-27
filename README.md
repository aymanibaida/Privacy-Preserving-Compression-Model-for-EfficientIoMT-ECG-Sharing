# Privacy-Preserving-Compression-Model-for-Efficient-IoMT-ECG-Sharing
This repo is the source code of our research paper it is a work in progress. 
To run this code you will need Matlab with neural network toolbox installed. 

just run the test.m and it will run the experiments for you. It will go through all .mat files inside the data folder and try to compress them. Each .mat file represent a seperate ECG signal. 
If you want to use GPU or parallel processing features, you can edit test.m file and update the code
```javascript
 parellel='no';
    gpu='no';
 ```
you can change the values to yes accordignly. 

If you use this code please cite our research paper 
> Ayman Ibaida, Alsharif Abuadbba, Naveen Chilamkurti, Privacy-preserving compression model for efficient IoMT ECG sharing,Computer Communications,Volume 166,2021,Pages 1-8,ISSN 0140-3664,https://doi.org/10.1016/j.comcom.2020.11.010.(http://www.sciencedirect.com/science/article/pii/S0140366420319903)

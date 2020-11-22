function [CR] = comp( ecg,bs,parallel,patient,subp,gpu )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

s=size(ecg,1);
nb=floor(s/bs);

s=length(ecg);
a(1,1)=ecg(1);
a(2,1)=ecg(2);
bi=0;
x(:,1)=1:bs;
a=[];
x=x';
netsize=0;
tic;
for i=1:nb%bs:s-bs+1
    % bi=bi+1;
    temp=ecg(1+((i-1)*bs):i*bs);
    
    %%%%%%%%%%%%
    
    t = temp';
    
    % Choose a Training Function
    % For a list of all training functions type: help nntrain
    % 'trainlm' is usually fastest.
    % 'trainbr' takes longer but may be better for challenging problems.
    % 'trainscg' uses less memory. Suitable in low memory situations.
    trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.
    
    % Create a Fitting Network
    hiddenLayerSize = 20;
    net = fitnet(hiddenLayerSize,trainFcn);
    
    % Choose Input and Output Pre/Post-Processing Functions
    % For a list of all processing functions type: help nnprocess
    net.input.processFcns = {'removeconstantrows','mapminmax'};
    net.output.processFcns = {'removeconstantrows','mapminmax'};
    
    
    % Setup Division of Data for Training, Validation, Testing
    % For a list of all data division functions type: help nndivision
    net.divideFcn = 'dividetrain';  % Divide data randomly
    net.divideMode = 'sample';  % Divide up every sample
    net.divideParam.trainRatio = 70/100;
    net.divideParam.valRatio = 15/100;
    net.divideParam.testRatio = 15/100;
    net.trainParam.showWindow = 0;   % <== This does it
    
    % Choose a Performance Function
    % For a list of all performance functions type: help nnperformance
    net.performFcn = 'mse';  % Mean Squared Error
    
    % Choose Plot Functions
    % For a list of all plot functions type: help nnplot
    net.plotFcns = {'plotperform','plottrainstate','ploterrhist', 'plotregression', 'plotfit'};
    
    % Train the Network
    [net,tr] = train(net,x,t,'useParallel',parallel,'useGPU',gpu);
    % Test the Network
    y = net(x,'useParallel',parallel,'useGPU',gpu);
    netsize=netsize+240;
    %%%%%%%%%%%%
    
    a=[a;roundn(y',0)];
end


b=a-ecg;

disp('compressing');

f=fopen('bcd.bin','w');
fwrite(f,b,'uint16') ;
fclose(f);

dos('bzip2 -f bcd.bin &');
fileInfo = dir('bcd.bin.bz2');
fileSize = fileInfo.bytes+netsize;


disp("time taken to compress the ecg of " + s/360 + " seconds is " + toc+ " seconds ");
CR=length(ecg)*2/fileSize


end
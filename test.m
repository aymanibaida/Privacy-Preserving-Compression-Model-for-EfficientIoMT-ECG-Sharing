%this file will watermark all files in the directory
%water=m_message_xform('ayman ibaida');
clear all
clc
al=dir('data\*.mat');
for xx=1:size(al)
    
    fileToRead1=al(xx).name;
    
    rawData1 = importdata(['data\' fileToRead1]);
    
    % For some simple files (such as a CSV or JPEG files), IMPORTDATA might
    % return a simple array.  If so, generate a structure so that the output
    % matches that from the Import Wizard.
    [unused,name] = fileparts(fileToRead1); %#ok
    newData1.(genvarname(name)) = rawData1;
    
    % Create new variables in the base workspace from those fields.
    vars = fieldnames(newData1);
    temp1=newData1.(vars{xx});
    ecg=temp1';
    
    parellel='no';
    gpu='no';
    bs=15000
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ax=1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    CR=comp(ecg(1:15000),bs,parellel,xx, ax,gpu);
    result{xx,1}=name;
    result{xx,2}=CR;
end
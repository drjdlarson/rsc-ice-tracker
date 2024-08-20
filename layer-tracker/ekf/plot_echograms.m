
clear; clc; close all

addpath("../../raw-echogram/")

files = dir('../../raw-echogram/');
file_names = {files(~[files.isdir]).name};

for k = 1:length(file_names)
    data{k} = load(file_names{k});
end

for k = 1:length(data)
    figure; 
    imagesc(data{k}.wiener2_modified); colormap(1-gray)
    title(file_names{k})
end

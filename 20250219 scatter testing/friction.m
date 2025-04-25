clear; close all; clc; 

friction_mat = load('friction.csv');
m_0 = mean(friction_mat);
std_0 = std(friction_mat);


sprintf('%0.5g \x00B1 %0.5g',m_0,std_0)
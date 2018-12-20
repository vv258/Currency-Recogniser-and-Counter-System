%CREATE TEMPLATES
A=imread('C:\Users\user\Pictures\currencyrec\10ctemp.jpg');
B=imread('C:\Users\user\Pictures\currencyrec\50ctemp.jpg');
C=imread('C:\Users\user\Pictures\currencyrec\100ctemp.jpg');
note=[A B C];
templatesc=mat2cell(note,40,[100 100 100]);
save ('templatesc','templatesc')
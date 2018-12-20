function varargout = v2(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @v2_OpeningFcn, ...
    'gui_OutputFcn',  @v2_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function v2_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
set(handles.uitable1,'Visible','off');
set(handles.text3,'Visible','off');

jframe=get(handles.figure1,'javaframe');
jIcon=javax.swing.ImageIcon('C:\Users\user\Desktop\prjct\myicon.jpg');
jframe.setFigureIcon(jIcon);
if isdeployed
    if ~isempty(varargin)
        [pathToFile,nameOfFile,fileExt] = fileparts(varargin{1});
        nameOfExe=[nameOfFile,fileExt];
        dosCmd = ['taskkill /f /im "' nameOfExe '"'];
        dos(dosCmd);
    end
    
end
global vid;
vid = videoinput('winvideo',2,'YUY2_640x480');
set(vid,'ReturnedColorSpace','RGB');
 src=getselectedsource(vid);
 set(src,'Exposure',-6);
 set(src,'Brightness',-64);
 set(src,'Contrast',64);
 set(src,'Sharpness',15);
 preview(vid);
global s;
if isempty(s)
    s = serial('COM4');
    set(s, 'BaudRate', 9600, 'StopBits', 1);
    set(s, 'Terminator', 'CR', 'Parity', 'none');
    set(s, 'FlowControl', 'none');
else
    fclose(s);
    s=s(1);
end;
fopen(s);
guidata(hObject, handles);

function varargout = v2_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function [res]= capture()
global savename;
global data;
global vid;
tstart=cputime;
a = getsnapshot(vid);
r=coloredges(a);
r = r / max(r(:));
r=adapthisteq(r);
d=im2bw(r,0.3);
s=bwareaopen(d,3000);
s=imfill(s,'holes');
x=regionprops(s,'Orientation');
y=x.Orientation;
y=y*-1;
d=imrotate(d,y);
s=imrotate(s,y);
[f c]=find(s);
lmaxc=max(c);
lminc=min(c);
lmaxf=max(f);
lminf=min(f);
w=lmaxc-lminc+1;
h=lmaxf-lminf+1;
ar=w/h;
m1=floor(h *67/200);
m2=ceil(h*110/200);
n1=floor(w *165/500);
n2=ceil(w*290/500);
lmaxc2=lminc+n2;
lminc2=lminc+n1;
lmaxf2=lminf+m2;
lminf2=lminf+m1;
bw2=d(lminf2:lmaxf2,lminc2:lmaxc2);
bw2=bwareaopen(bw2,250);
[f c]=find(bw2);
lmaxc3=max(c);
lminc3=min(c);
lmaxf3=max(f);
lminf3=min(f);
imgn=bw2(lminf3:lmaxf3,lminc3:lmaxc3);%Crops image
imgn=bwareaopen(imgn,50);

imgn=imresize(imgn,[40 100],'bilinear');
comp=[0 0 0 0];
load templatesd
for n=1:4
    comp(n)=corr2(templatesd{1,n},imgn);
   end
m=max(comp);
display(comp);
vd=find(comp==m);
if (vd==2 && ar>=2.2)
    vd=4;
end;
if (vd==4 && ar<=2.2)
    vd=2;
end;  
if m>0.2
    if vd==1
        res='10.';
    elseif vd==2
        res='50.';
    elseif vd==3
        res='100.';
    elseif   vd==4
        res='20.';
    end
else res='unrecognized.';
    vd=5;
end
data(vd) = data(vd)+1;
tstop = cputime-tstart;
fid = fopen(savename,'a');
fprintf(fid, '%d\t%d\t%d\t%d\t%ss\t%s\r\n',comp(1), comp(2), comp(3) ,comp(4),num2str(tstop),res);
fclose(fid);
return ;

function [f]=fake()
global data;
data(6)=data(6)+1;
f='fake.';

function pushbutton1_Callback(hObject, eventdata, handles)
set(handles.pushbutton1,'Visible','off');
set(handles.text3,'Visible','on');
global data;
global vid;
data=[0 0 0 0 0 0];
global savename;
savename = strcat('C:\Users\user\Pictures\currencyrec\log\logfile-' , datestr(now,'dd-mmm-yyyy-HH-MM-SS') , '.txt');
fid = fopen(savename,'w');
fprintf(fid, 'cor10\t\tcor50\t\tcor100\t\tcor20\t\ttime\t\tresult\r\n');
fclose(fid);

global s;
fprintf(s,'start.');
pause(0.5);

while(1)
    if(s.BytesAvailable)
        p=fscanf(s);
        if(strcmp(p,'capture.'))
            fprintf(s,capture());
        elseif (strcmp(p,'stop.'))
            break;
        elseif (strcmp(p,'fake.'))
            fprintf(s,fake());
           end ;
    end ;
end ;
            closepreview(vid);
            set(handles.text3,'Visible','off');
            set(handles.uitable1,'Visible','on');
            count10= data(1);
            count20=data(4);
            count50= data(2);
            count100= data(3);
            tot10=count10*10;
            tot50=count50*50;
            tot100=count100*100;
            tot20=count20*20;
            totcount=count10+count50+count100+count20;
            total=tot10+tot50+tot100+tot20;
            datadisp=[count10 tot10;count20 tot20; count50 tot50; count100 tot100; totcount total;data(5) 0;data(6) 0];
            set(handles.uitable1,'Data',datadisp);

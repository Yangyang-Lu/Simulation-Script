clear all;
for X=0:14
    X
for k=1:49
    G(k,1)=k-1;
    G(k,2)=0;
end

S = 4.919998*4.919998*sin(pi*60/180);
L=25;

for k=0:48
    k
    
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�ܵ���ܶȵĵ���
str1 = strcat ('D:\MS\Gr-Au_Files\Documents\Pt-Gr\PES\Y\Twolayer\X', int2str(X) , '\Perl Script line Script\Gr-PtX', int2str(X) , 'Y', int2str(k) , '.charg_frm');              
                
data=importdata(str1);
A=data.data; 
clear data;
%top����ܶȵĵ���
%str2 = strcat ('C:\Users\dell001\Documents\Materials Studio Projects\ChargeDensity\Gr0-3_Files\Documents\X0\onelayer\1Gr-Gr', int2str(k) , '  CASTEP GeomOpt\1Gr-Gr', int2str(k) , ' .charg_frm');              
%top����ܶ��ڻ���·���ϱ��ֲ���
str2 = strcat ('D:\MS\Gr-Au_Files\Documents\Pt-Gr\PES\Y\Toplayer\X', int2str(X) , '\Perl Script line Script\Gr-PtX', int2str(X) , 'Y', int2str(k) , '.charg_frm');              

data=importdata(str2);
B=data.data; 
clear data;
%bottom����ܶȵĵ���
str3 = strcat ('D:\MS\Gr-Au_Files\Documents\Pt-Gr\PES\Y\Bottomlayer\Gr-Pt CASTEP Energy\Gr-Pt.charg_frm');              
data=importdata(str3);
C=data.data; 
clear data;
max_list = max(A,[],1);
%line_a = max_list(1);line_b = max_list(2);line_c = max_list(3);
a=max_list(1)*max_list(2)*max_list(3);
%���ݵ���ABC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�������ڴ洢��ɲ�ľ���D�����洢��ֵ��D����
D = A;
for  i=1:a
     D(i,4)=0;
end
for  i=1:a
     D(i,4)=A(i,4)-B(i,4)-C(i,4);
end
clear A;
clear B;
clear C;
clear a;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%E���ڴ洢���ֺ��Z���ɲ���ܶ�
%E=Zero(max_list(3),2);
for  i=1:max_list(3)
     E(i,1)=i;
     E(i,2)=0;
     F(i,1)=i;
     F(i,2)=0;
end
n = max_list(1)*max_list(2)*max_list(3);
for  i=1:n
    %B(_,2)�ܵ���ܶȴ洢λ��
     E((D(i,3)),2)=E((D(i,3)),2)+D(i,4)*S/(max_list(1)*max_list(2));
end
clear D;
clear i;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����ֵ���ܶ����ݱ��浽�����������
str4 = strcat ('D:\MS\Gr-Au_Files\Documents\Pt-Gr\PES\Data\X', int2str(X) , '\ChrgeDifferent', int2str(k) ,'.txt');              
dlmwrite(str4, E, 'delimiter', '\t','precision', 6,'newline', 'pc')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%for  i=1:max_list(3)
     
 %    F(i,2)=abs(E(i,2));
%end
for  i=1:max_list(3)
     
    G(k+1,2)=G(k+1,2)+abs(E(i,2))*L/max_list(3);
end


end 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%������·���ϵĵ�ɲ���ܶȵĻ��ֱ�������
str5 = strcat ('D:\MS\Gr-Au_Files\Documents\Pt-Gr\PES\Data\X', int2str(X) , '\sum_on_slide_all_different_chrge.txt');              
dlmwrite(str5, G, 'delimiter', '\t','precision', 6,'newline', 'pc')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear E;
clear F;
clear G;
end


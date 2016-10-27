Files=dir('pathpositioncorrect');
Files1=dir('pathpositionwrong');
y=length(Files);
y1=length(Files);
trainingfeatures=zeroes(y+y1);
traininglabels=zeroes(y+y1);
for i = 1:length(Files)
    im=imread(pathpostion/Files(i).name);
    trainingfeatures(i,:)=  extractHOGFeatures(im);
    traininglabels(i)=1;
end
for i = y:(y+y1)
     im=imread(pathpostion/Files1(i).name);
     trainingfeatures(i,:)=  extractHOGFeatures(im);
     traininglabels(i)=0;
end
model = fitcecoc(trainingfeatures, traininglabels);
image=imread('image');
wSize=[24,32];
detect(image,model,wSize);
function detect(im,model,wSize)

topLeftRow = 1;
topLeftCol = 1;
[bottomRightCol, bottomRightRow, d] = size(im);

fcount = 1;

for y = topLeftCol:bottomRightCol-wSize(2)   
    for x = topLeftRow:bottomRightRow-wSize(1)
        p1 = [x,y];
        p2 = [x+(wSize(1)-1), y+(wSize(2)-1)];
        po = [p1; p2];
        img = imcut(po,im);     
        featurevector{fcount}= extractHOGFeatures(im);
        boxPoint{fcount} = [x,y];
        fcount = fcount+1;
        x = x+1;
    end
end

%label = ones(length(featureVector),1);
P = cell2mat(featureVector);
% each row of P' correspond to a window
[~, predictions] = predict(P',model); % classifying each window

[a, indx]= max(predictions);
bBox = cell2mat(boxPoint(indx));
rectangle('Position',[bBox(1),bBox(2),24,32],'LineWidth',1, 'EdgeColor','r');
end


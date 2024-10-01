function output_tracks = plot_results(model,meas,est,trimmed_data,colorVar,track_length_min)
%plot x tracks and measurements in x/y

if model.subplot == 1
    subplot(1,model.max_num,model.num)
end

title(model.name)

labelcount= countestlabels();
colorarray= makecolorarray(labelcount);
est.total_tracks= labelcount;
est.track_list= cell(meas.K,1);
for k=1:meas.K
    for eidx=1:size(est.X{k},2)
        est.track_list{k} = [est.track_list{k} assigncolor(est.L{k}(:,eidx))];
    end
end
[Y_track,l_birth,l_death]= extract_tracks(est.X,est.track_list,est.total_tracks);


%plot x tracks and measurements in x/y
% figure(); 
tracking= gcf; hold on;

%plot x measurement
%subplot(211); box on; 
imagesc(trimmed_data)
colormap(1-gray)
hold on
for k=1:size(meas.Z,2)
    if ~isempty(meas.Z{k})
        hlined= line(meas.meas_map(k)*ones(size(meas.Z{k},2),1),meas.Z{k}(1,:),'LineStyle','none','Marker','.','Markersize',1.8,'Color','r');
    end   
end
%hlined= line(meas.meas_map(cur_time)*ones(size(meas.Z{cur_time},2),1),meas.Z{cur_time}(1,:),'LineStyle','none','Marker','o','Markersize',1,'Color','black');

k = 1;

output_tracks = cell(1);

% %plot x estimate
for t=1:size(Y_track,3)
    temp = Y_track(1,:,t);
    num_valid = sum(~isnan(temp));
    if num_valid > track_length_min
        %hline2= line(meas.meas_map,Y_track(1,:,t),'LineStyle','-','Color',colorarray.rgb(t,:),'LineWidth',1);
        hline2= line(meas.meas_map,Y_track(1,:,t),'LineStyle','-','Color',colorVar,'LineWidth',1,'Marker','o','Markersize',1);
        output_tracks{k} = [meas.meas_map; Y_track(1,:,t)];
        k = k + 1;
    else
        continue
    end
end

set(gca, 'YDir','reverse')
ylabel('Range (m)');
ylim([model.range(1)-5, model.range(2)+5]);
xlim([meas.meas_map(1) meas.meas_map(end)])
yline(model.range(1),'r')
yline(model.range(2),'r')
drawnow
%exportgraphics(tracking,'testAnimated.gif','Append',true);
handles=[ tracking ];

function ca= makecolorarray(nlabels)
    lower= 0.1;
    upper= 0.9;
    rrr= rand(1,nlabels)*(upper-lower)+lower;
    ggg= rand(1,nlabels)*(upper-lower)+lower;
    bbb= rand(1,nlabels)*(upper-lower)+lower;
    ca.rgb= [rrr; ggg; bbb]';
    ca.lab= cell(nlabels,1);
    ca.cnt= 0;   
end

function idx= assigncolor(label)
    str= sprintf('%i*',label);
    tmp= strcmp(str,colorarray.lab);
    if any(tmp)
        idx= find(tmp);
    else
        colorarray.cnt= colorarray.cnt + 1;
        colorarray.lab{colorarray.cnt}= str;
        idx= colorarray.cnt;
    end
end

function count= countestlabels
    labelstack= [];
    for k=1:meas.K
        labelstack= [labelstack est.L{k}];
    end
    [c,~,~]= unique(labelstack','rows');
    count=size(c,1);
end

end


function [X_track,k_birth,k_death]= extract_tracks(X,track_list,total_tracks)

K= size(X,1); 
x_dim= size(X{K},1); 
k=K-1; 
while x_dim==0 
    x_dim= size(X{k},1); 
    k= k-1; 
end
X_track= NaN(x_dim,K,total_tracks);
k_birth= zeros(total_tracks,1);
k_death= zeros(total_tracks,1);

max_idx= 0;
for k=1:K
    if ~isempty(X{k})
        X_track(:,k,track_list{k})= X{k};
    end
    if max(track_list{k})> max_idx %new target born?
        idx= find(track_list{k}> max_idx);
        k_birth(track_list{k}(idx))= k;
    end
    if ~isempty(track_list{k}), max_idx= max(track_list{k}); end
    k_death(track_list{k})= k;
end
end


function Xc= get_comps(X,c)

if isempty(X)
    Xc= [];
else
    Xc= X(c,:);
end
end
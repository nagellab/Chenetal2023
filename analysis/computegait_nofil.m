function [gait] = computegait_nofil(data)

gait = struct();

flies = length(data);
for i = 1:flies
    %sz_x = size(data(i).x);
    %for w = 1:sz_x(2)
    %    for l = 2:sz_x(1)
    %        vel_fly(l-1,w) = (sqrt((data(i).x(l,w)-data(i).x(l-1,w))^2 + (data(i).y(l,w)-data(i).y(l-1,w))^2))/0.02;
    %    end
    %end
    gait(i).fly = data(i).fly;
    gait(i).date = data(i).date;
    gait(i).experiment = data(i).experiment;
    gait(i).genotype = data(i).genotype;
    gait(i).time = data(i).time;
    gait(i).v = hypot(diff(data(i).y,1,1),diff(data(i).x,1,1))/ 0.02; %store velocity mm/s
    gait(i).vy = diff(data(i).y,1,1) ./0.02; %calculate upind speed mm/s
    gait(i).pmove = double(gait(i).v > 1); %calculate p move
    gait(i).utheta = unwrap(data(i).theta * (pi/180)) * (180/pi); %unwrap orientations 
    gait(i).angv = abs(diff(gait(i).utheta)) ./0.02; %calculate angular velocity degrees/s
    sz = size(gait(i).v);
    for a = 1:sz(1)
        for b = 1:sz(2)
            if gait(i).v(a,b) > 1
                gait(i).curvature(a,b) = gait(i).angv(a,b) ./gait(i).v(a,b);
            else
                gait(i).curvature(a,b) = nan;
            end
        end
    end
    gait(i).pturn = double(gait(i).curvature > 20);
end



        


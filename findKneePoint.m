clear
close all
load linkAllHighSNR ZCo ZDe Z ZUn

figure
semilogx(flipud(ZCo(:,3)))
hold on
semilogx(flipud(ZDe(:,3)))
semilogx(flipud(Z(:,3)))
semilogx(flipud(ZUn(:,3)))

figure
curveCo=semilogx(flipud(ZCo(:,3)));
hold on
% Connect the first and last point as a reference line
plot([curveCo.XData(1),curveCo.XData(end)],[curveCo.YData(1),curveCo.YData(end)])
% Calculate the distance from each point to the line
for x=1:length(curveCo.XData)
    distance(x)=point_to_line(log(curveCo.XData(x)),curveCo.YData(x),log(curveCo.XData(1)),curveCo.YData(1),log(curveCo.XData(end)),curveCo.YData(end));
end
% Find the maximum distance
[maxDist, idx] = max(distance);
idx


figure
curveDe=semilogx(flipud(ZDe(:,3)));
hold on
plot([curveDe.XData(1),curveDe.XData(end)],[curveDe.YData(1),curveDe.YData(end)])
for x=1:length(curveDe.XData)
    distance(x)=point_to_line(log(curveDe.XData(x)),curveDe.YData(x),log(curveDe.XData(1)),curveDe.YData(1),log(curveDe.XData(end)),curveDe.YData(end));
end
[maxDist, idx] = max(distance);
idx

figure
curve=semilogx(flipud(Z(:,3)));
hold on
plot([curve.XData(1),curve.XData(end)],[curve.YData(1),curve.YData(end)])
for x=1:length(curve.XData)
    distance(x)=point_to_line(log(curve.XData(x)),curve.YData(x),log(curve.XData(1)),curve.YData(1),log(curve.XData(end)),curve.YData(end));
end
[maxDist, idx] = max(distance);
idx

figure
curveUn=semilogx(flipud(ZUn(:,3)));
hold on
plot([curveUn.XData(1),curveUn.XData(end)],[curveUn.YData(1),curveUn.YData(end)])
for x=1:length(curveUn.XData)
    distance(x)=point_to_line(log(curveUn.XData(x)),curveUn.YData(x),log(curveUn.XData(1)),curveUn.YData(1),log(curveUn.XData(end)),curveUn.YData(end));
end
[maxDist, idx] = max(distance);
idx
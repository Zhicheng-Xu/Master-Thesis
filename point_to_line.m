function dist=point_to_line(x3, y3, x1, y1, x2, y2)
    a=(y2-y1)/(x2-x1);
    b=-1;
    c=y1-a*x1;
    dist=abs(a*x3+b*y3+c)/sqrt(a^2+b^2);
end
function [all_o all_errors] = read_featsel_results(featsel_fname, N)
fid = fopen(featsel_fname, 'r');
if(fid == -1)
    fprintf('Cannot open file.');
end
all_o = cell(1,N);
all_errors = zeros(N,1);
n = 1;
while(feof(fid)==0)
    tline = fgets(fid);
    [x, count, errmsg, nextindex]=sscanf(tline, '%f');
    if(length(x)<2)
        continue;
    end
all_errors(n) = x(1);
%         tline
%         nextindex
        expr='(\d+),';
        [tok mat] = regexp(tline, expr, 'tokens', 'match');
        for i=1:length(tok)
            o(i)=str2num(tok{i}{1});
        end
        all_o{n} = o;
        if(n==N)
            break;
        end
        n = n+1;
end
fclose(fid);

all_o(n:N) = [];
all_errors(n:N) = [];

disp('Selected features:');
disp(all_errors);


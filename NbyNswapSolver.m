%% N by M swap board solver
% by ProjectEli, 2018/12/03, All rights reserved
% Goal: make mixed board from perfectly ordered board and solve it
% example = [8,5,6; 9,4,2; 1,7,3];

%% initialize
clear; clc;

% make board
rows = 3;
columns = 3;
N = rows*columns;
OrderedBoard = reshape(1:rows*columns,rows,columns).';

MixedBoard = OrderedBoard; % create copy of ordered state;
permutations = 20;
for k=1:permutations
    selectedpairs = randsample(N,2).';
    MixedBoard(selectedpairs) = MixedBoard(fliplr(selectedpairs));
end

% Custom board (override mixed board)
MixedBoard = [9,8,1; 3,5,4; 6,2,7];

% show mixed board
disp('Original state');
disp(flipud(OrderedBoard));
% disp(['Mixed state after ' num2str(permutations) ' swaps']);
disp('Mixed state');
disp(flipud(MixedBoard));

%% Calculate entropy and matched position
isUnmatched = ~(MixedBoard==OrderedBoard); % logical matrix of matched positions
N_unmatched = sum(sum(isUnmatched)); % number of unmatched positions
UnmatchedPos = OrderedBoard(isUnmatched); % unmatched position
UnmatchedBlocks = MixedBoard(isUnmatched); % unmatched blocks

%% Make chains to separate swaps
chains = {}; % empty cell to store chains

% make dictionary
H = java.util.Hashtable; % list to store unused blocks
for k = 1:N_unmatched % only NU operation is needed
    H.put(UnmatchedPos(k),UnmatchedBlocks(k)); % key=pos, value=block
end

% extract chains
while H.size % run until empty H
    chainstart=H.keys.nextElement; % get first element using iterator
    currentpos = chainstart;
    currentblock = H.remove(currentpos); % pop out the next position
    chain= [currentpos];
    while ~(currentblock==chainstart) % chain is finished
        chain = [chain currentblock];
        currentpos = currentblock;
        currentblock = H.remove(currentpos);
    end
    chains{end+1} = chain; % add chain into container
end

%% Print out the solution
disp('Swap the following pairs');
for k = 1:length(chains)
    chain = chains{k};
    for k2 = 1:(length(chain)-1)
        disp(chain([k2 k2+1]));
    end
end
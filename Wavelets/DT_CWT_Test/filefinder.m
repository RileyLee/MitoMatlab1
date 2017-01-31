function filenames=filefinder(searchpath,varargin)
%Tristan Ursell
%File Finder
%March 2012
%
%filenames = filefinder('searchpath','searchterm1','seartchterm2',...);
%
%This function will return a list of file names that contain all of the
%given search terms.  All entries to this function should be strings.  All
%search terms are case sensitive!
%
%filenames is a cell array.
%
%Conceptual Example:
%
% Let's presume that within 'searchpath' there are, in total, five files:
%
% 1) future.txt
% 2) predictions.txt
% 3) future predictions.txt
% 4) predilections.txt
% 5) predictions for future.txt
%
% Using the search term '.txt' returns a cell array with all five file
% names.
%
% Using the search term 'tions' returns a cell array with filenames 2
% through 5.
%
% Using the serach term 'future' returns a cell array with filenames 1,3,
% and 5.
%
% Using the search terms 'future' and 'prediction' returns a cell array
% with filenames 3 and 5.
% 
% Using the search term 'future prediction' returns a cell array with only
% filename 3. Thus one can combine two independent search terms in an
% ordered search term.


%parse varargin input
nargs=nargin-1;

%create the list of all items in the path
mainstruct=dir(searchpath);

%figure out which items are files (i.e. not directories)
filelist=find(~[mainstruct.isdir]);

%Calculate number of files
nfiles=length(filelist);

%if search terms are given
if nargs>0
    %check each term agains each tile
    checkmat=zeros(nfiles,nargs);
    for i=1:nfiles
        for j=1:nargs
            temp1=strfind(mainstruct(filelist(i)).name,char(varargin{j}));
            checkmat(i,j)=length(temp1>0);
        end
    end
    %count up the files that contain all the search terms
    sublist=sum(checkmat,2)==nargs;
    %put the names of those files into a cell-array
    filenames={mainstruct(filelist(sublist)).name};
else
    %if no search terms are given, return full list of filenames
    filenames={mainstruct(filelist).name};
end

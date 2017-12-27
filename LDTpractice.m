%Time-Based Prospective Memory task embedded in a Lexical Decision Task
%created by Francesco Pupillo, 12-Oct-2017, r01fp16@abdn.ac.uk. University of Aberdeen

function[scoreLDT] = LDTpr()
try
   
rect=Screen('Rect', 0) ; % returns an array with the top left corner and the bottom right corner coordinates of the screen
%for testing
%[MyScreen, rect] = Screen('OpenWindow', 0, [0, 0, 0], rect/2 ); %select the screen and the color (black)
[MyScreen, rect] = Screen('OpenWindow', 0, [0, 0, 0], rect); %select the screen and the color (black)
%MyScreen=Screen('Screens');
slack=Screen('GetFlipInterval', MyScreen) /2  ; %the flip interval
fps=Screen('NominalFrameRate', MyScreen); %screen per second
%function [score3Tot]=LDT(experimenter, SubjNr)
%get the code for the space bar
space=KbName('space'); 
c=KbName('c');
m=KbName('m');
y=KbName('y');
n=KbName('n');
%No variable for the while loop
NO=0;
%set the stimulus duration as a function of frame per seconds
stimDuration=round(0.5*fps); %in fps 
%set the duration for the fixation cross
crossDuration=round(0.725*fps); %in fps 735 ms
h=0; %counter
j=0; %counter
k=0;
s=stimDuration; %counter to avoid continuous presses of the yes and no keys
%retrieve the file with the words 
[Prwords,Prnonwords]=textread('LDTpractice words3.csv', '%s%s', 'delimiter', ',');
wholepracticewords=[Prwords;Prnonwords];
%randomise the words
practiceWorder=wholepracticewords(randperm(length(wholepracticewords)));
%create dummy coding for the length of the presentation of the stimulus(1)
%and for the fixation cross
trials=length(wholepracticewords);
rt=zeros(1,max(trials));
a=[repelem(1,stimDuration),repelem(2,crossDuration)];% 40=stimulut presentation; 20= cross presentation
b=repmat(a, 1,trials); %length task=trials
%defining the screen size and instructions
    DrawFormattedText(MyScreen,'In this task you will see a series of letters appear on the screen\n\nyour task is to press the "YES" button if the letters you see \n\n make up a word and press the "NO" button if this is not the case','center', rect(3)/6   , [255 255 255]);
    DrawFormattedText(MyScreen,'Please press any key to continue','center', rect(3)/2 , [255 255 255]);
    Screen('Flip', MyScreen);
    HideCursor()
    KbWait;
    WaitSecs(1);
    DrawFormattedText(MyScreen,'The words will appear quickly,\n\nbut try not to get overwhelmed.','center', rect(3)/6, [255 255 255]);
    DrawFormattedText(MyScreen,'Before starting with the task, you will start a brief practice trial.','center', rect(3)/3, [255 255 255]);
    DrawFormattedText(MyScreen,'Press any key to continue','center', rect(3)/2, [255 255 255]);
    Screen('Flip', MyScreen); 
    KbWait;
    WaitSecs(1);
    DrawFormattedText(MyScreen,'Please place your right index finger on the "YES" button\n\n and your left index finger on the "NO" button.\n\n ','center', rect(3)/6  , [255 255 255]);
    DrawFormattedText(MyScreen,'Please always try to work as accurately and as quickly as possible','center', rect(3)/3 , [255 255 255]);
    DrawFormattedText(MyScreen,'Press any key to start the task','center', rect(3)/2, [255 255 255]);
    Screen('Flip', MyScreen);
    KbWait;
    WaitSecs(1);
  while  NO==0 %counter for repeating or not the practice trial
     score=zeros(length(trials)); %make the score 0 for every trial
     DrawFormattedText(MyScreen,'Ready...','center', 'center', [255 255 255]);
     Screen('Flip', MyScreen);
     WaitSecs(2);
     HideCursor() %hide the cursor
     DrawFormattedText(MyScreen,'Go!','center', 'center', [255 255 255]);
     Screen('Flip', MyScreen);
     WaitSecs(1);

%while t1<10 %this could also be eliminated
[KeyIsDown, secs, keyCode]=KbCheck; %start checking for the any key pressed

%set the time when the task start
t0=GetSecs;
%set a counter as a difference from the moment the task starts
t1=GetSecs-t0;
t1=round(t1); 
%set a counter for the first word
trial=1;
i=1.1; %starting counter for the words
space=KbName('space');

 for e=1:length(b) %for the lenght of the variable we have set, which is equal to the length of the words
     %while NO==0 
     
     if b(e)==1 %for the stimulus 
            b;
             trial= fix(i);%the trial equals the counter wihout the dot
     
[KeyIsDown, secs, keyCode]=KbCheck;

t1=GetSecs-t0;
t1=round(t1);
 
%select the word
 wordselected=char(practiceWorder (trial));
 textsize=48;  
 Screen('TextSize', MyScreen, textsize) ; %set the text size
 Screen('TextFont', MyScreen, 'Arial'); %set the font
 DrawFormattedText(MyScreen,wordselected,'center', rect(4)/2+textsize/2 , [255 255 255]); %draw text
 k=k+1;
 else if b(e)==2 %for the cross
            b;
            [KeyIsDown, secs, keyCode]=KbCheck;

t1=GetSecs-t0;
t1=round(t1);

 a=11; %length of the cross
 Screen('DrawLine', MyScreen, [255,255,255],rect(3)/2, rect(4)/2-a,rect(3)/2,rect(4)/2+a);
 Screen('DrawLine', MyScreen, [255,255,255],rect(3)/2-a,rect(4)/2, rect(3)/2+a,rect(4)/2);  
 i=1/crossDuration+i; %counter for let matlab know which word to select
 k=k+1;
 
     end
 if k==stimDuration+crossDuration
     k=0;
 end
      
        end

if KeyIsDown %if the key 
    if (keyCode(c) && ~isempty(strmatch(practiceWorder(trial), Prnonwords))) && s>stimDuration
            score(trial)=1 ; %if participant press the no button for non words
            rt(trial)=k/fps;
            s=0;
    elseif (keyCode(c) && isempty(strmatch(practiceWorder(trial), Prnonwords))) && s>stimDuration
                 score(trial)=0 ;%%if participant press the no button for words
                             rt(trial)=k/fps;
                             s=0;
         end 
            if (keyCode(m) && ~isempty(strmatch(practiceWorder(trial), Prwords))) && s>stimDuration
            score(trial)=1;  %%if participant press the yes button for words
            rt(trial)=k/fps;
            s=0;
            elseif (keyCode(m) && isempty(strmatch(practiceWorder(trial), Prwords))) && s>stimDuration
                 score(trial)=0;  %if participant press the yes button for nonwords
                 rt(trial)=k/fps;
                 s=0;
            end
end
s=s+1;
                 %now it is time to flip everything is on the screen                   
 Screen('Flip', MyScreen);
 end
   WaitSecs(1);
   scorePR=['Your score is ',num2str(fix((sum(score)/trial)*100)),' %'];
   Screen('TextSize', MyScreen, 25  );
   DrawFormattedText(MyScreen,'Thank you for completing the practice trial','center', rect(3)/6   , [255 255 255]);
   DrawFormattedText(MyScreen,scorePR, 'center', rect(3)/4  , [255 255 255]);
   DrawFormattedText(MyScreen,'Please approach the experimenter before continuing','center', rect(3)/3, [255 255 255]);
   DrawFormattedText(MyScreen,'Press the SPACE BAR when you are ready to continue','center', rect(3)/2 , [255 255 255]);
   Screen('Flip', MyScreen);
   WaitSecs(1);
   KbWait();
   DrawFormattedText(MyScreen,'Would you like to try this task again? Y/N','center', rect(4)/2 , [255 255 255]);
   Screen('Flip', MyScreen);
   WaitSecs(1);
 %[KeyIsDown, secs, keyCode]=KbWait;
 KbWait();
    while keyCode(y)==0 && keyCode(n)==0
[KeyIsDown, secs, keyCode]=KbCheck;
    end
   %wait for response to continue
   if KeyIsDown %if the key is pressed or j is more than 
    if (keyCode(y))==1 &&(keyCode(n))==0
        NO=0;
    end
    if (keyCode(n))==1 && (keyCode(y))==0
            NO=1;
        end
    end
  end

 scoreLDT=score;        
 Screen('CloseAll')

 catch
 Screen('CloseAll')
 rethrow(lasterror)
end
end
 





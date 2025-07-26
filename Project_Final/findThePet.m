%This was changed and coppied to Hide and Seek. This file exists simple for
%developpment remenants.

%The aim of this function is to establish a game of hide and seek the
%player can have with their pet.
function findThePet(petName, affection, happiness, fullness)

    if nargin < 4
        affection = 5;
        happiness = 5;
        fullness = 5;
    end

    gameFig = uifigure('Name', "Find " + petName + "!", 'Position', [300, 200, 600, 400]);

    hidingSpot = randi([1, 6]);
    bushes = cell(1, 6);

    for i = 1:6
        xPos = 50 + (i - 1) * 90;
        bushes{i} = uibutton(gameFig, ...
            'Icon', fullfile(pwd, 'bush.jpg'), ...
            'Position', [xPos, 200, 80, 80], ...
            'Text', '', ...
            'ButtonPushedFcn', @(src, event) checkBush(i));
    end

    rustleTimer = timer('ExecutionMode', 'fixedRate', ...
        'Period', 0.5, ...
        'TimerFcn', @(~, ~) rustleBush(hidingSpot));
    start(rustleTimer);

   function checkBush(selectedBush)
    if selectedBush == hidingSpot
        happiness = 5;  
        % This code makes sure happieness maxxes at 5.
        msgbox("You found " + petName + "!");

        stop(rustleTimer);
        delete(rustleTimer);
        pause(2);  
        close(gameFig);

        homeBase(petName, affection, happiness, fullness);  
    else
        msgbox(petName + " is not here!");
    end
end

    function rustleBush(index)
        bushes{index}.Position(1) = bushes{index}.Position(1) + randi([-5, 5]);
        pause(0.05);
        bushes{index}.Position(1) = bushes{index}.Position(1) - randi([-5, 5]);
    end
end

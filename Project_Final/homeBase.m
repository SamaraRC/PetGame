%The aim of this function is to create a "home" for the player's pet.
%This will be the main HUB of the game, where features are accessed from
function homeBase(petName, affection, happiness, fullness, score)
    if nargin < 5
    score = 0;
end
if nargin < 4
    fullness = 5;
end
if nargin < 3
    happiness = 5;
end
if nargin < 2
    affection = 5;
end
if nargin < 1
    petName = "TestPet";
end
    %If no stats are passed in, start with full stats. the nargin checksif
    %there are the 4 stats from before (pet name, fullness, happieness, affection.)
    %hAVING THEM SEPERATLY (Nargin<2, Nargin<3 ensures) ensures it works
    %from the save files screen AND hide and seek game.

    menuFig = uifigure('Name', petName + "'s Home", 'Position', [250, 200, 900, 525]);
    %This again makes a GUI (Graphical User Interface) called Pet's Home (via the
    %use of name) with a position of x=250, y = 200, width=900 height=525.

    %Here I create numbers to then create and update the stat vectors with.

    t = timer('ExecutionMode', 'fixedRate', ...
        'Period', 10, 'TimerFcn', @(~,~) statChange());
    % Here a timer function is used. ExecutionMode + fixedRate make the
    % timer continue past the first time it is used. Period + 10 makes the
    % timer last 10 seconds. The (~,~) is used to address the timer object
    % and event data, so the variables are ignored.

    uilabel(menuFig, 'Text', 'Affection:', 'Position', [50, 420, 100, 50], 'FontSize', 16);
    uilabel(menuFig, 'Text', 'Happiness:', 'Position', [50, 390, 100, 50], 'FontSize', 16);
    uilabel(menuFig, 'Text', 'Fullness:', 'Position', [50, 360, 100, 50], 'FontSize', 16);
    %First I created the labels for the stats.

    statsUI = uilabel(menuFig, 'Text', petName + "'s Stats:", ...
        'Position', [160, 450, 300, 50], 'FontSize', 16);

    affectionUI = uilabel(menuFig, 'Text', repmat('<3 ', 1, affection), ...
        'Position', [160, 420, 300, 50], 'FontSize', 16);

    happinessUI = uilabel(menuFig, 'Text', repmat('<3 ', 1, happiness), ...
        'Position', [160, 390, 300, 50], 'FontSize', 16);

    fullnessUI = uilabel(menuFig, 'Text', repmat('<3 ', 1, fullness), ...
        'Position', [160, 360, 300, 50], 'FontSize', 16);

    %Here I create vectors using the variables from lines 8 - 10, which increment how affectionate, happy, and full
    %the pet is using repmat to make a vertex of <3s, of 1 in rows and the stat (ie
    %affection) in columns. These bars are to diminish and need to be refilled by the
    %player's activities.

    statsExplainUI = uilabel(menuFig, 'Text', "Hints!:", ...
        'Position', [360, 450, 300, 50], 'FontSize', 16);

    promptUI = uilabel(menuFig, 'Text', ["Your pet is content right now! But its stats will decrease with time" + newline + ...
        "Your pet's Affection is boosted by clicking them to pet them." + newline + ...
        "Your pet's Happiness is boosted by clicking a game, to play it with them." + newline + ...
        "Your pet's Fullness is boosted by clicking the food to feed your pet!"], ...
        'Position', [360, 350, 600, 150], 'FontSize', 14);
    %Use of [] and more importantly newline helps format the text on separate lines, by concatenating it.

    elGato = uibutton(menuFig, 'Position', [300, 0, 275, 183], ...
        'Icon', 'elGato.jpg', 'Text', '', 'ButtonPushedFcn', @(src, event) boostAffection());

    foodIcon = uibutton(menuFig, 'Position', [50, 0, 100, 100], ...
        'Icon', 'food.jpg', 'Text', '', 'ButtonPushedFcn', @(src,~) boostFullness());
    %Pet and food's buttons

    gamesUI = uilabel(menuFig, 'Text', "Games:", ...
        'Position', [50, 300, 300, 50], 'FontSize', 16);

    uibutton(menuFig, 'Text', "Return to File Select", ...
        'Position', [700, 50, 150, 50], ...
        'ButtonPushedFcn', @(src, event) goToFileSelect());

    uibutton(menuFig, 'Text', "Play Hide and Seek", ...
        'Position', [150, 300, 150, 50], ...
        'ButtonPushedFcn', @(src, event) playHide());

    function playHide()
        stop(t); delete(t);
        close(menuFig); 
        hideAndSeek(petName, affection, happiness, fullness); 
    end

    hopTimer = timer('ExecutionMode', 'fixedRate', ...
        'Period', 1, 'TimerFcn', @(~,~) hop());
    start(hopTimer);

    function hop()
        direction = randi([-20, 20]);
        %This part randomly decides if the pet jumps left or right.

        hopHeight = randi([5, 15]);
        %Randomly decides height of hop.

        newX = min(max(elGato.Position(1) + direction, 0), menuFig.Position(3) - elGato.Position(3));
        %Restricts pet's horizontal movement within GUI bounds.

        newY = elGato.Position(2) + hopHeight;
        %This part simply raises el gato by hopHeight.

        elGato.Position(1) = newX;
        elGato.Position(2) = newY;
        %Puts calculated movement into action.

        pause(0.1);
        elGato.Position(2) = elGato.Position(2) - hopHeight;
        %This allows the pet to briefly linger in the air, before landing.
    end

    pause(2)
    %Adds a slight delay, so things can load before the timer starts.
    start(t);
    %This starts the timer, specifically after the UI elements are read in the script.

    function statChange()
        affection = max(0, affection - randi([0, 1]));
        happiness = max(0, happiness - randi([0, 1]));
        fullness = max(0, fullness - randi([0, 1]));
        %Randomly reduces stats every 10 seconds to simulate time-based needs.

        affectionUI.Text = repmat('<3 ', 1, affection);
        happinessUI.Text = repmat('<3 ', 1, happiness);
        fullnessUI.Text = repmat('<3 ', 1, fullness);
        drawnow;

        if affection == 0
            promptUI.Text = "Affection is depleted! Click your pet to boost Affection!";
        elseif happiness == 0
            promptUI.Text = "Happiness is depleted! Play a game with your pet to restore Happiness!";
        elseif fullness == 0
            promptUI.Text = "Fullness is depleted! Click and drag the food to your pet to feed it!";
        end
    end

    function boostFullness()
        fullness = min(5, fullness + 1)
        fullnessUI.Text = repmat('<3 ', 1, fullness);
        promptUI.Text = "You fed "+ petName + "! Fullness increased!";

        elGato.Position(1) = foodIcon.Position(1) + 20;
        elGato.Position(2) = foodIcon.Position(2);

        for i = 1:2
            hopHeight = 30;
            newY = elGato.Position(2) + hopHeight;
            elGato.Position(2) = newY;
            pause(0.15);
            elGato.Position(2) = elGato.Position(2) - hopHeight;
            pause(0.15);
        end

        pause(3);
        if affection > 0 && happiness > 0 && fullness > 0
            promptUI.Text = "Your pet is content right now! But its stats will decrease with time" + newline + ...
                "Your pet's Affection is boosted by clicking them to pet them." + newline + ...
                "Your pet's Happiness is boosted by clicking a game, to play it with them." + newline + ...
                "Your pet's Fullness is boosted by clicking and dragging the food to your pet to feed it!";
        end
    end

    function boostAffection()
        affection = min(5, affection + 1);
        affectionUI.Text = repmat('<3 ', 1, affection);
        promptUI.Text = "You petted " + petName + "! Affection increased!";

        for i = 1:2
            hopHeight = 30;
            newY = elGato.Position(2) + hopHeight;
            elGato.Position(2) = newY;
            pause(0.15);
            elGato.Position(2) = elGato.Position(2) - hopHeight;
            pause(0.15);
        end

        baseX = elGato.Position(1) + elGato.Position(3)/2 - 30;
        baseY = elGato.Position(2) + elGato.Position(4) + 30;
        %Position1 = current pet x coordinate. position(3)/2 =
        %middle/halfway point of pet's width. - 30 spaces vector

        %position2  = current y coordinate. +position4 is height, which
        %moves effect above pet. + 30 moves effect to right.

        hearts = gobjects(2, 2);
        for i = 1:2
            for j = 1:2
                xOffset = (j - 1) * (25);
                yOffset = -(i - 1) * (25);
                %Creates two rows, seperated by j-25 displacment.
                hearts(i, j) = uilabel(menuFig, ...
                    'Text', '<3', 'FontSize', 16, ...
                    'Position', [baseX + xOffset, baseY + yOffset, 100, 100]);
                %baseX and baseY are calculated to be just above the pet,
                %with xoffset and yoffset moving them down and/or right for
                %the matrix.
            end
      end

    pause(1);  % Show hearts for 1 second
    delete(hearts);  % Remove heart labels

    pause(2);  % Original pause for message duration

    if affection > 0 && happiness > 0 && fullness > 0
        promptUI.Text = "Your pet is content right now! But its stats will decrease with time" + newline + ...
            "Your pet's Affection is boosted by clicking them to pet them." + newline + ...
            "Your pet's Happiness is boosted by clicking a game, to play it with them." + newline + ...
            "Your pet's Fullness is boosted by clicking and dragging the food to your pet to feed it!";
    end
end


    function goToFileSelect()
        close(menuFig);
        stop(t); delete(t);
        stop(hopTimer); delete(hopTimer);
        saveFileSelect();
    end
end
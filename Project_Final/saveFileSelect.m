%The aim of this function is to creat a working save file system, that can
%keep player data semi-permanently.
function saveFileSelect()
    saveFig = uifigure('Name', 'Select Save File', 'Position', [300, 200, 600, 375]);
    %My ui background is innitiated.

    saveFiles = ["save1.mat", "save2.mat", "save3.mat"];
    saveNames = strings(1, 3);
    nameButtons = gobjects(1, 3);
    %The code establishes my save file data.

    updateButtons();

    uibutton(saveFig, 'Text', "Back to Start Menu", ...
        'Position', [380, 70, 200, 50], ...
        'ButtonPushedFcn', @(src, event) goToStartMenu());
    %Creates the save file buttons, with their respective data attatched.

    uiwait(saveFig);

    function updateButtons()
        for i = 1:3
            if isfile(saveFiles(i))
                data = load(saveFiles(i));
                saveNames(i) = data.petName;
            else
                saveNames(i) = "(Empty)";
                %This establishes a save file as empty if its corresponding
                %data is missing / nonexistant.
            end
        end

        for i = 1:3
            if isgraphics(nameButtons(i))
                nameButtons(i).Text = saveNames(i);
            else
                nameButtons(i) = uibutton(saveFig, 'Text', saveNames(i), ...
                    'Position', [150, 250 - (i * 60), 150, 50], ...
                    'ButtonPushedFcn', @(src, event) handleSaveSlot(i));
                uibutton(saveFig, 'Text', "X", ...
                    'Position', [310, 250 - (i * 60), 50, 50], ...
                    'ButtonPushedFcn', @(src, event) deleteSaveFile(i));
            end
        end
    end 
%This creates the name for the save file button bassed off the file name /
%pet name, and creates the x button, for deleting the file.

    function handleSaveSlot(slotIndex)
        if ~isfile(saveFiles(slotIndex))
            petName = inputdlg("Enter Your Pet's Name:", "New Save");
            if isempty(petName) || strlength(petName{1}) < 1
                return;
            end
            %If this is a new file (found using isempty to see there is no
            %data) the player is prompted for a name.
            petName = petName{1};
            save(saveFiles(slotIndex), 'petName');
            %Saves anme to the petName.
        else
            data = load(saveFiles(slotIndex));
            petName = data.petName;
            %Loads in preexisting data.
        end
        close(saveFig);
        homeBase(petName);
        %Closes the window.
    end

    function deleteSaveFile(slotIndex)
        if isfile(saveFiles(slotIndex))
            choice = questdlg("Are you sure you want to delete this save?", ...
                "Confirm Deletion", "Yes", "No", "No");
            if strcmp(choice, "Yes")
                delete(saveFiles(slotIndex));
                uialert(saveFig, "Save slot deleted!");
                updateButtons();
            end
        else
            %Deleting a save is permanent. As such, I give the player a
            %warning withe questlg pop up.
            uialert(saveFig, "This save slot is already empty!", "Error");
            %Can't delete something that doesn't exist.
        end
    end
    function goToStartMenu()
        close(saveFig);
        startMenu();
        %Loads start menu if prompted with the button.
    end
end

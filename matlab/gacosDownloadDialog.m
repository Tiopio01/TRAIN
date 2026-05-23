function choice = gacosDownloadDialog()
    % GACOSDOWNLOADDIALOG  Modal dialog for the manual GACOS download step.
    %   choice = GACOSDOWNLOADDIALOG() shows the GACOS request parameters
    %   (UTC, bounding box and dates) read from GACOS_download_info.txt in a
    %   copy-paste-ready text box, plus the instruction to select "Binary
    %   grid" as the file type on www.gacos.net. Returns 'Continue' or
    %   'Cancel'.
    %
    %   PHASE Windows port - called by PHASE_StaMPS.mlapp (a_gacos branch),
    %   replacing the previous plain uiconfirm so the user no longer has to
    %   open GACOS_download_info.txt by hand.

    choice = 'Cancel';                 % default if the window is closed

    % Read the parameters written by aps_gacos_files into the work folder
    infoFile = fullfile(cd, 'GACOS_download_info.txt');
    infoText = '';
    if exist(infoFile, 'file') == 2
        try
            infoText = fileread(infoFile);
        catch
        end
    end
    if isempty(infoText)
        infoText = '(GACOS_download_info.txt not found)';
    end

    fig = uifigure('Name', 'Download GACOS maps', ...
        'Position', [100 100 470 470], 'WindowStyle', 'modal');
    movegui(fig, 'center');

    gl = uigridlayout(fig, [3 2]);
    gl.RowHeight   = {'fit', '1x', 'fit'};
    gl.ColumnWidth = {'1x', '1x'};

    lbl = uilabel(gl, 'WordWrap', 'on', ...
        'Text', ['Copy the parameters below into the request form at ' ...
                 'www.gacos.net, and select "Binary grid" as the file type.' ...
                 newline newline ...
                 'Then download all the .tar.gz archives into the GACOS ' ...
                 'folder (do NOT extract them) and press Continue.']);
    lbl.Layout.Row = 1;
    lbl.Layout.Column = [1 2];

    ta = uitextarea(gl, 'Value', infoText);
    ta.FontName = 'monospaced';
    ta.Layout.Row = 2;
    ta.Layout.Column = [1 2];

    btnContinue = uibutton(gl, 'Text', 'Continue', ...
        'ButtonPushedFcn', @(~,~) onChoice('Continue'));
    btnContinue.Layout.Row = 3;
    btnContinue.Layout.Column = 1;

    btnCancel = uibutton(gl, 'Text', 'Cancel', ...
        'ButtonPushedFcn', @(~,~) onChoice('Cancel'));
    btnCancel.Layout.Row = 3;
    btnCancel.Layout.Column = 2;

    uiwait(fig);

    function onChoice(c)
        choice = c;
        uiresume(fig);
        delete(fig);
    end
end

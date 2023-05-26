controladdin HTML
{
    StyleSheets = 'https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css';
    StartupScript = 'protected/control-addin/html_render/startup.js'; //Get directory address from root folder
    Scripts = 'protected/control-addin/html_render/scripts.js';//Get directory address from root folder
    HorizontalStretch = true;
    HorizontalShrink = true;

    VerticalStretch = true;
    VerticalShrink = true;
    // RequestedHeight = 100;

    event ControlReady();
    procedure Render(HTML: Text; reload: Boolean);
    event handleEditBtn(LineNo: Integer);
    event handleDelBtn(LineNo: Integer);
    procedure addButton(LineNo: Integer);
}
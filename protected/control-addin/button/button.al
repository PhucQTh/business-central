controladdin Button
{
    StyleSheets = 'https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css';
    StartupScript = 'protected/control-addin/button/startup.js'; //Get directory address from root folder
    Scripts = 'protected/control-addin/button/scripts.js';//Get directory address from root folder
    // HorizontalStretch = true;
    // HorizontalShrink = true;

    // VerticalStretch = true;
    // VerticalShrink = true;

    event ControlReady();
    procedure Render(HTML: Text; reload: Boolean);
    event ButtonAction(LineNo: Integer);
}
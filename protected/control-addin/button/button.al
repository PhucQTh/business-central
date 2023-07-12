controladdin Button
{
    StyleSheets = 'https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css';
    StartupScript = 'protected/control-addin/button/startup.js'; //Get directory address from root folder
    Scripts = 'protected/control-addin/button/scripts.js';//Get directory address from root folder
    // RequestedHeight = 50;
    // RequestedWidth = 100;
    event ControlReady();
    procedure CreateButton(buttonText: Text; className: Text);
    event ButtonAction();
    procedure Dispose();
}
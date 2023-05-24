controladdin HTML
{
    StyleSheets = 'https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css';
    StartupScript = 'HTMLRender/startup.js';
    Scripts = 'HTMLRender/scripts.js';
    HorizontalStretch = true;
    VerticalStretch = true;
    RequestedHeight = 700;
    event ControlReady();
    procedure Render(HTML: Text);
    event ButtonPressed(LineNo: Integer);
    procedure addButton(LineNo: Integer);
}
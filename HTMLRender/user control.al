controladdin HTML
{
    StartupScript = 'HTMLRender/startup.js';
    Scripts = 'HTMLRender/scripts.js';
    HorizontalStretch = true;
    VerticalStretch = true;
    RequestedHeight = 400;
    event ControlReady();
    procedure Render(HTML: Text);
}
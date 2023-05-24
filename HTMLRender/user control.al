controladdin HTML
{
    StyleSheets = 'https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css';
    StartupScript = 'HTMLRender/startup.js';
    Scripts = 'HTMLRender/scripts.js';
    HorizontalStretch = true;
    HorizontalShrink = true;

    VerticalStretch = true;
    VerticalShrink = true;
    RequestedHeight = 100;

    event ControlReady();
    procedure Render(HTML: Text; reload: Boolean);
    event handleEditBtn(LineNo: Integer);
    event handleDelBtn(LineNo: Integer);
    procedure addButton(LineNo: Integer);
}
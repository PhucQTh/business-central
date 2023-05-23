controladdin "SMT Editor"
{
    Scripts = 'https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js',
        'https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.5/umd/popper.min.js',
        'https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js',
        'https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js',
        'ControlAddin/SMTEditor/Scripts/script.js';
    StyleSheets = 'https://maxcdn.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css',
        'https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css';
    StartupScript = 'ControlAddin/SMTEditor/Scripts/Startup.js';

    RequestedHeight = 500;
    MinimumHeight = 1;
    HorizontalStretch = true;

    event ControlAddinReady();
    event onBlur(Data: Text)
    procedure GetData(Data: Text)
    procedure SetData(Data: Text)
    procedure InitializeSummerNote(Data: Text)
}
// document in https://github.com/summernote/summernote/
// https://vld-nav.com/summernote-wysiwyg-bc 
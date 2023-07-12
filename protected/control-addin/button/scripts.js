function CreateButton(buttonText, className) {
  var button = document.createElement("button");
  button.textContent = buttonText;
  button.className = className;
  button.id = "ctrl-addin-btn-attachment";
  button.onclick = () => {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ButtonAction");
  };
  HTMLContainer.appendChild(button);
  var iframe = window.frameElement;
  iframe.parentElement.style.display = "flex";
  iframe.style.removeProperty("height");
  iframe.style.removeProperty("min-height");
  iframe.style.removeProperty("max-height");
  iframe.style.removeProperty("width");
  iframe.style.removeProperty("min-width");
  iframe.style.removeProperty("max-width");
  iframe.style.height = "50px";
  iframe.style.width = iframe.contentWindow.document.body.scrollWidth;
  iframe.style.flexGrow = "1";
  iframe.style.flexShrink = "1";
  iframe.style.flexBasis = "auto";
}
function Dispose() {
  let btn = document.getElementById("ctrl-addin-btn-attachment");
  console.log(btn);
  HTMLContainer.removeChild(btn);
}

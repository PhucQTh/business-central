function Render(html, reload) {
  if (reload === true) {
    let none = document.getElementsByName("lable-for-null");
    let table = document.getElementsByTagName("table");
    if (table.length > 0) table[0].remove();
    if (none.length > 0) none[0].remove();
    HTMLContainer.insertAdjacentHTML("beforeend", html);
  } else HTMLContainer.insertAdjacentHTML("afterbegin", html);
  var iframe = window.frameElement;
  iframe.parentElement.style.display = "flex";
  iframe.style.removeProperty("height");
  iframe.style.removeProperty("min-height");
  iframe.style.removeProperty("max-height");
  iframe.style.height =
    iframe.contentWindow.document.body.scrollHeight + 50 + "px";
  iframe.style.flexGrow = "1";
  iframe.style.flexShrink = "1";
  iframe.style.flexBasis = "auto";
}
function addButton(line) {
  var placeholder = document.getElementById("btn-placerholder-" + line);
  console.log(placeholder);
  var button = document.createElement("button");
  button.textContent = "Edit";
  button.className = "btn btn-sm btn-warning";
  button.onclick = () => {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("handleEditBtn", [line]);
  };
  var delBtn = document.createElement("button");
  delBtn.textContent = "Delete";
  delBtn.className = "btn btn-sm btn-danger";
  delBtn.onclick = () => {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("handleDelBtn", [line]);
  };
  placeholder.appendChild(button);
  placeholder.appendChild(delBtn);
}

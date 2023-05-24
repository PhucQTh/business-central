function Render(html) {
  HTMLContainer.insertAdjacentHTML("beforeend", html);
}
function addButton(line) {
  var placeholder = document.getElementById("btn-placerholder-" + line);
  console.log(placeholder);
  var button = document.createElement("button");
  button.textContent = "Edit";
  button.className = "btn btn-sm btn-warning";
  button.onclick = () => {
    Microsoft.Dynamics.NAV.InvokeExtensibilityMethod("ButtonPressed", [line]);
    console.log(line);
  };
  placeholder.appendChild(button);
}

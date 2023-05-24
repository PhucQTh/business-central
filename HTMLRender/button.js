function addButton(buttonName, callText)
 
{
 
var placeholder = document.getElementById('controlAddIn');
 
var button = document.createElement('button');
 
button.textContent = buttonName;
 
button.onclick = function() {
 
Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('ButtonPressed', [callText]);
 
}
 
placeholder.appendChild(button);
 
}
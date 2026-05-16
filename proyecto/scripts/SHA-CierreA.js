// Script de Cierre Academia - SHA
var fso = new ActiveXObject("Scripting.FileSystemObject");
var net = new ActiveXObject("WScript.Network");

var usuario = net.UserName;
var equipo = net.ComputerName;
var fecha = new Date();
var rutaLog = "\\\\SHA-CD\\SHA-Gestión\\Academia\\" + usuario + ".txt";

try {
    var archivo = fso.OpenTextFile(rutaLog, 8, true);
    archivo.WriteLine("CIERRE: " + equipo + ", " + fecha);
    archivo.WriteLine("--------------------------------------------------");
    archivo.Close();
} catch(err) {}
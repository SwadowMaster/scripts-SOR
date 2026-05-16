// Script Apagado Guadalinfo
var fso = new ActiveXObject("Scripting.FileSystemObject");
var net = new ActiveXObject("WScript.Network");

var equipo = net.ComputerName;
var fecha = new Date();
var rutaLog = "\\\\SHA-CD\\SHA-Gestión\\Guadalinfo\\" + equipo + ".txt";

try {
    var archivo = fso.OpenTextFile(rutaLog, 8, true);
    archivo.WriteLine("APAGADO: " + fecha);
    archivo.WriteLine("_________________________________");
    archivo.Close();
} catch(err) {}
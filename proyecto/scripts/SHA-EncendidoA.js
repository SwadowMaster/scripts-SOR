// Script Encendido Academia
var fso = new ActiveXObject("Scripting.FileSystemObject");
var net = new ActiveXObject("WScript.Network");

var equipo = net.ComputerName; // Aquí el nombre del fichero es el equipo
var fecha = new Date();
var rutaLog = "\\\\SHA-CD\\SHA-Gestión\\Academia\\" + equipo + ".txt";

try {
    var archivo = fso.OpenTextFile(rutaLog, 8, true);
    archivo.WriteLine("ENCENDIDO: " + fecha);
    archivo.Close();
} catch(err) {}
// Script Inicio Biblioteca
var fso = new ActiveXObject("Scripting.FileSystemObject");
var net = new ActiveXObject("WScript.Network");
var shell = new ActiveXObject("WScript.Shell");

var usuario = net.UserName;
var equipo = net.ComputerName;
var fecha = new Date();
var rutaLog = "\\\\SHA-CD\\SHA-Gestión\\Biblioteca\\" + usuario + ".txt";

try {
    var archivo = fso.OpenTextFile(rutaLog, 8, true);
    archivo.WriteLine("INICIO: " + equipo + ", " + fecha);
    archivo.Close();
} catch(err) {}

// Abrir Google
shell.Run("https://www.google.es");
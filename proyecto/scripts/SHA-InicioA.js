// Script de Inicio Academia - SHA
var fso = new ActiveXObject("Scripting.FileSystemObject");
var net = new ActiveXObject("WScript.Network");
var shell = new ActiveXObject("WScript.Shell");

var usuario = net.UserName;
var equipo = net.ComputerName;
var fecha = new Date();

// Escribir en el LOG
var rutaLog = "\\\\SHA-CD\\SHA-Gestión\\Academia\\" + usuario + ".txt";

try {
    // El 8 significa "Append" true significa "Crear si no existe"
    var archivo = fso.OpenTextFile(rutaLog, 8, true); 
    archivo.WriteLine("INICIO: " + equipo + ", " + fecha);
    archivo.Close();
} catch(err) {
    // Si falla (permisos, etc) sudamos
}

shell.Popup("Hola " + usuario, 0, "Bienvenido a Academia", 64);

// 3. Preguntar si abrir Trabajos (6 = Sí, 7 = No)
var respuesta = shell.Popup("¿Desea abrir la carpeta SHA-Trabajos?", 0, "Pregunta", 36);

if (respuesta == 6) {
    shell.Run("explorer.exe \\\\SHA-CD\\SHA-Trabajos");
}
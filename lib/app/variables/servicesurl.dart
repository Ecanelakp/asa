var webservice = 'webapp.asamexico.mx';
var webserviceCFDI = 'webapp.puntodefacturacion.com';

var urllogin = new Uri.https(webservice, '/php/general/login.php');

var urlproductos = new Uri.https(webservice, 'php/general/productos.php');

var urlproyectos = new Uri.https(webservice, '/php/general/proyectos.php');

var urlclientes = new Uri.https(webservice, '/php/general/clientes.php');

var urlcontactos = new Uri.https(webservice, '/php/general/contactos.php');

var urlinteracciones =
    new Uri.https(webservice, '/php/general/interacciones.php');
var urlcompras = new Uri.https(webservice, '/php/general/compras.php');

var urlventas = new Uri.https(webservice, '/php/general/ventas.php');

var urltareas = new Uri.https(webservice, '/php/general/tareas.php');

var urlnotificaciones =
    new Uri.https(webservice, '/php/general/notificaciones.php');

var urluser = new Uri.https(webservice, 'php/general/usuarios.php');

var urlchecador = new Uri.https(webservice, '/php/general/checador.php');

var urlaltaprodcutos =
    new Uri.https(webserviceCFDI, '/php/general/alta_productos.php');
var urldocumentostimbrados =
    new Uri.https(webserviceCFDI, 'php/general/documentos_timbrados.php');
var urlaltaclientes =
    new Uri.https(webserviceCFDI, 'php/general/alta_clientes.php');

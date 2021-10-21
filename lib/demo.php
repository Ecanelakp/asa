<?php 
  $db = "dbs1602810"; //database name
  $dbuser = "dbu427720"; //database username
  $dbpassword = "170481@Ecn"; //database password
  $dbhost = "db5001960763.hosting-data.io"; //database host

  $return["error"] = false;
  $return["message"] = "";

  $link = mysqli_connect($dbhost, $dbuser, $dbpassword, $db);
  //connecting to database server

  $val = isset($_POST["referencia_cliente"]) && isset($_POST["usuario_alta"]) && isset($_POST["id_cliente"])
         && isset($_POST["comentarios"]);

  if($val){
       //checking if there is POST data

       $referencia_cliente = $_POST["referencia_cliente"];
       $usuario_alta= $_POST["usuario_alta"];
       $id_cliente = $_POST["id_cliente"];
       $comentarios= $_POST["comentarios"];
       

       //validation name if there is no error before
       if($return["error"] == false && strlen($comentarios) < 3){
           $return["error"] = true;
           $return["message"] = "Enter name up to 3 characters.";
       }

       //add more validations here

       //if there is no any error then ready for database write
       if($return["error"] == false){
            $referencia_cliente = mysqli_real_escape_string($link, $referencia_cliente);
            $usuario_alta = mysqli_real_escape_string($link, $usuario_alta);
            $id_cliente = mysqli_real_escape_string($link, $id_cliente);
            $comentarios = mysqli_real_escape_string($link, $comentarios);
            
           
            //escape inverted comma query conflict from string

            $sql = "INSERT INTO LogClientes (Referencia_cliente, Fecha_Alta, Usuario_Alta,  Id_cliente, Comentarios)  
            VALUES ('$referencia_cliente', now(),'$usuario_alta', '$id_cliente', '$comentarios')";
                                
            //student_id is with AUTO_INCREMENT, so its value will increase automatically

            $res = mysqli_query($link, $sql);
            if($res){
                //write success
            }else{
                $return["error"] = true;
                $return["message"] = "Database error";
            }
       }
  }else{
      $return["error"] = true;
      $return["message"] = 'Send all parameters.';
  }

  mysqli_close($link); //close mysqli

  header('Content-Type: application/json');
  // tell browser that its a json data
  echo json_encode($return);
  //converting array to JSON string
?>
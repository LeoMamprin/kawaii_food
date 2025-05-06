<?php
session_start();
require_once(__DIR__ . "/utils.php");

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');



$conn = dbConnect();

$method = $_SERVER['REQUEST_METHOD'];
parse_str(file_get_contents("php://input"), $putData);

switch ($method) {
  case 'GET':
    $user = intval($_GET['user_id']);
    $result = $conn->query('SELECT * FROM orders WHERE account = ' . $user);
    
  

    $rows = [];
    while ($row = $result->fetch_assoc()) {
      $rows[] = $row;
    }

    

    for( $i = 0; $i < count($rows); $i++ ) {

      $query = "SELECT SUM((p.price)*(ors.quantity)) AS total FROM orders_row ors INNER JOIN products p ON ors.product = p.id WHERE ors.orderr = " . $rows[$i]['id'];
      $result = $conn->query($query);
      $total = $result->fetch_assoc()['total'];
      $rows[$i]['total'] = $total;
    }

  
    echo json_encode($rows);
    break;

    

}

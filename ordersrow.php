<?php
session_start();
require_once(__DIR__ . "/utils.php");

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');












$conn = dbConnect();

$method = $_SERVER['REQUEST_METHOD'];
parse_str(file_get_contents("php://input"), $data);

switch ($method) {
  case "GET":
    if (isset($_GET['orderr'])) {
      $orderId = intval($_GET['orderr']);
    } else {
      echo json_encode(["error" => "Missing cart_id"]);
      exit;
    }

    $result = $conn->query('SELECT * FROM orders_row ors INNER JOIN products p ON ors.product = p.id WHERE orderr = ' . $orderId);

    $rows = [];
    while ($row = $result->fetch_assoc()) {
      $rows[] = $row;
    }

    echo json_encode($rows);
    break;







    

  case "PUT":
    $orderId = intval($data['shoppingbag']);
    $user = intval($data['user']);
    $date = date('Y-m-d');
    
    $conn->query("INSERT INTO orders (id, account, creation) VALUES (" . $orderId . ", '$user', '$date')");
    $conn->query("INSERT INTO orders_row (orderr, product, quantity) SELECT sr.shoppingbag, sr.product, sr.quantity FROM shoppingbag_row sr WHERE shoppingbag = " . $orderId);

    $conn->query("DELETE FROM shoppingbag_row WHERE shoppingbag = " . $orderId);
    $conn->query("DELETE FROM shoppingbag WHERE id = " . $orderId);


    echo json_encode(["code" => 1]);
    break;
}
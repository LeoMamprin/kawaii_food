<?php
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
    if (isset($_GET['cart_id'])) {
      $cartId = intval($_GET['cart_id']);
      $result = $conn->query("SELECT * FROM shoppingbag_row sr INNER JOIN products p ON sr.product = p.id WHERE sr.shoppingbag = $cartId");
    } else {
      echo json_encode(["error" => "Missing cart_id"]);
      exit;
    }
  
    $rows = [];
    while ($row = $result->fetch_assoc()) {
      $rows[] = $row;
    }
  
    echo json_encode($rows);
    break;

  case 'DELETE':
    $shoppingbag = intval($_GET['cart_id']);
    $user = intval($putData['user']);

    $res = $conn->query("SELECT SUM((p.price)*(sr.quantity)) AS total FROM shoppingbag_row sr INNER JOIN products p ON sr.product = p.id WHERE sr.shoppingbag = $shoppingbag");







    $money = $res->fetch_assoc()['total'];
    $conn->query("UPDATE accounts SET money = money + $money WHERE id = $user");

    $conn->query("DELETE FROM shoppingbag_row WHERE shoppingbag = $shoppingbag");
    echo json_encode(["deleted" => true]);
    break;

  case 'PUT':
    if (!isset($putData['shoppingbag'])) {
      echo json_encode(["error" => "Missing shoppingbag"]);
      exit;
    }

    $user = intval($putData['user']);
    $shoppingbag = intval($putData['shoppingbag']);

    $date = date('Y-m-d');
    $conn->query("INSERT INTO shoppingbag (id, account, creation) VALUES ('$shoppingbag', '$user', '$date')");
  

    $res = $conn->query("SELECT id FROM shoppingbag WHERE account = " . $user . " ORDER BY id DESC LIMIT 1");
    $row = $res->fetch_assoc();
    echo json_encode($row);
    break;
    


  default:
    echo json_encode(["code" => -1]);
    break;
}

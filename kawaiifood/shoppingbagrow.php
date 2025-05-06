<?php
require_once(__DIR__ . "/utils.php");

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

$conn = dbConnect();

$method = $_SERVER['REQUEST_METHOD'];
parse_str(file_get_contents("php://input"), $data);

switch ($method) {
  case 'PUT':
    $shoppingbag = intval($data['shoppingbag']);
    $product = intval($data['product']);
    $user = intval($data['user']);


    
    $query = $conn->query("SELECT money FROM accounts WHERE id=" . $user);
    $res = $query->fetch_assoc();
    $money = $res['money'];

    $query = $conn->query("SELECT price FROM products WHERE id=" . $product);
    $res = $query->fetch_assoc();
    $price = $res['price'];

    if ($money < $price) {
      echo json_encode(["code" => 0]);
      exit;
    }

    $conn->query("UPDATE accounts SET money = money - $price WHERE id = $user");

    $query = $conn->query("SELECT * FROM shoppingbag_row WHERE shoppingbag = $shoppingbag AND product = $product");
    if ($query->num_rows > 0) {
      $conn->query("UPDATE shoppingbag_row SET quantity = quantity + 1 WHERE shoppingbag = $shoppingbag AND product = $product");
    } else {
      $conn->query("INSERT INTO shoppingbag_row (shoppingbag, product, quantity) VALUES ($shoppingbag, $product, 1)");
    }
    echo json_encode(["code" => 1]);
    break;

  case 'DELETE':
    $shoppingbag = intval($data['shoppingbag']);
    $product = intval($data['product']);
    $user = intval($data['user']);

    $query = $conn->query("SELECT price FROM products WHERE id=" . $product);
    $res = $query->fetch_assoc();
    $price = $res['price'];

    $conn->query("UPDATE accounts SET money = money + $price WHERE id = $user");
    $query = $conn->query("SELECT * FROM shoppingbag_row WHERE shoppingbag = $shoppingbag AND product = $product");
    $res = $query->fetch_assoc();
    if ($res['quantity'] > 1) {
      $conn->query("UPDATE shoppingbag_row SET quantity = quantity - 1 WHERE shoppingbag = $shoppingbag AND product = $product");
    } else {
      $conn->query("DELETE FROM shoppingbag_row WHERE shoppingbag = $shoppingbag AND product = $product");
    }

    echo json_encode(["code" => 1]);
    break;

  default:
    echo json_encode(["code" => 0]);
    break;
}

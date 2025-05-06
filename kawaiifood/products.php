<?php
require_once(__DIR__ . "/utils.php");
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
header("Access-Control-Allow-Headers: X-Requested-With");

$conn = dbConnect();

if ($conn->connect_error) {
    echo json_encode(["error" => "Connection failed"]);
    exit;
}

$query = "SELECT id, name, price, file FROM products";
$res = $conn->query($query);

$list = [];
while ($row = $res->fetch_assoc()) {
    $row['image'] = $row['file'];
    $list[] = $row;
}

echo json_encode($list);
exit;
?>

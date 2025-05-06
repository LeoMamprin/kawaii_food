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
    if (isset($_GET['user_id'])){
        $res = $conn->query("SELECT money FROM accounts WHERE id = " . $_GET['user_id']);
        $row = $res->fetch_assoc();
        echo json_encode($row);
    }

    break;
}



<?php
session_start();
require_once(__DIR__ . "/utils.php");

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Headers: Content-Type');

if (!isset($_POST['username']) || !isset($_POST['password'])) {
    echo json_encode(["code" => 0, "desc" => "Malformed request"]);
    exit;
}

$username = $_POST["username"];
$password = $_POST["password"];

$conn = dbConnect();


$conn->query("UPDATE accounts SET money = money + 20 where username = '" . $username . "'");
$query = "SELECT * FROM accounts WHERE username = '" . $username . "' AND password = '" . $password . "'";
$res = $conn->query($query);
$row = $res->fetch_assoc();

if ($row == null) {
    echo json_encode(["code" => -1, "desc" => "Invalid username or password"]);
    exit;
}

$_SESSION["id"] = $row["id"];

$date = date('Y-m-d');




$res = $conn->query("SELECT * FROM shoppingbag WHERE account = " . $row['id'] . " ORDER BY id DESC LIMIT 1");
if ($res->num_rows > 0) {
    $roww = $res->fetch_assoc();
    $cart_id = (int)$roww["id"];
} else {
    $conn->query("INSERT INTO shoppingbag (id, account, creation) VALUES (NULL, {$row['id']}, '$date')");
    $cart_id = $conn->insert_id;
}


$_COOKIE["cart_id"] = $cart_id;
$_COOKIE["username"] = $username;
$_COOKIE["user_id"] = $row["id"];
$_COOKIE["money"] = $row["money"];

echo json_encode(["code" => 1, "username" => $username, "cart_id" => $cart_id, "desc" => "Login successful", "cookies" => $_COOKIE]);
exit;
?>

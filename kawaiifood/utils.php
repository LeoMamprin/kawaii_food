<?php
    function dbConnect() {
        $hostname = "localhost";
        $username = "root";
        $password = "";
        $database = "kawaii_food";

        $conn = new mysqli($hostname, $username, $password, $database);
        if($conn->connect_error) {
            die();
        }
        return $conn;
    }
?>
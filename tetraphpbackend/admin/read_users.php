<?php
include '../connection.php';
require 'auth.php';

$result = $connectNow->query("SELECT * FROM users_table ORDER BY user_id DESC");

if ($result->num_rows > 0) {
    $usersRecord = array();
    while ($row = $result->fetch_assoc()) {
        unset($row['user_password']);
        $usersRecord[] = $row;
    }
    echo json_encode(array("success" => true, "allUsersData" => $usersRecord));
} else {
    echo json_encode(array("success" => false));
}

<?php
include '../connection.php';

// Public endpoint — no admin auth required (Flutter user app reads wallet addresses)
$result = $connectNow->query("SELECT * FROM payment_methods");

if ($result->num_rows > 0) {
    $paymentMethods = array();
    while ($row = $result->fetch_assoc()) {
        $paymentMethods[] = $row;
    }
    echo json_encode(array("success" => true, "paymentMethods" => $paymentMethods));
} else {
    echo json_encode(array("success" => false));
}

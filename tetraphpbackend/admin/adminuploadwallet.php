<?php
include '../connection.php';
require 'auth.php';

$name        = $_POST['name'];
$description = $_POST['description'];
$image       = $_POST['image'];

$stmt = $connectNow->prepare("INSERT INTO payment_methods (name, description, image) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $name, $description, $image);
$result = $stmt->execute();

echo json_encode(array("success" => (bool)$result));
$stmt->close();

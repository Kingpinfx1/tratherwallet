<?php
// Include this at the top of every admin endpoint to verify the request is from an authenticated admin.
if (!isset($connectNow)) {
    include '../connection.php';
}

$adminToken = $_POST['admin_token'] ?? '';

if (empty($adminToken)) {
    echo json_encode(array("success" => false, "message" => "Unauthorized"));
    exit;
}

$stmt = $connectNow->prepare("SELECT admin_id FROM admins_table WHERE admin_token = ?");
$stmt->bind_param("s", $adminToken);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows === 0) {
    echo json_encode(array("success" => false, "message" => "Unauthorized"));
    $stmt->close();
    exit;
}

$stmt->close();

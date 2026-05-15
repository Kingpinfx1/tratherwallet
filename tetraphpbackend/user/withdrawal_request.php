<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include '../connection.php';

$user_id      = $_POST['user_id'] ?? '';
$amount       = $_POST['amount'] ?? '';
$wallet_address = $_POST['wallet_address'] ?? '';

if (empty($user_id) || empty($amount) || empty($wallet_address)) {
    echo json_encode(['success' => false, 'message' => 'Missing required fields']);
    exit;
}

$amount = floatval($amount);
if ($amount <= 0) {
    echo json_encode(['success' => false, 'message' => 'Amount must be greater than zero']);
    exit;
}

$stmt = $connectNow->prepare("INSERT INTO withdrawal_requests (user_id, amount, wallet_address, status) VALUES (?, ?, ?, 'pending')");
$stmt->bind_param("ids", $user_id, $amount, $wallet_address);

if ($stmt->execute()) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false, 'message' => 'Failed to submit withdrawal request']);
}

$stmt->close();
$connectNow->close();
?>

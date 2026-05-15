<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include '../connection.php';
require 'auth.php';

$request_id = $_POST['request_id'] ?? '';
$status     = $_POST['status'] ?? '';

if (empty($request_id) || !in_array($status, ['completed', 'rejected'])) {
    echo json_encode(['success' => false, 'message' => 'Invalid parameters']);
    exit;
}

// Update the withdrawal request status
$stmt = $connectNow->prepare("UPDATE withdrawal_requests SET status = ? WHERE id = ?");
$stmt->bind_param("si", $status, $request_id);
if (!$stmt->execute()) {
    echo json_encode(['success' => false, 'message' => 'Failed to update status']);
    exit;
}
$stmt->close();

// If approved, deduct the amount from the user's balance
if ($status === 'completed') {
    $stmt2 = $connectNow->prepare("
        UPDATE users_table SET user_balance = user_balance - (
            SELECT amount FROM withdrawal_requests WHERE id = ?
        )
        WHERE user_id = (
            SELECT user_id FROM withdrawal_requests WHERE id = ?
        )
    ");
    $stmt2->bind_param("ii", $request_id, $request_id);
    if (!$stmt2->execute()) {
        echo json_encode(['success' => false, 'message' => 'Status updated but balance deduction failed']);
        exit;
    }
    $stmt2->close();
}

echo json_encode(['success' => true]);
$connectNow->close();
?>

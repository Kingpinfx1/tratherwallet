<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include '../connection.php';

$user_id = $_POST['user_id'] ?? '';

if (empty($user_id)) {
    echo json_encode(['success' => false, 'message' => 'Missing user_id']);
    exit;
}

$stmt = $connectNow->prepare("SELECT id, amount, wallet_address, status, created_at FROM withdrawal_requests WHERE user_id = ? ORDER BY created_at DESC");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$withdrawals = [];
while ($row = $result->fetch_assoc()) {
    $withdrawals[] = $row;
}

echo json_encode(['success' => true, 'withdrawals' => $withdrawals]);

$stmt->close();
$connectNow->close();
?>

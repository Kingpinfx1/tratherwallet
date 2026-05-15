<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

include '../connection.php';
require 'auth.php';

$stmt = $connectNow->prepare("
    SELECT wr.id, wr.user_id, u.user_email, wr.amount, wr.wallet_address, wr.status, wr.created_at
    FROM withdrawal_requests wr
    JOIN users_table u ON wr.user_id = u.user_id
    ORDER BY wr.created_at DESC
");
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

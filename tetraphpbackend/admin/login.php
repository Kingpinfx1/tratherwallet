<?php
include '../connection.php';

$adminEmail    = $_POST['admin_email'];
$adminPassword = $_POST['admin_password'];

$stmt = $connectNow->prepare("SELECT * FROM admins_table WHERE admin_email = ?");
$stmt->bind_param("s", $adminEmail);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $admin = $result->fetch_assoc();
    $storedHash   = $admin['admin_password'];
    $authenticated = false;

    if (password_verify($adminPassword, $storedHash)) {
        $authenticated = true;
    } elseif ($storedHash === $adminPassword || $storedHash === md5($adminPassword)) {
        // Legacy plain text or MD5 — migrate to bcrypt
        $newHash = password_hash($adminPassword, PASSWORD_BCRYPT);
        $update  = $connectNow->prepare("UPDATE admins_table SET admin_password = ? WHERE admin_id = ?");
        $update->bind_param("si", $newHash, $admin['admin_id']);
        $update->execute();
        $update->close();
        $authenticated = true;
    }

    if ($authenticated) {
        // Generate a session token and store it
        $token  = bin2hex(random_bytes(32));
        $update = $connectNow->prepare("UPDATE admins_table SET admin_token = ? WHERE admin_id = ?");
        $update->bind_param("si", $token, $admin['admin_id']);
        $update->execute();
        $update->close();

        unset($admin['admin_password'], $admin['admin_token']);
        echo json_encode(array("success" => true, "adminData" => $admin, "adminToken" => $token));
    } else {
        echo json_encode(array("success" => false));
    }
} else {
    echo json_encode(array("success" => false));
}

$stmt->close();

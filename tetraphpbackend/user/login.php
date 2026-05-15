<?php
include '../connection.php';

$userEmail    = $_POST['user_email'];
$userPassword = $_POST['user_password'];

// Fetch user by email only first
$stmt = $connectNow->prepare("SELECT * FROM users_table WHERE user_email = ?");
$stmt->bind_param("s", $userEmail);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    $storedHash = $user['user_password'];
    $authenticated = false;

    if (password_verify($userPassword, $storedHash)) {
        // bcrypt match
        $authenticated = true;
    } elseif ($storedHash === md5($userPassword)) {
        // Legacy MD5 match — migrate to bcrypt transparently
        $newHash = password_hash($userPassword, PASSWORD_BCRYPT);
        $update = $connectNow->prepare("UPDATE users_table SET user_password = ? WHERE user_id = ?");
        $update->bind_param("si", $newHash, $user['user_id']);
        $update->execute();
        $update->close();
        $authenticated = true;
    }

    if ($authenticated) {
        echo json_encode(array("success" => true, "userData" => $user));
    } else {
        echo json_encode(array("success" => false));
    }
} else {
    echo json_encode(array("success" => false));
}

$stmt->close();

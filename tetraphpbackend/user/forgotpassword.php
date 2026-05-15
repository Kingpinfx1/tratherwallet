<?php
include '../connection.php';

function generateToken($length = 32) {
    return bin2hex(random_bytes($length));
}

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['user_email'])) {
    $email = $_POST['user_email'];

    $stmt = $connectNow->prepare("SELECT user_id FROM users_table WHERE user_email = ?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {
        $stmt->close();

        $resetToken = generateToken();

        $update = $connectNow->prepare("UPDATE users_table SET reset_token = ? WHERE user_email = ?");
        $update->bind_param("ss", $resetToken, $email);

        if ($update->execute()) {
            $resetLink = "https://api.tratherwallet.top/reset_password.php?token=$resetToken";
            $subject   = "TratherWallet — Password Reset";
            $message   = "Click the link below to reset your password:\n\n$resetLink\n\nIf you did not request this, ignore this email.";
            $headers   = "From: noreply@tratherwallet.top";

            if (mail($email, $subject, $message, $headers)) {
                echo json_encode(array("success" => true, "message" => "Reset email sent successfully"));
            } else {
                echo json_encode(array("success" => false, "message" => "Failed to send reset email"));
            }
        } else {
            echo json_encode(array("success" => false, "message" => "Failed to generate reset token"));
        }

        $update->close();
    } else {
        $stmt->close();
        // Return success even when email not found to avoid user enumeration
        echo json_encode(array("success" => true, "message" => "If this email exists, a reset link has been sent"));
    }
} else {
    echo json_encode(array("success" => false, "message" => "Invalid request"));
}

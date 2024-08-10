<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $roll_number = $_POST['roll_number'];
    $mess = $_POST['mess'];

    // Replace with actual logic to determine mess based on roll number
    // For simplicity, we'll use a static mapping
    $mess_load_balancer = $mess . '.local';

    header('Location: http://' . $mess_load_balancer);
    exit;
}
?>
<form method="post">
    <label for="roll_number">Roll Number:</label>
    <input type="text" id="roll_number" name="roll_number"><br><br>
    <label for="mess">Mess:</label>
    <select id="mess" name="mess">
        <option value="mess1">Mess 1</option>
        <option value="mess2">Mess 2</option>
        <option value="mess3">Mess 3</option>
    </select><br><br>
    <input type="submit" value="Submit">
</form>

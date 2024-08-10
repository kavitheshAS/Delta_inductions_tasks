<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $roll_number = htmlspecialchars($_POST['roll_number']);
    $mess = htmlspecialchars($_POST['mess']);

    // Redirect based on the selected mess
    if ($mess === 'mess1') {
        header("Location: http://mess1.local");
    } elseif ($mess === 'mess2') {
        header("Location: http://mess2.local");
    } elseif ($mess === 'mess3') {
        header("Location: http://mess3.local");
    } else {
        echo "Invalid mess selection.";
    }
    exit();
}
?>
<form method="POST">
    Roll Number: <input type="text" name="roll_number" required><br>
    Mess: 
    <select name="mess">
        <option value="mess1">Mess 1</option>
        <option value="mess2">Mess 2</option>
        <option value="mess3">Mess 3</option>
    </select><br>
    <input type="submit" value="Submit">
</form>

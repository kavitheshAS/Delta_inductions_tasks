#!/bin/bash

mkdir "/home/core/quizzes"
mkdir "/home/core/quiz_answers"
mkdir "/home/core/.quiz_notified"
# Directory to store quizzes and answers
QUIZ_DIR="/home/core/quizzes"
ANSWER_DIR="/home/core/quiz_answers"
NOTIFIED_FLAG="/home/core/.quiz_notified"

# Function to create a quiz
create_quiz() {
    echo "Creating a new quiz..."
    echo "Enter the quiz name: "
    read quiz_name
    quiz_file="$QUIZ_DIR/$quiz_name"

    echo "Enter the number of questions: "
    read num_questions

    echo "Creating quiz '$quiz_name' with $num_questions questions..."

    mkdir -p "$QUIZ_DIR"

    for ((i = 1; i <= num_questions; i++)); do
        echo "Enter question $i: "
        read question
        echo "Q$i: $question" >> "$quiz_file"
    done

    echo "Quiz '$quiz_name' created successfully."
}

# Function to answer a quiz
answer_quiz() {
    echo "Available quizzes:"
    ls "$QUIZ_DIR"

    echo "Enter the quiz name you want to answer: "
    read quiz_name
    quiz_file="$QUIZ_DIR/$quiz_name"

    if [ ! -f "$quiz_file" ]; then
        echo "Quiz '$quiz_name' does not exist."
        exit 1
    fi:

    answer_file="$ANSWER_DIR/$quiz_name"

    mkdir -p "$ANSWER_DIR"

    while IFS= read -r line; do
        echo "$line"
        echo "Your answer: "
        read answer
        echo "$line" >> "$answer_file"
        echo "Answer: $answer" >> "$answer_file"
    done < "$quiz_file"

    echo "Your answers have been saved to '$answer_file'."
}

# Function to notify mentees of new quizzes
notify_mentee() {
    if [ -d "$QUIZ_DIR" ]; then
        for quiz in "$QUIZ_DIR"/*; do
            if [ ! -f "$NOTIFIED_FLAG/$(basename $quiz)" ]; then
                echo "New quiz available: $(basename $quiz)"
                mkdir -p "$NOTIFIED_FLAG"
                touch "$NOTIFIED_FLAG/$(basename $quiz)"
            fi
        done
    fi
}

# Function to add the script to .bashrc
add_to_bashrc() {
    script_path=$(realpath "$0")
    bashrc="/home/core/.bashrc"
    if ! grep -q "$script_path" "$bashrc"; then
        echo "Adding script to $bashrc..."
        echo "$script_path" >> "$bashrc"
    fi
}

# Main script
if [ "$1" == "--notify" ]; then
    notify_mentee
    exit 0
fi

echo "Are you a mentor or a mentee? (Enter 'mentor' or 'mentee'): "
read user_role

if [ "$user_role" == "mentor" ]; then
    create_quiz
elif [ "$user_role" == "mentee" ]; then
    notify_mentee
    answer_quiz
else
    echo "Invalid role. Please enter 'mentor' or 'mentee'."
    exit 1
fi

# Ensure the script is added to .bashrc for future logins
add_to_bashrc


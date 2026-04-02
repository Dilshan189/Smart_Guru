# SmartIQ — API Reference

## Overview

|                  |                                                                                                |
| ---------------- | ---------------------------------------------------------------------------------------------- |
| **Base URL**     | `http://localhost/commerceAPP/index.php/API/`                                                  |
| **Method**       | `POST` for all endpoints                                                                       |
| **Content-Type** | `application/json` (unless noted as multipart/form-data)                                       |
| **Auth Header**  | `token: <api_token>` (required for all endpoints except `register`, `login`, `validateCoupon`) |

### Response Envelope

```json
{ "status": "S100", "data": { ... } }   // success
{ "status": "E100", "data": "message" } // error / invalid token
```

---

## Table of Contents

1. [Auth — Register & Login](#1-auth)
2. [Category (Word Module)](#2-category)
3. [Level (Word Module)](#3-level)
4. [Paragraph](#4-paragraph)
5. [Question (Word Module)](#5-question)
6. [Question Reports](#6-question-reports)
7. [Subject Module](#7-subject-module)
   - [Subject](#71-subject)
   - [Subject Lesson](#72-subject-lesson)
   - [Lesson Level](#73-lesson-level)
   - [Lesson Question](#74-lesson-question)
   - [Paper (Pass / Model)](#75-paper)
   - [Paper Question](#76-paper-question)
   - [Short Note](#77-short-note)
   - [Mobile Aggregate](#78-mobile-aggregate)
8. [User Profile & Points](#8-user-profile--points)
9. [Leaderboard](#9-leaderboard)
10. [Coupon](#10-coupon)
11. [Payment](#11-payment)
12. [Premium Status](#12-premium-status)
13. [Dashboard](#13-dashboard)

---

## 1. Auth

### `register`

No token required.

**Request:**

```json
{
  "name": "John Doe",
  "phone": "0771234567",
  "coupon_code": "PROMO2026"
}
```

| Field         | Type   | Required | Description                            |
| ------------- | ------ | -------- | -------------------------------------- |
| `name`        | string | **Yes**  | User full name                         |
| `phone`       | string | **Yes**  | Unique phone number                    |
| `coupon_code` | string | No       | Grant premium on registration if valid |

**Success Response:**

```json
{
  "status": "S100",
  "data": {
    "message": "Registration successful",
    "user_id": 5,
    "name": "John Doe",
    "phone": "0771234567",
    "is_premium": 1,
    "coupon_code": "PROMO2026",
    "amount": 1500,
    "token": "abc123token"
  }
}
```

---

### `login`

No token required.

**Request:**

```json
{ "phone": "0771234567" }
```

| Field   | Type   | Required |
| ------- | ------ | -------- |
| `phone` | string | **Yes**  |

**Success Response:**

```json
{
  "status": "S100",
  "data": {
    "message": "Login successful",
    "user_id": 5,
    "name": "John Doe",
    "phone": "0771234567",
    "is_premium": 1,
    "coupon_code": "PROMO2026",
    "amount": 1500,
    "token": "abc123token"
  }
}
```

---

## 2. Category

### `createCategory`

**Request:**

```json
{
  "module": "word",
  "name": "Animals",
  "status": "active",
  "is_premium": 0
}
```

| Field        | Type   | Required | Notes                      |
| ------------ | ------ | -------- | -------------------------- |
| `module`     | string | **Yes**  | e.g. `"word"`              |
| `name`       | string | **Yes**  |                            |
| `status`     | string | **Yes**  | `"active"` \| `"inactive"` |
| `is_premium` | int    | **Yes**  | `0` = Free, `1` = Paid     |

**Success Response:**

```json
{
  "status": "S100",
  "data": { "message": "Category created successfully", "category_id": 3 }
}
```

---

### `getCategory`

**Request (all optional):**

```json
{
  "category_id": 3,
  "module": "word",
  "status": "active",
  "is_premium": 0
}
```

**Success Response:**

```json
{
  "status": "S100",
  "data": [
    {
      "id": 3,
      "module": "word",
      "name": "Animals",
      "status": "active",
      "is_premium": 0,
      "datetime": "2026-01-01 10:00:00"
    }
  ]
}
```

---

### `updateCategory`

**Request:**

```json
{
  "category_id": 3,
  "name": "Wild Animals",
  "status": "active",
  "is_premium": 1
}
```

| Field                                    | Required     |
| ---------------------------------------- | ------------ |
| `category_id`                            | **Yes**      |
| `module`, `name`, `status`, `is_premium` | At least one |

---

### `deleteCategory`

**Request:**

```json
{ "category_id": 3 }
```

---

## 3. Level

### `createLevel`

**Request:**

```json
{
  "category_id": 3,
  "level_name": "Easy",
  "is_premium": 0,
  "question_type": "text"
}
```

| Field           | Type   | Required |
| --------------- | ------ | -------- |
| `category_id`   | int    | **Yes**  |
| `level_name`    | string | **Yes**  |
| `is_premium`    | int    | **Yes**  |
| `question_type` | string | No       |

**Success Response:**

```json
{
  "status": "S100",
  "data": { "message": "Level created successfully", "level_id": 7 }
}
```

---

### `getLevel`

**Request (all optional):**

```json
{ "level_id": 7, "category_id": 3, "is_premium": 0, "question_type": "text" }
```

---

### `updateLevel`

**Request:**

```json
{ "level_id": 7, "level_name": "Medium", "is_premium": 1 }
```

| Field                                                      | Required     |
| ---------------------------------------------------------- | ------------ |
| `level_id`                                                 | **Yes**      |
| `category_id`, `level_name`, `is_premium`, `question_type` | At least one |

---

### `deleteLevel`

**Request:**

```json
{ "level_id": 7 }
```

---

## 4. Paragraph

### `createParagraph`

**Request:**

```json
{
  "cat_id": 3,
  "level_id": 7,
  "paragraph_text": "The lion is the king of the jungle...",
  "status": 1
}
```

| Field                                  | Required         |
| -------------------------------------- | ---------------- |
| `cat_id`, `level_id`, `paragraph_text` | **Yes**          |
| `status`                               | No (default `1`) |

**Success Response:**

```json
{
  "status": "S100",
  "data": { "message": "Paragraph created successfully", "paragraph_id": 2 }
}
```

---

### `getParagraph`

**Request (all optional):**

```json
{ "paragraph_id": 2, "cat_id": 3, "level_id": 7, "status": 1 }
```

---

### `updateParagraph`

**Request:**

```json
{ "paragraph_id": 2, "paragraph_text": "Updated text...", "status": 1 }
```

| Field          | Required |
| -------------- | -------- |
| `paragraph_id` | **Yes**  |

---

### `deleteParagraph`

**Request:**

```json
{ "paragraph_id": 2 }
```

---

## 5. Question (Word Module)

### `createQuestion`

**Request:**

```json
{
  "cat_id": 3,
  "level_id": 7,
  "paragraph_id": 2,
  "question": "What sound does a lion make?",
  "question_img": "https://cdn.example.com/lion.jpg",
  "ans_01": "Roar",
  "ans_01_img": "",
  "ans_02": "Bark",
  "ans_03": "Meow",
  "ans_04": "Hiss",
  "ans_05": "Growl",
  "current_ans": 1,
  "example_text": "Lions are apex predators.",
  "example_img": "https://cdn.example.com/example.jpg",
  "example_audio": "https://cdn.example.com/roar.mp3"
}
```

| Field                        | Type   | Required               | Notes                   |
| ---------------------------- | ------ | ---------------------- | ----------------------- |
| `cat_id`                     | int    | **Yes**                |                         |
| `level_id`                   | int    | **Yes**                |                         |
| `question` OR `question_img` | string | **Yes** (at least one) |                         |
| `ans_01` .. `ans_04`         | string | **Yes** (at least 2)   | text or `*_img` variant |
| `ans_01_img` .. `ans_04_img` | string | No                     | image URL per answer    |
| `ans_05` / `ans_05_img`      | string | No                     | optional 5th answer     |
| `current_ans`                | int    | **Yes**                | `1`–`5`                 |
| `paragraph_id`               | int    | No                     | link to paragraph       |
| `example_text`               | string | No                     |                         |
| `example_img`                | string | No                     |                         |
| `example_audio`              | string | No                     |                         |

`question_type` is auto-derived: `"text"` / `"image"` / `"both"`.

**Success Response:**

```json
{
  "status": "S100",
  "data": { "message": "Question created successfully", "question_id": 42 }
}
```

---

### `updateQuestion`

Same fields as `createQuestion` plus:
| Field | Required |
|---|---|
| `question_id` | **Yes** |
| `cat_id`, `level_id`, `current_ans` | **Yes** |

---

### `deleteQuestion`

**Request:**

```json
{ "question_id": 42 }
```

---

### `getQuestion`

**Request (all optional):**

```json
{ "question_id": 42, "cat_id": 3, "level_id": 7 }
```

**Success Response (when `level_id` provided):**

```json
{
  "status": "S100",
  "data": {
    "has_paragraph": true,
    "paragraphs": [ { "id": 2, "paragraph_text": "...", ... } ],
    "questions": [ { "id": 42, "question": "...", "ans_01": "Roar", "current_ans": 1, "example_text": "...", ... } ]
  }
}
```

---

## 6. Question Reports

### `reportQuestion`

**Request:**

```json
{ "question_id": 42, "reason": "Wrong answer marked as correct" }
```

| Field                   | Required |
| ----------------------- | -------- |
| `question_id`, `reason` | **Yes**  |

**Success Response:**

```json
{
  "status": "S100",
  "data": { "message": "Question reported successfully", "report_id": 11 }
}
```

---

### `getQuestionReports`

**Request (all optional):**

```json
{ "report_id": 11, "question_id": 42 }
```

**Success Response:**

```json
{
  "status": "S100",
  "data": [
    {
      "id": 11,
      "question_id": 42,
      "user_id": 5,
      "reason": "Wrong answer",
      "reported_at": "2026-03-01 12:00:00"
    }
  ]
}
```

---

## 7. Subject Module

---

### 7.1 Subject

#### `createSubject`

**Request:**

```json
{ "name": "Mathematics", "description": "Grade 10 Maths", "status": "active" }
```

| Field                   | Required |
| ----------------------- | -------- |
| `name`                  | **Yes**  |
| `description`, `status` | No       |

**Success Response:**

```json
{
  "status": "S100",
  "data": { "message": "Subject created successfully", "subject_id": 1 }
}
```

---

#### `getSubject`

**Request (all optional):**

```json
{ "subject_id": 1, "status": "active" }
```

**Success Response:**

```json
{
  "status": "S100",
  "data": [
    {
      "id": 1,
      "name": "Mathematics",
      "description": "Grade 10 Maths",
      "status": "active",
      "datetime": "2026-01-01 10:00:00",
      "total_lesson_questions": 45,
      "total_paper_questions": 30,
      "total_lessons": 5,
      "total_papers": 3
    }
  ]
}
```

---

#### `updateSubject`

**Request:**

```json
{ "subject_id": 1, "name": "Advanced Mathematics", "status": "active" }
```

| Field        | Required |
| ------------ | -------- |
| `subject_id` | **Yes**  |

---

#### `deleteSubject`

**Request:**

```json
{ "subject_id": 1 }
```

---

### 7.2 Subject Lesson

#### `createSubjectLesson`

**Request:**

```json
{
  "subject_id": 1,
  "title": "Algebra",
  "description": "Introduction to Algebra",
  "status": "active"
}
```

| Field                   | Required |
| ----------------------- | -------- |
| `subject_id`, `title`   | **Yes**  |
| `description`, `status` | No       |

**Success Response:**

```json
{
  "status": "S100",
  "data": { "message": "Lesson created successfully", "lesson_id": 3 }
}
```

---

#### `getSubjectLesson`

**Request (all optional):**

```json
{ "lesson_id": 3, "subject_id": 1, "status": "active" }
```

**Success Response:**

```json
{
  "status": "S100",
  "data": [
    {
      "id": 3,
      "subject_id": 1,
      "subject_name": "Mathematics",
      "title": "Algebra",
      "description": "...",
      "status": "active",
      "datetime": "..."
    }
  ]
}
```

---

#### `updateSubjectLesson`

**Request:**

```json
{ "lesson_id": 3, "title": "Linear Algebra", "status": "active" }
```

| Field       | Required |
| ----------- | -------- |
| `lesson_id` | **Yes**  |

---

#### `deleteSubjectLesson`

**Request:**

```json
{ "lesson_id": 3 }
```

---

### 7.3 Lesson Level

#### `createSubjectLessonLevel`

**Request:**

```json
{ "lesson_id": 3, "level_name": "Easy", "is_premium": 0, "status": "active" }
```

| Field                                   | Required |
| --------------------------------------- | -------- |
| `lesson_id`, `level_name`, `is_premium` | **Yes**  |
| `status`                                | No       |

**Success Response:**

```json
{
  "status": "S100",
  "data": { "message": "Lesson level created successfully", "level_id": 5 }
}
```

---

#### `getSubjectLessonLevel`

**Request (all optional):**

```json
{ "level_id": 5, "lesson_id": 3, "subject_id": 1, "status": "active" }
```

**Success Response:**

```json
{
  "status": "S100",
  "data": [
    {
      "id": 5,
      "lesson_id": 3,
      "lesson_title": "Algebra",
      "subject_name": "Mathematics",
      "level_name": "Easy",
      "is_premium": 0,
      "status": "active",
      "datetime": "..."
    }
  ]
}
```

---

#### `updateSubjectLessonLevel`

**Request:**

```json
{ "level_id": 5, "level_name": "Medium", "is_premium": 1 }
```

| Field      | Required |
| ---------- | -------- |
| `level_id` | **Yes**  |

---

#### `deleteSubjectLessonLevel`

**Request:**

```json
{ "level_id": 5 }
```

---

### 7.4 Lesson Question

#### `createSubjectLessonQuestion`

**Request:**

```json
{
  "subject_id": 1,
  "lesson_id": 3,
  "level_id": 5,
  "question": "Solve: 2x + 3 = 7",
  "question_img": "",
  "ans_01": "x = 1",
  "ans_02": "x = 2",
  "ans_03": "x = 3",
  "ans_04": "x = 4",
  "ans_05": "x = 5",
  "current_ans": 2,
  "example_text": "Move 3 to the right side.",
  "example_img": "",
  "example_audio": ""
}
```

| Field                                          | Required               | Notes                |
| ---------------------------------------------- | ---------------------- | -------------------- |
| `subject_id`, `lesson_id`, `level_id`          | **Yes**                |                      |
| `question` OR `question_img`                   | **Yes** (at least one) |                      |
| `ans_01`..`ans_04`                             | **Yes** (at least 2)   |                      |
| `ans_05`                                       | No                     | optional 5th answer  |
| `ans_01_img`..`ans_05_img`                     | No                     | image URL per answer |
| `current_ans`                                  | **Yes**                | `1`–`5`              |
| `example_text`, `example_img`, `example_audio` | No                     |                      |

**Success Response:**

```json
{
  "status": "S100",
  "data": {
    "message": "Lesson question created successfully",
    "question_id": 10
  }
}
```

---

#### `getSubjectLessonQuestion`

**Request (all optional):**

```json
{ "question_id": 10, "subject_id": 1, "lesson_id": 3, "level_id": 5 }
```

**Success Response:**

```json
{
  "status": "S100",
  "data": [
    {
      "id": 10,
      "subject_id": 1,
      "subject_name": "Mathematics",
      "lesson_id": 3,
      "lesson_title": "Algebra",
      "level_id": 5,
      "level_name": "Easy",
      "question": "Solve: 2x + 3 = 7",
      "question_img": null,
      "ans_01": "x = 1",
      "ans_02": "x = 2",
      "ans_03": "x = 3",
      "ans_04": "x = 4",
      "ans_05": "x = 5",
      "ans_01_img": null,
      "current_ans": 2,
      "example_text": "Move 3 to the right side.",
      "example_img": null,
      "example_audio": null,
      "datetime": "..."
    }
  ]
}
```

---

#### `updateSubjectLessonQuestion`

Same fields as `createSubjectLessonQuestion` plus:
| Field | Required |
|---|---|
| `question_id` | **Yes** |

---

#### `deleteSubjectLessonQuestion`

**Request:**

```json
{ "question_id": 10 }
```

---

### 7.5 Paper

`paper_type` values: `"pass_paper"` | `"model_paper"`

#### `createSubjectPaper`

**Request:**

```json
{
  "subject_id": 1,
  "paper_type": "model_paper",
  "title": "2024 Model Paper 1",
  "end_time": "2026-12-31 23:59:59",
  "description": "Annual model paper",
  "status": "active"
}
```

| Field                                           | Required |
| ----------------------------------------------- | -------- |
| `subject_id`, `paper_type`, `title`, `end_time` | **Yes**  |
| `description`, `status`                         | No       |

**Success Response:**

```json
{
  "status": "S100",
  "data": { "message": "Paper created successfully", "paper_id": 2 }
}
```

---

#### `getSubjectPaper`

**Request (all optional):**

```json
{
  "paper_id": 2,
  "subject_id": 1,
  "paper_type": "model_paper",
  "status": "active"
}
```

**Success Response:**

```json
{
  "status": "S100",
  "data": [
    {
      "id": 2,
      "subject_id": 1,
      "subject_name": "Mathematics",
      "paper_type": "model_paper",
      "title": "2024 Model Paper 1",
      "end_time": "2026-12-31 23:59:59",
      "status": "active",
      "datetime": "..."
    }
  ]
}
```

---

#### `updateSubjectPaper`

**Request:**

```json
{ "paper_id": 2, "title": "2025 Model Paper 1", "status": "active" }
```

| Field      | Required |
| ---------- | -------- |
| `paper_id` | **Yes**  |

---

#### `deleteSubjectPaper`

**Request:**

```json
{ "paper_id": 2 }
```

---

### 7.6 Paper Question

#### `createSubjectPaperQuestion`

**Request:**

```json
{
  "paper_id": 2,
  "question": "What is the value of π?",
  "question_img": "",
  "ans_01": "3.14",
  "ans_02": "2.71",
  "ans_03": "1.41",
  "ans_04": "1.73",
  "ans_05": "",
  "current_ans": 1,
  "example_text": "Pi is the ratio of circumference to diameter.",
  "example_img": "",
  "example_audio": "",
  "sort_order": 1
}
```

| Field                                          | Required               |
| ---------------------------------------------- | ---------------------- |
| `paper_id`, `current_ans`                      | **Yes**                |
| `question` OR `question_img`                   | **Yes** (at least one) |
| `ans_01`..`ans_04`                             | **Yes** (at least 2)   |
| `ans_05`                                       | No                     |
| `example_text`, `example_img`, `example_audio` | No                     |
| `sort_order`                                   | No                     |

**Success Response:**

```json
{
  "status": "S100",
  "data": {
    "message": "Paper question created successfully",
    "question_id": 20
  }
}
```

---

#### `getSubjectPaperQuestion`

**Request (all optional):**

```json
{
  "question_id": 20,
  "paper_id": 2,
  "subject_id": 1,
  "paper_type": "model_paper"
}
```

**Success Response:**

```json
{
  "status": "S100",
  "data": [
    {
      "id": 20,
      "paper_id": 2,
      "paper_title": "2024 Model Paper 1",
      "question": "What is the value of π?",
      "ans_01": "3.14",
      "ans_02": "2.71",
      "ans_03": "1.41",
      "ans_04": "1.73",
      "ans_05": null,
      "current_ans": 1,
      "example_text": "Pi is the ratio...",
      "example_img": null,
      "example_audio": null
    }
  ]
}
```

---

#### `updateSubjectPaperQuestion`

Same fields as `createSubjectPaperQuestion` plus:
| Field | Required |
|---|---|
| `question_id` | **Yes** |

---

#### `deleteSubjectPaperQuestion`

**Request:**

```json
{ "question_id": 20 }
```

---

### 7.7 Short Note

#### `createSubjectShortNote`

**Content-Type:** `multipart/form-data` (for file upload) or `application/json`

**Form-data fields:**
| Field | Required | Notes |
|---|---|---|
| `subject_id` | **Yes** | |
| `title` | **Yes** | |
| `page_count` | **Yes** | |
| `pdf_file` | **Yes** | PDF file upload |
| `cover_image` | **Yes** | jpg/jpeg/png/webp |
| `description` | No | |
| `status` | No | default `"active"` |

**JSON body (URL-based):**

```json
{
  "subject_id": 1,
  "title": "Algebra Notes Chapter 1",
  "description": "Complete notes for chapter 1",
  "page_count": 12,
  "pdf_file": "https://cdn.example.com/notes.pdf",
  "cover_image": "https://cdn.example.com/cover.jpg",
  "status": "active"
}
```

**Success Response:**

```json
{
  "status": "S100",
  "data": { "message": "Short note created successfully", "short_note_id": 4 }
}
```

---

#### `getSubjectShortNote`

**Request (all optional):**

```json
{ "short_note_id": 4, "subject_id": 1, "status": "active" }
```

**Success Response:**

```json
{
  "status": "S100",
  "data": [
    {
      "id": 4,
      "subject_id": 1,
      "subject_name": "Mathematics",
      "title": "Algebra Notes Chapter 1",
      "page_count": 12,
      "pdf_file": "upload/short_notes/pdf/file.pdf",
      "cover_image": "upload/short_notes/cover/img.jpg",
      "status": "active"
    }
  ]
}
```

---

#### `updateSubjectShortNote`

**Content-Type:** `multipart/form-data` or `application/json`

| Field           | Required     |
| --------------- | ------------ |
| `short_note_id` | **Yes**      |
| Any other field | At least one |

---

#### `deleteSubjectShortNote`

**Request:**

```json
{ "short_note_id": 4 }
```

---

### 7.8 Mobile Aggregate

#### `getSubjectModuleMobile`

Returns the entire subject module in one call — all subjects with their lessons, levels, questions, papers, and short notes.

**Request (all optional):**

```json
{ "subject_id": 1 }
```

Omit `subject_id` to get all active subjects.

**Success Response:**

```json
{
  "status": "S100",
  "data": [
    {
      "subject": { "id": 1, "name": "Mathematics", "status": "active", ... },
      "types": {
        "question_of_lesson": {
          "lessons": [ { "id": 3, "title": "Algebra", ... } ],
          "levels":  [ { "id": 5, "level_name": "Easy", "is_premium": 0, ... } ],
          "questions": [ { "id": 10, "question": "Solve: 2x+3=7", "current_ans": 2, ... } ]
        },
        "question_of_pass_papers": {
          "papers": [ { "id": 1, "paper_type": "pass_paper", "title": "2023 Paper", ... } ],
          "questions": [ { "id": 15, "question": "...", "current_ans": 3, ... } ]
        },
        "model_question_papers": {
          "papers": [ { "id": 2, "paper_type": "model_paper", "title": "2024 Model Paper 1", ... } ],
          "questions": [ { "id": 20, "question": "What is π?", "current_ans": 1, ... } ]
        },
        "short_notes": [ { "id": 4, "title": "Algebra Notes Chapter 1", "pdf_file": "upload/...", ... } ],
        "video_lessons": { "coming_soon": true, "message": "Video lessons will be available soon" }
      }
    }
  ]
}
```

---

## 8. User Profile & Points

### `profile`

**Request:**

```json
{ "user_id": 5 }
```

**Success Response:**

```json
{
  "status": "S100",
  "data": { "user_id": 5, "name": "John Doe", "rank": 3, "points": 1200 }
}
```

---

### `getUserPoints`

**Request:**

```json
{ "user_id": 5 }
```

**Success Response:**

```json
{
  "status": "S100",
  "data": {
    "user_id": 5,
    "total_points": 1200,
    "created_at": "2026-01-01 10:00:00",
    "updated_at": "2026-03-30 08:00:00"
  }
}
```

---

### `updateUserPoint`

**Request:**

```json
{ "user_id": 5, "point": 50, "type": 1 }
```

| Field     | Type | Required | Notes                   |
| --------- | ---- | -------- | ----------------------- |
| `user_id` | int  | **Yes**  |                         |
| `point`   | int  | **Yes**  | Must be positive        |
| `type`    | int  | **Yes**  | `1` = add, `0` = deduct |

**Success Response:**

```json
{
  "status": "S100",
  "data": {
    "message": "Points updated",
    "user_id": 5,
    "current_points": 1250,
    "action": "added",
    "points_changed": 50
  }
}
```

---

## 9. Leaderboard

### `getLeaderboard`

**Request:**

```json
{ "user_id": 5 }
```

**Success Response:**

```json
{
  "status": "S100",
  "data": {
    "leaderboard": [
      { "rank": 1, "user_id": 2, "name": "Alice", "points": 3400 },
      { "rank": 2, "user_id": 7, "name": "Bob", "points": 2900 }
    ],
    "userRank": { "rank": 3, "user_id": 5, "name": "John Doe", "points": 1250 }
  }
}
```

--- stop xxxxxxxxxxxxxxxxxxxxxx

## 10. Coupon

### `validateCoupon`

No token required.

**Request:**

```json
{ "coupon_code": "PROMO2026" }
```

**Success Response:**

```json
{
  "status": "S100",
  "data": {
    "message": "Coupon is valid",
    "coupon_code": "PROMO2026",
    "coupon_type": "premium",
    "amount": 1500,
    "discount_days": 365,
    "available_usage": 10
  }
}
```

---

## 11. Payment

### `createPayment`

#### Bank Transfer (multipart/form-data)

| Field            | Required | Notes                                   |
| ---------------- | -------- | --------------------------------------- |
| `user_id`        | **Yes**  |                                         |
| `payment_method` | **Yes**  | `"bank_transfer"`                       |
| `amount`         | **Yes**  |                                         |
| `premium_days`   | **Yes**  |                                         |
| `bank_slip`      | **Yes**  | File upload (jpg/jpeg/png/pdf, max 5MB) |
| `transaction_id` | No       |                                         |
| `notes`          | No       |                                         |

#### Online Payment (application/json)

```json
{
  "user_id": 5,
  "payment_method": "online",
  "amount": 1500,
  "premium_days": 365,
  "transaction_id": "TXN20260101ABC",
  "notes": "Annual plan"
}
```

Online payments are **auto-approved** and premium activated immediately.

**Success Response:**

```json
{
  "status": "S100",
  "data": {
    "message": "Payment submitted for verification",
    "payment_id": 8,
    "payment_status": "pending"
  }
}
```

---

### `getPayment`

**Request (all optional):**

```json
{
  "payment_id": 8,
  "user_id": 5,
  "payment_status": "pending",
  "payment_method": "bank_transfer"
}
```

---

### `verifyPayment`

Admin use. Updates bank transfer payment status.

**Request:**

```json
{
  "payment_id": 8,
  "status": "verified",
  "verified_by": 1,
  "notes": "Slip confirmed"
}
```

| Field                                 | Required | Notes                        |
| ------------------------------------- | -------- | ---------------------------- |
| `payment_id`, `status`, `verified_by` | **Yes**  |                              |
| `status`                              | **Yes**  | `"verified"` \| `"rejected"` |
| `notes`                               | No       |                              |

**Success Response:**

```json
{
  "status": "S100",
  "data": { "message": "Payment verified and premium activated" }
}
```

---

## 12. Premium Status

### `checkPremiumStatus`

**Request:**

```json
{ "user_id": 5 }
```

**Success Response:**

```json
{
  "status": "S100",
  "data": {
    "has_premium": true,
    "is_premium": 1,
    "premium_until": "2027-01-01 00:00:00"
  }
}
```

---

## 13. Dashboard

### `getDashboardSummary`

Admin use. No request body needed.

**Success Response:**

```json
{
  "status": "S100",
  "data": {
    "word_module": {
      "total_categories": 12,
      "total_levels": 48,
      "total_questions": 520,
      "total_paragraphs": 15
    },
    "subject_module": {
      "total_subjects": 5,
      "total_lessons": 30,
      "total_lesson_levels": 90,
      "total_lesson_questions": 450,
      "total_papers": 20,
      "total_paper_questions": 300,
      "total_short_notes": 10
    },
    "users": {
      "total_users": 250,
      "premium_users": 80,
      "active_users": 240
    },
    "payments": {
      "total_payments": 95,
      "pending_payments": 12,
      "verified_payments": 80,
      "rejected_payments": 3
    }
  }
}
```

---

### `getDashboardData`

Admin use. Returns summary + recent reports + recent payments.

**Request (optional):**

```json
{ "limit": 10 }
```

**Success Response:**

```json
{
  "status": "S100",
  "data": {
    "summary": { ... },
    "recent_question_reports": [
      { "id": 11, "question_id": 42, "user_name": "John", "reason": "Wrong answer", "reported_at": "..." }
    ],
    "recent_payments": [
      { "id": 8, "user_name": "Alice", "amount": 1500, "payment_method": "bank_transfer", "payment_status": "pending", "created_at": "..." }
    ]
  }
}
```

---

## Error Reference

| Code   | Meaning                                |
| ------ | -------------------------------------- |
| `S100` | Success                                |
| `E100` | Error (see `data` message for details) |

**Common error messages:**

| Message                                               | Cause                                     |
| ----------------------------------------------------- | ----------------------------------------- |
| `"Invalid token"`                                     | Token header missing or expired           |
| `"Missing required fields: ..."`                      | One or more required body fields not sent |
| `"No ... found"`                                      | Query returned empty result               |
| `"Phone number already registered"`                   | Duplicate phone on register               |
| `"Invalid paper_type. Use pass_paper or model_paper"` | Wrong enum value                          |
| `"Bank slip is required for bank transfer"`           | File not uploaded                         |

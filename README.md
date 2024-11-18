# Code Challenge

You are tasked with creating a simple Ruby application that simulates a basic API for managing a collection of books.

## Model design:
- `title` (string, required)
- `author` (string, required)
- `publication_date` (datetime, required)
- `rating` (integer, optional, default `0` - range `0 to 5`)
- `status` (string, optional, enum with values: `:available`, `:checked_out`, `:reserved`; default: `available`)

## Books Management api:
- Create a new book: with parameters title, author, and publication_date.
- List Books: Sort books by rating (high first) and then by publication date (soonest first).
- Update Book: Allows updating of status, and rating.
- Delete Book: Permanently removes a book from the collection.
- Find Book by ID: Retrieve detailed information about a specific book by its ID.

## Background Job (Bonus points):
### Status Change Notification
- When the status of a book is changed (e.g., from available to checked_out), immediately log a notification to the console, informing them about the status update.
  example: `Book status changed: 'Sample Book' is now 'checked_out'.`
- Use a background job (with ActiveJob and Sidekiq or Resque) to handle email sending asynchronously.

## Unit Tests:
Write unit tests for all models, controllers, and background jobs (if apply). Ensure tests for edge cases:
- Book creation with missing required fields.
- Book creation with a published_date set in the future.
- Status transitions (e.g., available → checked_out).
- Sorting by rating and published_date.
- Background job enqueuing (if apply).

## Requirements
- For storing the data you can use either an in-memory data structure (like an array or hash) or a loca DB.

## Constraints
- The challenge should be completed in 30-40 minutes.
- You may use any Ruby version that you are comfortable with.
- Clone and commit directly to main (DO NOT FORK).
- AI tools are NOT allowed (copilot, chatgpt, etc).

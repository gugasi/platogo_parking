# 🅿️ Platogo Parking API
**Developer:** Guram Sikharulidze 

A strict, RESTful JSON API built with Ruby on Rails and PostgreSQL to manage a 54-space parking lot. 

## 🛠 Architecture & Data Integrity
To ensure absolute data integrity, the application relies on strict database-level constraints and Active Record validations:
* **Capacity Control:** The `Ticket` model strictly validates that `active_in_lot.count` never exceeds the `MAX_SPACES` constant (54).
* **Uniqueness:** The 16-digit hex barcode is indexed and validated for uniqueness at the PostgreSQL database level.
* **Exit Window Logic:** Prices and Gate states dynamically calculate based on a precise `15.minutes` exit window from the `paid_at` timestamp.

## 🗄 Database Schema (Tickets)
| Column | Type | Constraints |
| :--- | :--- | :--- |
| `id` | bigint | Primary Key |
| `barcode` | string (16) | `null: false`, `unique: true`, hex regex validation |
| `issued_at` | datetime | `null: false` |
| `paid_at` | datetime | nullable |
| `payment_method`| string | nullable, inclusion: `[credit_card, debit_card, cash]` |
| `exited_at` | datetime | nullable, indexed for fast active capacity counting |

## Interactive API Tester
While the application is a pure backend API, I built a custom, retro-styled HTML dashboard to make testing the endpoints during the review visually clear and intuitive.

1. Boot the server: `rails server`
2. Open your browser and navigate to: `http://localhost:3000/parking_demo.html`
3. Click the UI to interact seamlessly with the live API routes.

## 🛣 Endpoints
* `POST /api/tickets` - Issue a new ticket.
* `GET /api/tickets/{barcode}` - Check the current price (€2 / started hour).
* `POST /api/tickets/{barcode}/payments` - Process payment.
* `GET /api/tickets/{barcode}/state` - Check if the gate opens (paid & within 15 mins).
* `GET /api/free-spaces` - Returns total, taken, and available spaces.

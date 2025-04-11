/*
 Scenario:
You are managing a mini Bookstore. The tables include:

Books(BookID, Title, Price, Stock)

Orders(OrderID, BookID, Quantity, TotalAmount)

Task:
Write a stored procedure that:

Begins a transaction.

Inserts a new order.

Updates stock in the Books table.

If stock is not enough, roll back the transaction.

If all is well, commit it.

Add a savepoint after inserting into Orders, and try rolling back just the stock update if there's an issue.

Optional:
Add PRINT statements or SELECT queries after each step to test it.
*/

BEGIN TRANSACTION;

-- Step 1: Insert Order
INSERT INTO Orders(OrderID, BookID, Quantity, TotalAmount)
VALUES (1, 1, 12, 1200);

-- Set a savepoint after successful order insert
SAVE TRANSACTION OrderAdd;

-- Step 2: Check stock and update
DECLARE @book_id INT = 1;
DECLARE @quantity INT = 12;

-- Optional: check if enough stock exists
IF EXISTS (
    SELECT 1 FROM Books WHERE BookID = @book_id AND Stock >= @quantity
)
BEGIN
    UPDATE Books
    SET Stock = Stock - @quantity
    WHERE BookID = @book_id;

    -- Everything went fine — commit!
    COMMIT;
END
ELSE
BEGIN
    -- Not enough stock — rollback to savepoint
    ROLLBACK TRANSACTION OrderAdd;

    -- Still need to rollback the rest of the transaction
    ROLLBACK;

    PRINT 'Order rolled back due to insufficient stock.';
END


